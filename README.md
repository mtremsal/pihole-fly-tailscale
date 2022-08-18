# pihole-fly-tailscale
Pi-hole deployed at the edge on Fly.io and accessed via TailScale

## Goals and Constraints

* Pi-hole is usable as a DNS resolver by trusted laptops and mobile devices
* Pi-hole is deployed at the edge, for low latency while traveling anywhere
* Pi-hole is NOT accessible from the public internet, to avoid making it available to bad actors
* Pi-hole is accessible from trusted devices only, via wireguard, courtesy of TailScale

## Setup

### Setup Pi-hole as a private Fly.io app connected by TailScale

1. Deploy and configure the app on Fly.io: `fly launch --no-deploy`, including:
   * Y      - Copy the toml configuration app to the new app
   * enter  - Leave the app name blank or provide your own
   * enter  - Pick the [region](https://fly.io/docs/reference/regions/) closest to your location
   * enter  - Use the provided Dockerfile to build an image
2. Set the password on Pi-Hole's web interface via the `WEBPASSWORD` environment variable: `fly secrets set WEBPASSWORD="<password>"`
3. Generate an ephemeral and reusable auth key in tailscale's [admin portal](https://login.tailscale.com/admin/settings/keys)
4. Store the auth key as a secret in fly.io: `fly secrets set TAILSCALE_AUTHKEY="tskey-<key>"`
5. Deploy to fly.io: `fly deploy`
6. (optional) [Scale the VM](https://fly.io/docs/reference/scaling/#scaling-virtual-machines) to a dedicated CPU and 2 GB of RAM: `fly scale vm dedicated-cpu-1x`
7. (optional) Troubleshoot the Pi-hole configuration via its web interface: `<tailscale IP>/admin`

### (optional) Configure all devices to use Pi-hole for DNS when connecting to the TailScale network

1. Open the [DNS configuration](https://login.tailscale.com/admin/dns) page
2. Add nameserver > custom > enter the TailScale private IP for the Pi-hole
3. Turn on `Override local DNS`

### Connect a new device

1. [Download](https://tailscale.com/download) and install tailscale on the device, then authenticate
2. There's no step 2! 🤯

## Known Limitations

* The Pi-hole currently starts before tailScale, resulting in a warning message in the Pi-hole diagnosis page that `interface tailscale0 does not currently exist`. Still, the Pi-hole resolves queries via its TailScale private IP, so this is not a real issue, merely a bit messy.
* When Fly rolls out a new version, it relies on a blue-green deployment approach by default, which means that Tailscale will display more than one machine for a certain period of time. Being "ephemeral", they're dropped after some amount of time being inactive.
* Configuring a backup public [DNS nameserver in Tailscale](https://login.tailscale.com/admin/dns) breaks the setup as TailScale seems to respond with whatever DNS resolver is faster, rather than trying them in order. This turns out to be a pretty big issue as if the Pi-hole goes offline, DNS resolution fails completely across the network. There are two potential workarounds, but neither is ideal:
  * Configure DNS Resolution on each device with Pi-hole as primary and public DNS resolvers as backup, OR
  * Disconnect a device entirely from TailScale when DNS misbehaves, so as to revert to its default configuration.

## Open Questions

* What's a less messy way to keep Docker running after it executes its `CMD` than running `tail -f /dev/null`? 
* Is there a way to show a private app, i.e. an app that doesn't expose any port to the public internet, as healthy in Fly.io? 
* Is there a need to [disable TailScale key expiry](https://login.tailscale.com/admin/machines) for the Pi-hole machine? Probably not, given that the auth key can be reused.

## References

*  [Stuff Your Pi-Hole From Anywhere - fly.io](https://fly.io/blog/stuff-your-pi-hole-from-anywhere/)
*  [Access a Pi-hole from anywhere - tailscale.com](https://tailscale.com/kb/1114/pi-hole/)
*  [Tailscale on Fly.io - tailscale.com](https://tailscale.com/kb/1132/flydotio/)
*  [Docker container for Pi-hole - pi-hole.net](https://github.com/pi-hole/docker-pi-hole#readme)
*  [Run your own mesh VPN and DNS with Tailscale and PiHole - shotor.com](https://shotor.com/blog/run-your-own-mesh-vpn-and-dns-with-tailscale-and-pihole/)