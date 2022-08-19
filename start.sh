#!/bin/sh

# The `--accept-dns=false` argument ensures that Pi-hole does NOT get configured to use itself
# for DNS resolution, creating a circular dependency.
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${FLY_APP_NAME} --accept-dns=false

# This is a silly hack to ensure the container doesn't stop after `start.sh` is done running.
# See https://fly.io/docs/app-guides/multiple-processes/
tail -f /dev/null