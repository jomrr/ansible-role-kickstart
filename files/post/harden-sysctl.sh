cat << EOF >> /etc/sysctl.d/90-harden-dev-tty.conf
# Disable TTY line discipline autoload
dev.tty.ldisc_autoload=0
EOF
chmod 0600 /etc/sysctl.d/90-harden-dev-tty.conf

cat << EOF >> /etc/sysctl.d/90-harden-fs.conf
# Protect file system objects
fs.protected_fifos=2
fs.protected_hardlinks=1
fs.protected_regular=2
fs.protected_symlinks=1
EOF
chmod 0600 /etc/sysctl.d/90-harden-fs.conf

cat << EOF >> /etc/sysctl.d/90-harden-kernel.conf
# Kernel self-protection settings
kernel.dmesg_restrict=1
kernel.kexec_load_disabled=1
kernel.kptr_restrict=2
kernel.perf_event_paranoid=3
kernel.printk=3 3 3 3
kernel.randomize_va_space=2
kernel.sysrq=0
kernel.unprivileged_bpf_disabled=1
kernel.yama.ptrace_scope=2
EOF
chmod 0600 /etc/sysctl.d/90-harden-kernel.conf

cat << EOF >> /etc/sysctl.d/90-harden-net-core.conf
# Harden BPF JIT
net.core.bpf_jit_harden=2
EOF
chmod 0600 /etc/sysctl.d/90-harden-net-core.conf

cat << EOF >> /etc/sysctl.d/90-harden-vm.conf
# Randomize memory mappings
vm.mmap_rnd_bits=32
vm.mmap_rnd_compat_bits=16

# Disable unprivileged userfaultfd
vm.unprivileged_userfaultfd=0
EOF
chmod 0600 /etc/sysctl.d/90-harden-vm.conf
