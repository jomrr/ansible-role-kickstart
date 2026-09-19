cat << EOF >> /etc/sysctl.d/90-harden-net-ipv4.conf
# Harden IPv4 settings
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.conf.default.rp_filter=2
net.ipv4.conf.default.secure_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_syncookies=1
EOF
chmod 0600 /etc/sysctl.d/90-harden-net-ipv4.conf
