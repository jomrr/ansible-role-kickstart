set -euo pipefail

install -d -m 0755 /etc/modprobe.d

cat > /etc/modprobe.d/90-blacklist-fs.conf <<'EOF'
install cramfs          /bin/false
install freevxfs        /bin/false
install gfs2            /bin/false
install hfs             /bin/false
install hfsplus         /bin/false
install jffs2           /bin/false
#install squashfs        /bin/false
install udf             /bin/false
EOF
chmod 0600 /etc/modprobe.d/90-blacklist-fs.conf
