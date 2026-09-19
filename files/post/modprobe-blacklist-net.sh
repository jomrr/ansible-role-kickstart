set -euo pipefail

install -d -m 0755 /etc/modprobe.d

cat > /etc/modprobe.d/90-blacklist-net.conf <<'EOF'
install af_802154       /bin/false
install appletalk       /bin/false
install atm             /bin/false
install ax25            /bin/false
install can             /bin/false
install dccp            /bin/false
install decnet          /bin/false
install econet          /bin/false
install ipx             /bin/false
install n_hdlc          /bin/false
install netrom          /bin/false
install p8022           /bin/false
install p8023           /bin/false
install psnap           /bin/false
install rds             /bin/false
install rose            /bin/false
install sctp            /bin/false
install tipc            /bin/false
install x25             /bin/false
EOF
chmod 0600 /etc/modprobe.d/90-blacklist-net.conf
