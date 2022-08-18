FROM pihole/pihole:latest

# Allow DNSMasq (used by Pi-hole) to listen only on the tailscale0 network interface for DNS traffic
ENV INTERFACE tailscale0
ENV DNSMASQ_LISTENING single

# Install Tailscale on debian
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
RUN apt-get update && apt-get install tailscale iptables libip4tc2 libip6tc2 libjansson4 libnetfilter-conntrack3 libnfnetlink0 libnftables1 libnftnl11 netbase nftables

# Prepare to start tailscaled
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Load tailscale startup script
WORKDIR /app
COPY ./start.sh ./
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]