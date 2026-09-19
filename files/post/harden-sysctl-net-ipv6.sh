cat << EOF >> /etc/sysctl.d/90-harden-net-ipv6.conf
# Harden IPv6 settings
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.all.accept_source_route=0
net.ipv6.conf.all.use_tempaddr=2
net.ipv6.conf.default.accept_ra=0
net.ipv6.conf.default.accept_redirects=0
net.ipv6.conf.default.accept_source_route=0
net.ipv6.conf.default.use_tempaddr=0
EOF
chmod 0600 /etc/sysctl.d/90-harden-net-ipv6.conf
