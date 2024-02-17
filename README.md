# tmpl__nixos-config

Welcome to the NixOS Configuration Template repository! This template is designed to jumpstart your journey in NixOS.

## Getting Started

1. Creating your repository:
  - Click the **Use this template** button at the top of the repository.
  - Enter a name for your repository and click **Create repository from template**.
2. Local setup:
  - Clone your newly created repository to your local machine.
  - Navigate to the repository folder in your favourite IDE/text editor.
3. Workflow
  - `nix --experimental-features 'nix-command flakes' flake check .#<hostname>` - Checks your configuration
  - `nixos-install --flake https://github.com/<username>/<repository>#<hostname>` - Installs your NixOS configuration

You can find an example configuration in the [example folder](per-hostname/example)

## License

This project is licensed under the [BSD-3-Clause](LICENSE).