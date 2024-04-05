# Ansible role kickstart

![GitHub](https://img.shields.io/github/license/jomrr/ansible-role-kickstart) ![GitHub last commit](https://img.shields.io/github/last-commit/jomrr/ansible-role-kickstart) ![GitHub issues](https://img.shields.io/github/issues-raw/jomrr/ansible-role-kickstart)

**Ansible role for generating kickstart files.**

## Description

Generate kickstart files for unattended installations with IPXE or virt-install.

## Prerequisites

This role has no special prerequisites.

### System packages (Fedora)

- `python3` (Python 3.8 or later)
- `pykickstart`

### Python (requirements.txt)

- ansible >= 2.15

## Dependencies (requirements.yml)

This role has no dependencies.

## Supported Platforms

| OS Family | Distribution | Version | Container Image |
|-----------|--------------|---------|-----------------|
| RedHat | Fedora | latest | [jomrr/molecule-fedora:latest]( https://hub.docker.com/r/jomrr/molecule-fedora ) |

## Role Variables

No role default variables specified, see [defaults/main.yml](defaults/main.yml).

## Example Playbook

Example playbooks(s) that show how to use this role.

## Simple example playbook

A simple default example playbook for using jomrr.kickstart.
```yaml
---
# name: "jomrr.kickstart"
# file: "playbook_kickstart.yml"

- name: "PLAYBOOK | kickstart"
  hosts: "kickstart_hosts"
  gather_facts: true
  roles:
    - role: "jomrr.kickstart"
```

## Author(s) and License

- :octocat:                 Author::    [jomrr](https://github.com/jomrr)
- :triangular_flag_on_post: Copyright:: 2022, Jonas Mauer
- :page_with_curl:          License::   [MIT](LICENSE)

## References

- [Kickstart Syntax Reference](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/appendixes/Kickstart_Syntax_Reference/)

---
