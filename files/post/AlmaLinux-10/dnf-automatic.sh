dnf install --setopt=install_weak_deps=False -y dnf-automatic

cat << EOF > /etc/dnf/automatic.conf
[commands]
apply_updates = yes
upgrade_type = default
EOF

systemctl enable dnf-automatic.timer
