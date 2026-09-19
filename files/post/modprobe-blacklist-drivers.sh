set -euo pipefail

install -d -m 0755 /etc/modprobe.d

cat > /etc/modprobe.d/90-blacklist-drivers.conf <<'EOF'
install bluetooth       /bin/false
install btusb           /bin/false
install dvb_core        /bin/false
install firewire-core   /bin/false
install firewire-ohci   /bin/false
install firewire-sbp2   /bin/false
#install usb-storage     /bin/false
install uvcvideo        /bin/false
install vivid           /bin/false
EOF
chmod 0600 /etc/modprobe.d/90-blacklist-drivers.conf
