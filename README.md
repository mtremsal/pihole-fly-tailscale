# pihole-fly-tailscale
Pi-hole deployed at the edge on Fly.io and accessed via TailScale

Note: this commit shows a naive and insecure deployment of Pi-hole where port 53 is exposed to the internet and bad actors can possibly leverage the instance.

## References

*  [Stuff Your Pi-Hole From Anywhere - fly.io](https://fly.io/blog/stuff-your-pi-hole-from-anywhere/)
*  [Access a Pi-hole from anywhere - tailscale.com](https://tailscale.com/kb/1114/pi-hole/)
*  [Tailscale on Fly.io - tailscale.com](https://tailscale.com/kb/1132/flydotio/)
*  [Docker container for Pi-hole - pi-hole.net](https://github.com/pi-hole/docker-pi-hole#readme)
*  [Run your own mesh VPN and DNS with Tailscale and PiHole - shotor.com](https://shotor.com/blog/run-your-own-mesh-vpn-and-dns-with-tailscale-and-pihole/)