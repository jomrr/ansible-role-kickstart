# ansible-role-kickstart

![GitHub](https://img.shields.io/github/license/jam82/ansible-role-kickstart) ![GitHub last commit](https://img.shields.io/github/last-commit/jam82/ansible-role-kickstart) ![GitHub issues](https://img.shields.io/github/issues-raw/jam82/ansible-role-kickstart) ![Travis (.com) branch](https://img.shields.io/travis/com/jam82/ansible-role-kickstart/main?label=travis) [![Molecule](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml/badge.svg)](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml)

**Ansible role for creating kickstart files on remote host.**

## Supported Platforms

| OS Family | Distribution  | Latest | Supported Version(s) | Comment |
|-----------|---------------|--------|----------------------|---------|
| RedHat    | Almalinux     | :heavy_check_mark: | 8, 9 | |
|           | Fedora        | :heavy_check_mark: | 35, 36, Rawhide | |
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
kickstart_host: "{{ inventory_hostname }}"

# ks file for inventory_hostname will be created
# at this path on kickstart_host
kickstart_hostpath: "/tmp/{{ inventory_hostname }}.ks"

# generate reprducable MAC addresses for network cards based on hostname
kickstart_gen_mac_from_name: true

# number of MAC addresses to generate
# can be referenced in kickstart with _vm.macs[0], _vm.macs[1], etc.
kickstart_mac_count: 1

# see ouput of: `ksvalidator -l` for supported versions => FC3-6, F7-37, RHEL3-9
kickstart_version: RHEL8

# kickstart template
# see: https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/appendixes/Kickstart_Syntax_Reference
# variables here come from inventory
kickstart_template: | # noqa var-spacing
  eula        --agreed
  graphical
  skipx
  firstboot   --disable
  reboot      --eject
  url         --url=https://ftp.fau.de/almalinux/8/BaseOS/x86_64/os/
  clearpart   --all --drives=vda --initlabel
  ignoredisk  --only-use=vda
  zerombr

  # partitioning
  part /boot/efi  --asprimary --ondrive=vda --size=512      --fstype=efi    --fsoptions="umask=0077,shortname=winnt"
  part /boot      --asprimary --ondrive=vda --size=1024     --fstype=ext4   --fsoptions="noatime"
  part /tmp                                 --size=2048     --fstype=tmpfs  --fsoptions="noatime,nodev,noexec,nosuid,mode=1700"
  part pv.0       --asprimary --ondrive=vda --size 1 --grow --fstype=lvmpv

  # volume groups
  volgroup system pv.0

  # logical volumes
  logvol /              --vgname=system --name=root  --fstype=ext4  --size=8192  --fsoptions="relatime"
  logvol /home          --vgname=system --name=home  --fstype ext4  --size=2048  --fsoptions="nodev,nosuid,relatime"
  logvol /opt           --vgname=system --name=opt   --fstype ext4  --size=2048  --fsoptions="nodev,nosuid,relatime"
  logvol /srv           --vgname=system --name=srv   --fstype ext4  --size=4096  --fsoptions="nodev,nosuid,relatime"
  logvol /var           --vgname=system --name=var   --fstype ext4  --size=8192  --fsoptions="relatime"
  logvol /var/lib       --vgname=system --name=lib   --fstype ext4  --size=8192  --fsoptions="relatime"
  logvol /var/log       --vgname=system --name=log   --fstype ext4  --size=4096  --fsoptions="nodev,noexec,nosuid,noatime"
  logvol /var/log/audit --vgname=system --name=audit --fstype ext4  --size=4096  --fsoptions="nodev,noexec,nosuid,noatime"
  logvol /var/tmp       --vgname=system --name=tmp   --fstype ext4  --size=4096  --fsoptions="nodev,noexec,nosuid,noatime"
  logvol /var/www       --vgname=system --name=www   --fstype ext4  --size=4096  --fsoptions="nodev,noexec,nosuid,noatime"

  # network configuration
  network     --hostname={{ inventory_hostname }}
  network     --device=enp1s0 --noipv6 --bootproto=dhcp

  # keyboard, language and timezone configuration
  # timesource replaces "timezone --ntpservers=" from RHEL9 onwards
  keyboard    --vckeymap=de --xlayouts='de'
  lang        en_US.UTF-8 --addsupport=de_DE.UTF-8
  timezone    Europe/Berlin --utc --ntpservers=ntp3.fau.de
  # timesource  --ntp-server ntp3.fau.de

  rootpw {{ lookup('community.general.keyring','home root') | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }} --iscrypted

  user --name={{ lookup('community.general.keyring','home ansible_user') }} --password={{lookup('community.general.keyring','home ansible_become_pass') |           password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }} --iscrypted --shell=/bin/bash

  # add ssh keys
  sshkey --username=root "{{ lookup('community.general.keyring','home sshkey') }}"
  sshkey --username={{ lookup('community.general.keyring','home ansible_user') }} "{{ lookup('community.general.keyring','home sshkey') }}"

  # ssh access during installation
  sshpw --username=root {{ lookup('community.general.keyring','home root') | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }} --iscrypted
  sshpw --username={{ lookup('community.general.keyring','home ansible_user') }} {{ lookup('community.general.keyring','home ansible_become_pass') | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }} --iscrypted

  selinux   --enforcing

  services  --enabled="auditd,firewalld,rsyslog"

  %packages --ignoremissing
  @^minimal-environment
  bash
  bash-comppletion
  dnf-automatic
  dnf-plugins-core
  firewalld
  libpwquality
  python3
  python3-dnf
  python3-libselinux
  python3-libsemanage
  python3-pwquality
  realmd
  rsyslog
  qemu-guest-agent
  vim
  zstd
  -iw
  -iwl*-firmware
  -libsss_*
  -sssd
  -sssd-*
  -zram-generator*
  %end

  %anaconda
  pwpolicy root --minlen=16 --minquality=80 --strict --notempty --nochanges
  pwpolicy user --minlen=16 --minquality=60 --strict --notempty --nochanges
  pwpolicy luks --minlen=16 --minquality=60 --strict --notempty --nochanges
  %end

  %addon com_redhat_kdump --disable
  %end

  %post --log=/root/postinstall.log
  cat << EOF >> /etc/modprobe.d/harden.conf
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
  EOF
  %end
```

## Dependencies

None.

## Example Playbook

```yaml
---
# file: ansible/playbooks/kickstart.yml

- hosts: all
  gather_facts: false
  become: true
  vars:
    ansible_os_family: RedHat
    ansible_distribution: Fedora
    ansible_distribution_major_version: 36
  roles:
    - kickstart
```

## License and Author

- Author:: [jam82](https://github.com/jam82/)
- Copyright:: 2022, [jam82](https://github.com/jam82/)

Licensed under [MIT License](https://opensource.org/licenses/MIT).
See [LICENSE](https://github.com/jam82/ansible-role-kickstart/blob/master/LICENSE) file in repository.

## References

- [Fedora - Kickstart Syntax Reference](https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/appendixes/Kickstart_Syntax_Reference/)
