set -euo pipefail

# PAM limits (interactive logins)
install -d -m 0755 /etc/security/limits.d

cat > /etc/security/limits.d/99-disable-coredumps.conf <<'EOF'
* soft core 0
* hard core 0
EOF

# systemd-coredump (services)
install -d -m 0755 /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/99-disable.conf <<'EOF'
[Coredump]
Storage=none
ProcessSizeMax=0
ExternalSizeMax=0
JournalSizeMax=0
EOF

# systemd default limits (system services)
cp -fa /usr/lib/systemd/system.conf /etc/systemd/system.conf

grep -q '^DefaultLimitCORE=' /etc/systemd/system.conf \
  && sed -i 's/^DefaultLimitCORE=.*/DefaultLimitCORE=0/' /etc/systemd/system.conf \
  || echo 'DefaultLimitCORE=0' >> /etc/systemd/system.conf

# systemd default limits (user services)
cp -fa /usr/lib/systemd/user.conf /etc/systemd/user.conf

grep -q '^DefaultLimitCORE=' /etc/systemd/user.conf \
  && sed -i 's/^DefaultLimitCORE=.*/DefaultLimitCORE=0/' /etc/systemd/user.conf \
  || echo 'DefaultLimitCORE=0' >> /etc/systemd/user.conf

# kernel-side hardening knobs
cat << EOF > /etc/sysctl.d/99-disable-coredumps.conf
# Restrict core dumps for privileged programs
fs.suid_dumpable = 0
kernel.core_pattern=|/bin/false
EOF
