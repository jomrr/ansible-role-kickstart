# Ansible role kickstart

![GitHub](https://img.shields.io/github/license/jam82/ansible-role-kickstart) ![GitHub last commit](https://img.shields.io/github/last-commit/jam82/ansible-role-kickstart) ![GitHub issues](https://img.shields.io/github/issues-raw/jam82/ansible-role-kickstart)

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
| RedHat | Fedora | latest | [jam82/molecule-fedora:latest]( https://hub.docker.com/r/jam82/molecule-fedora ) |

## Role Variables

No role default variables specified, see [defaults/main.yml](defaults/main.yml).

## Example Playbook

Example playbooks(s) that show how to use this role.

## Simple example playbook

A simple default example playbook for using jam82.kickstart.
```yaml
---
# name: "jam82.kickstart"
# file: "playbook_kickstart.yml"

- name: "PLAYBOOK | kickstart"
  hosts: "kickstart_hosts"
  gather_facts: true
  roles:
    - role: "jam82.kickstart"
```

## Author(s) and License

- :octocat:                 Author::    [jam82](https://github.com/jam82)
- :triangular_flag_on_post: Copyright:: 2022, Jonas Mauer
- :page_with_curl:          License::   [MIT](LICENSE)

## References

- [Kickstart Syntax Reference](https://docs.fedoraproject.org/en-US/fedora/f36/install-guide/appendixes/Kickstart_Syntax_Reference/)

---
