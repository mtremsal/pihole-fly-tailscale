#!/bin/sh

tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=pihole-fly-tailscale --accept-dns=false
tail -f /dev/null