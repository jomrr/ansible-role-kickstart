# Ansible Role: kickstart

![GitHub](https://img.shields.io/github/license/jomrr/ansible-role-kickstart)
![GitHub last commit](https://img.shields.io/github/last-commit/jomrr/ansible-role-kickstart)
![GitHub issues](https://img.shields.io/github/issues-raw/jomrr/ansible-role-kickstart)
[![dev](https://img.shields.io/github/actions/workflow/status/jomrr/ansible-role-kickstart/dev.yml?branch=dev&label=dev)](https://github.com/jomrr/ansible-role-kickstart/actions/workflows/dev.yml?query=branch%3Adev)
[![main](https://img.shields.io/github/actions/workflow/status/jomrr/ansible-role-kickstart/main.yml?branch=main&label=main)](https://github.com/jomrr/ansible-role-kickstart/actions/workflows/main.yml?query=branch%3Amain)

Ansible role for generating validated kickstart files for AlmaLinux and Fedora.

## Purpose

Generate kickstart files for unattended AlmaLinux and Fedora installations,
for example with iPXE or virt-install. The role installs pykickstart on the
host it runs on and renders one file per entry in kickstart_files. Every
file is validated with ksvalidator before it replaces its destination, so a
successful run guarantees syntactically valid kickstart files. Repeated runs
with unchanged input report no change.

## Scope

### Managed

- Installation of pykickstart on the host running the role.
- One validated kickstart file per entry in kickstart_files.

### Not Managed

- Serving kickstart files over HTTP, TFTP or installation media.
- Provisioning of the machines that consume the kickstart files.
- Removal of kickstart files whose entries were dropped from kickstart_files.

## Requirements

- Run the role on a host whose distribution matches the kickstart files, because
  ksvalidator must know their syntax version, see ksvalidator -l. Fedora 44
  files need a Fedora host: the pykickstart of AlmaLinux 10.2 knows Fedora
  versions up to F40.
- AlmaLinux files with a Btrfs layout, which is the default layout, need
  AlmaLinux 10.2 or later. Only its pykickstart build carries the patch that
  restores Btrfs for the RHEL10 syntax; other builds reject it.

## Role Variables

### `kickstart_defaults`

Type: `dict`. Required: `false`.

Values shared by all kickstart files; every key can be overridden per entry in
kickstart_files.
Each value is a raw kickstart command line or a list of them. An empty or
missing key omits its section. The keys version, url and repos default to the
values of the selected distribution and major version in vars/.

Default:

```yaml
kickstart_defaults:
  target: text
  ignoredisk: ignoredisk --only-use=vda
  bootloader: bootloader --driveorder=vda --location=mbr
  hardware: vm
  kernel_cmdline: []
  clearpart: clearpart --all --initlabel --drives=vda
  partitions:
    - part /boot/efi --ondrive=vda --size=2048     --fstype=efi   --fsoptions="umask=0077,shortname=winnt"
    - part /proc                                   --fstype=proc  --fsoptions="defaults,hidepid=2"
    - part btrfs.0   --ondrive=vda --size=1 --grow --fstype=btrfs --fsoptions="compress=zstd:3,noatime"
  logvols: []
  volgroups: []
  btrfs_volumes:
    - btrfs none                 --label=system               btrfs.0
  btrfs_subvolumes:
    - btrfs /boot                --subvol --name=@boot        system
    - btrfs /                    --subvol --name=@            system
    - btrfs /home                --subvol --name=@home        system
    - btrfs /opt                 --subvol --name=@opt         system
    - btrfs /srv                 --subvol --name=@srv         system
    - btrfs /var                 --subvol --name=@var         system
    - btrfs /var/lib             --subvol --name=@varlib      system
    - btrfs /var/lib/containers  --subvol --name=@containers  system
    - btrfs /var/lib/machines    --subvol --name=@machines    system
    - btrfs /var/lib/portables   --subvol --name=@portables   system
    - btrfs /var/log             --subvol --name=@log         system
    - btrfs /var/log/audit       --subvol --name=@audit       system
    - btrfs /var/spool/mail      --subvol --name=@mail        system
    - btrfs /var/tmp             --subvol --name=@tmp         system
    - btrfs /var/www             --subvol --name=@www         system
  networks:
    - network --bootproto=dhcp
  firewall: firewall --enabled --ssh
  services: services --enabled=auditd,sshd
  selinux: selinux --enforcing
  skipx: true
  xconfig: ''
  authselect: ''
  groups: []
  users: []
  rootpw: rootpw --lock
  sshkeys:
    - sshkey --username=root "{{ lookup('ansible.builtin.url', 'https://github.com/jomrr.keys',
      wantlist=true) | first }}"
  sshpw: ''
  pwpolicies: []
  realm: ''
  keyboard: keyboard --vckeymap=de --xlayouts=de
  language: lang en_US.UTF-8 --addsupport=de_DE.UTF-8
  timezone: timezone Europe/Berlin --utc
  timesource: timesource --ntp-pool de.pool.ntp.org
  vnc: ''
  packages: []
  finish: reboot --eject
  post_scripts:
    disable-coredumps: true
    modprobe-blacklist-drivers: true
    modprobe-blacklist-fs: true
    modprobe-blacklist-net: true
    harden-sysctl-net-ipv4: true
    harden-sysctl-net-ipv6: true
    harden-sysctl: true
    systemd-disable-sleep: true
```

### `kickstart_files`

Type: `list`. Required: `false`.

Kickstart files to create. Each entry is merged over kickstart_defaults and
accepts the same keys.

Default:

```yaml
kickstart_files: []
```

## Managed Files

- `<dest>` Every kickstart_files entry names its own absolute destination path;
  files are written with mode 0660.

## Check Mode

Reports the pykickstart installation and changed kickstart files without writing
them.

- ksvalidator only runs when a file is actually written, not during check mode.

## Service Behavior

The role manages no services and has no handlers.

## Security Notes

- Generated systems are reachable through SSH keys only. The default locks the
  root password and authorizes the first public key published at
  <https://github.com/jomrr.keys> for root. Override sshkeys unless the owner of
  this key should have root access to the installed systems.
- ksvalidator accepts only one sshkey command per user, so further keys must be
  added after installation.
- The default sshkeys value is loaded from GitHub on every run, so the host
  running the role needs network access to github.com.
- The role is designed to render no secrets. Password hashes set through rootpw
  or users are written to the kickstart file and appear in the task output when
  Ansible runs with --diff.

## Operational Notes

- Each file is built from three layers, later ones win: the distribution values
  in vars/, then kickstart_defaults, then the kickstart_files entry.
- distribution and distribution_major_version of an entry select the file
  `vars/<distribution>-<distribution_major_version>.yml`. It holds the
  distribution package sets and the defaults for version, url and repos. The
  role ships AlmaLinux-10 and Fedora-44; another release is supported by adding
  its vars file.
- Packages are built from sets: the common sets of vars/main.yml plus the sets
  of the distribution. The hardware profile selects them: vm renders the virtual
  machine sets, amd and intel render the bare-metal sets with the vendor GPU
  firmware. The packages key adds further packages.
- Kernel arguments come from the hardware profile: vm renders the base hardening
  arguments, amd and intel add the bare-metal and the vendor IOMMU arguments.
  kernel_cmdline appends further arguments. The role renders them as --append of
  the bootloader command and overrides an --append given there.
- Values are raw kickstart command lines. pykickstart treats a # inside an
  unquoted word as the start of a comment, so quote values that contain it.
- post_scripts enables the built-in hardening scripts from files/post/. All are
  on by default. Because entries are merged recursively, an entry switches a
  single script off by setting only that key to false. The post key renders an
  additional script after them.
- Commands rendered into every file (eula, firstboot, zerombr, disabled kdump
  add-on) are not configurable.

## Supported Platforms

| OS Family | Distribution | Version | Container Image |
| --------- | ------------ | ------- | --------------- |
| RedHat | AlmaLinux | 10 | [jomrr/molecule-almalinux:10](https://hub.docker.com/r/jomrr/molecule-almalinux) |
| RedHat | Fedora | latest | [jomrr/molecule-fedora:latest](https://hub.docker.com/r/jomrr/molecule-fedora) |

## Example Playbook

### Generate AlmaLinux and Fedora kickstart files

Each play runs on a host of the matching distribution. The files use the
defaults and only set their destination, distribution and host name.

```yaml
- name: Generate AlmaLinux kickstart files
  hosts: almalinux_host
  gather_facts: false
  roles:
    - role: jomrr.kickstart
      kickstart_files:
        - dest: /srv/kickstart/alma.example.com.ks
          distribution: AlmaLinux
          distribution_major_version: "10"
          networks:
            - "network --bootproto=dhcp --hostname=alma.example.com"

- name: Generate Fedora kickstart files
  hosts: fedora_host
  gather_facts: false
  roles:
    - role: jomrr.kickstart
      kickstart_files:
        - dest: /srv/kickstart/fedora.example.com.ks
          distribution: Fedora
          distribution_major_version: "44"
          networks:
            - "network --bootproto=dhcp --hostname=fedora.example.com"
```

## References

- [Kickstart syntax reference](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
- [AlmaLinux kickstart guide](https://wiki.almalinux.org/documentation/kickstart-guide.html)
- [AlmaLinux pykickstart Btrfs patch](https://git.almalinux.org/rpms/pykickstart)

## Author

[Jonas Mauer](https://github.com/jomrr)

## License

This project is licensed under the MIT License.
See [LICENSE](LICENSE) for the full license text.

Copyright (c) 2022-2026 Jonas Mauer.
