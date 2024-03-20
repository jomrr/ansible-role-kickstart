# Contributing to kickstart

Thank you for your interest in contributing to the Ansible role kickstart.

Your contribution is welcome to help improve and enhance this role.

## Getting Started

To get started with contributing, please follow these steps:

1. Fork the repository and clone it to your local machine.
2. Create a new branch for your changes: `git checkout -b {feature,fix}/my-feature`.
3. Make your desired changes to the role.
4. Test your changes to ensure they work as expected.
5. Commit your changes: `git commit -m "feat: Add my feature"` using Angular Commit Convention.
6. Push your changes to your forked repository: `git push origin my-feature`.
7. Open a pull request in the main repository.

## Code Style

Please follow the Ansible recommended best practices and style guidelines when making changes to the role.
This helps maintain consistency and readability across the codebase.

## Testing

Pleas make sure your contributions comply to standard `ansible-lint` rules and
pass the molecule tests for all supported platforms.
This ensures that the role continues to work as expected and prevents regressions.

You can run the existing tests locally using the following command:

```bash
molecule test --scenario-name all
```

This is using the `molecule-plugins[podman]` driver, so podman is required.
