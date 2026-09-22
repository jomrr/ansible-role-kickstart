cat >> /etc/fstab << 'EOF'
tmpfs                                     /dev/shm                tmpfs   defaults,nodev,nosuid,noexec 0 0
EOF
restorecon /etc/fstab
