dnf install --setopt=install_weak_deps=False -y dnf5-plugin-automatic

cat << EOF > /etc/dnf/automatic.conf
[commands]
apply_updates = yes
reboot = when-needed
upgrade_type = default
EOF

systemctl enable dnf5-automatic.timer
