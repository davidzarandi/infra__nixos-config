# infra__nixos-config

Welcome to my personal NixOS Configuration repository!

## Common commands

- `nix --experimental-features 'nix-command flakes' flake check .#<hostname>` - Checks configuration
- `nix-shell -p git` - Temporarily enables git in shell
- `nix run github:nix-community/disko -- --mode disko --flake github:davidzarandi/infra__nixos-config#<hostname>`
- `nixos-install --flake github:davidzarandi/infra__nixos-config#<hostname>` - Installs NixOS to system

## License

This project is licensed under the [BSD-3-Clause](LICENSE).