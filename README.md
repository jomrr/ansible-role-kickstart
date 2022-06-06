# ansible-role-kickstart

![GitHub](https://img.shields.io/github/license/jam82/ansible-role-kickstart) ![GitHub last commit](https://img.shields.io/github/last-commit/jam82/ansible-role-kickstart) ![GitHub issues](https://img.shields.io/github/issues-raw/jam82/ansible-role-kickstart) ![Travis (.com) branch](https://img.shields.io/travis/com/jam82/ansible-role-kickstart/main?label=travis) [![Molecule](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml/badge.svg)](https://github.com/jam82/ansible-role-kickstart/actions/workflows/molecule.yml)

**Ansible role for setting up kickstart.**

## Supported Platforms

| OS Family | Distribution  | Latest | Supported Version(s) | Comment |
|-----------|---------------|--------|----------------------|---------|
| Alpine    | Alpine        | :heavy_check_mark: | 3.16 | |
| Archlinux | Archlinux     | :heavy_check_mark: | - | |
|           | Manjaro       | :heavy_check_mark: | - | |
| Debian    | Debian        | :heavy_check_mark: | 11 | |
|           | Ubuntu        | :heavy_check_mark: | 22.04 | |
| RedHat    | Almalinux     | :heavy_check_mark: | 9 | |
|           | Fedora        | :heavy_check_mark: | 35, 36, Rawhide | |
| Suse      | OpenSuse Leap | :heavy_check_mark: | 15.3 | |
|           | Tumbleweed    | :heavy_check_mark: | - | |

## Requirements

Ansible 2.9 or higher.

## Variables

Variables and defaults for this role.

### defaults/main.yml

```yaml
kickstart_host: localhost
kickstart_version: "RHEL9"
```

## Dependencies

None.

## Example Playbook

```yaml
---
# role: ansible-role-kickstart
# play: kickstart
# file: kickstart.yml

- hosts: all
  gather_facts: true
  roles:
    - role: ansible-role-kickstart
```

## License and Author

- Author:: [jam82](https://github.com/jam82/)
- Copyright:: 2022, [jam82](https://github.com/jam82/)

Licensed under [MIT License](https://opensource.org/licenses/MIT).
See [LICENSE](https://github.com/jam82/ansible-role-kickstart/blob/master/LICENSE) file in repository.

## References

- [Fedora - Kickstart Syntax Reference](https://docs.fedoraproject.org/en-US/fedora/latest/install-guide/appendixes/Kickstart_Syntax_Reference/)
