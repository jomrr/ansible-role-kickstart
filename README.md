# ansible-role-kickstart

![GitHub](https://img.shields.io/github/license/jam82/ansible-role-kickstart) ![GitHub last commit](https://img.shields.io/github/last-commit/jam82/ansible-role-kickstart) ![GitHub issues](https://img.shields.io/github/issues-raw/jam82/ansible-role-kickstart) ![Travis (.com) branch](https://img.shields.io/travis/com/jam82/ansible-role-kickstart/main?label=travis) [![Molecule](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml/badge.svg)](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml)

**Ansible role for creating kickstart files on remote host.**

## Supported Platforms

| OS Family | Distribution  | Latest | Supported Version(s) | Comment |
|-----------|---------------|--------|----------------------|---------|
| RedHat    | Almalinux     | :heavy_check_mark: | 8, 9 | |
|           | Fedora        | :heavy_check_mark: | 38, Rawhide | |
| OpenSuse  | Leap          | :heavy_check_mark: | 15.x | |
|           | Tumbleweed    | :heavy_check_mark: | latest | |

## Requirements

Ansible 2.9 or higher.

## Variables

Variables and defaults for this role.

### defaults/main.yml

```yaml
---
# role: ansible-role-kickstart
# file: defaults/main.yml

# ks file will be created and validated on kickstart_host.
# this can e.g. be the controller or a web-server.
# the pykickstart package is installed on kickstart_host.
kickstart_host: "localhost"

# ks file for inventory_hostname will be created
# at this absolute path on kickstart_host
kickstart_hostpath: "/tmp/{{ inventory_hostname }}.cfg"

# generate reprducable MAC addresses for network cards based on hostname
kickstart_gen_mac_from_name: true

# number of MAC addresses to generate
# can be referenced in kickstart with _vm.macs[0], _vm.macs[1], etc.
kickstart_mac_count: 1

# see ouput of: `ksvalidator -l` for supported versions => FC3-6, F7-39, RHEL3-9
kickstart_version: F38

# architecture for repo urls, use values of ansible_architecture
kickstart_arch: "x86_64"

# the default mirror to use
kickstart_mirror: https://mirror.mauer.in

# default rpmfusion mirror
kickstart_mirror_rpmfusion: https://mirror.mauer.in/fedora/rpmfusion

# --- kickstart template variables start here -------------------------------- #

# the boot target
kickstart_target: graphical

# install mirror
kickstart_url: "url --url={{ kickstart_mirrors.fedora.everything.url }}"

# additional repos
kickstart_repos:
  - "repo --url={{ kickstart_mirrors.fedora.everything_updates.url }} \
    --install --cost=0"

# bootloader settings
kickstart_bootloader: "bootloader --driveorder=vda --location=mbr \
  --password=S3cret!"

# delete partitions
kickstart_clearpart: "clearpart --all --drives=vda"

# initialize partition table
kickstart_zerombr: zerombr

# partitions take precedence over autopart and autopart over reqpart
kickstart_autopart: "--fstype=btrfs"

# partitions take precedence over autopart and autopart over reqpart
kickstart_reqpart: "reqpart --add-boot"

# partitions
kickstart_partitions:
  - "part /boot/efi --asprimary --ondrive=vda --size=512      --fstype=efi   \
    --fsoptions=\"umask=0077,shortname=winnt\""
  - "part /boot     --asprimary --ondrive=vda --size=1024     --fstype=ext4  \
    --fsoptions=\"noatime\""
  - "part /tmp                                --size=4096     --fstype=tmpfs \
    --fsoptions=\"noatime,nodev,noexec,nosuid,mode=1700\""
  - "part btrfs.0               --ondrive=vda --size=1 --grow --fstype=btrfs \
    --fsoptions=\"autodefrag,compress=zstd,noatime,space_cache=v2\""

# logical volumes
kickstart_logvols: []

# volume groups
kickstart_volgroups: []

# btrfs volumes
kickstart_btrfs_volumes:
  - "btrfs /mnt/btrfs/system    --label=system               btrfs.0"

# btrfs subvolumes
kickstart_btrfs_subvolumes:
  - "btrfs /                    --subvol --name=@            LABEL=system"
  - "btrfs /home                --subvol --name=@home        LABEL=system"
  - "btrfs /opt                 --subvol --name=@opt         LABEL=system"
  - "btrfs /srv                 --subvol --name=@srv         LABEL=system"
  - "btrfs /var                 --subvol --name=@var         LABEL=system"
  - "btrfs /var/lib             --subvol --name=@varlib      LABEL=system"
  - "btrfs /var/lib/containers  --subvol --name=@containers  LABEL=system"
  - "btrfs /var/lib/machines    --subvol --name=@machines    LABEL=system"
  - "btrfs /var/lib/portables   --subvol --name=@portables   LABEL=system"
  - "btrfs /var/log             --subvol --name=@log         LABEL=system"
  - "btrfs /var/log/audit       --subvol --name=@audit       LABEL=system"
  - "btrfs /var/spool/mail      --subvol --name=@mail        LABEL=system"
  - "btrfs /var/tmp             --subvol --name=@tmp         LABEL=system"
  - "btrfs /var/www             --subvol --name=@www         LABEL=system"

# firewall configration
kickstart_firewall: "firewall --enabled --ssh"

# service configuration
kickstart_services: "services --enabled=auditd,ssh"

# selinux status
kickstart_selinux: "selinux --enforcing"

# do not configure x window system
kickstart_skipx: false

# configure x window system
kickstart_xconfig: ''

# configure authentication
kickstart_authselect: ''

# create user groups
kickstart_groups: []

# create users
kickstart_users: []

# root password
kickstart_rootpw: "rootpw Strunz3nOed=! --plaintext"

# ssh keys
kickstart_sshkeys: []

# restrict ssh access during installation
kickstart_sshpw: ''

# configure system password policies
kickstart_pwpolicies:
  - "pwpolicy root --minlen=16 --minquality=80 --strict --notempty --nochanges"
  - "pwpolicy user --minlen=16 --minquality=60 --strict --notempty --nochanges"

# network interfaces
kickstart_networks:
  - "network --hostname={{ inventory_hostname }} \
    --device={{ _vm.macs[0] }} --bindto=mac --bootproto=dhcp"

# join realm or ad domain
kickstart_realm: ''

# keyboard and keymap settings
kickstart_keyboard: "keyboard --vckeymap=de --xlayouts=de"

# language settings
kickstart_language: "lang en_US.UTF-8 --addsupport=de_DE.UTF-8"

# timezone and ntp configuration, depending on kickstart version
kickstart_timezone: "timezone Europe/Berlin --utc --ntpservers=de.pool.ntp.org"

# timesource: ntp server, pool or disable
kickstart_timesource: ''

# vnc remote access
kickstart_vnc: ''

# packages to install and remove from installation.
kickstart_packages:
  - "@^minimal-environment"
  - bash
  - bash-completion
  - dnf-automatic
  - dnf-plugins-core
  - firewalld
  - libpwquality
  - neovim
  - python3
  - python3-dnf
  - python3-libselinux
  - python3-libsemanage
  - python3-pwquality
  - qemu-guest-agent
  - zstd
  - -abrt*
  - -iw*
  - -libsss_*
  - -nano
  - -setroubleshoot*
  - -sssd*
  - -vi
  - -vim
  - -vim-minimal
  - -zram-generator*

# post-install actions
kickstart_post: |-
  cat << EOF >> /etc/modprobe.d/hardening.conf
  install cramfs /bin/true
  install freevxfs /bin/true
  install jffs2 /bin/true
  install hfs /bin/true
  install hfsplus /bin/true
  install squashfs /bin/true
  install udf /bin/true
  install dccp /bin/true
  install sctp /bin/true
  install rds /bin/true
  install tipc /bin/true
  install usb_storage /bin/true
  EOF

# system operation after installation, can be halt, reboot, poweroff, shutdown
kickstart_finish: 'reboot --eject'

# If you define kickstart_template, only this will be used
# kickstart_template:
```

## Dependencies

None.

## Example Playbook

```yaml
---
# file: ansible/playbooks/kickstart.yml

- hosts: vms
  gather_facts: false
  vars:
    ansible_os_family: RedHat
    ansible_distribution: Fedora
    ansible_distribution_major_version: 38
  roles:
    - kickstart
```

## License and Author

- Author:: [jam82](https://github.com/jam82/)
- Copyright:: 2022, [jam82](https://github.com/jam82/)

Licensed under [MIT License](https://opensource.org/licenses/MIT).
See [LICENSE](https://github.com/jam82/ansible-role-kickstart/blob/master/LICENSE) file in repository.

## References

- [Fedora - Kickstart Syntax Reference](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/appendixes/Kickstart_Syntax_Reference/)
