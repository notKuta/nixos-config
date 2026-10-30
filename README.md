# NixOS Configuration + "Install Guide"

NixOS is a unique GNU/Linux distribution which leverages the Nix package
manager to enable its highly declarative design and atomic-based upgrades. For more
information, one may refer to its [official website](https://nixos.org/) for a
more proper introduction.

This repository stores my personal configuration for said OS.

## Overview / Structure

Within this directory, there are various subdirectories with different
purposes:

```console
.
├── configs
├── flake.lock
├── flake.nix
├── hosts
├── misc
├── README.md
└── wallpapers
```

### configs

This is the directory where various dotfiles or configuration files for
various packages are stored. Usually, the home-manager utility will be used
to facilitate the usage of these.

### hosts

General options and host-specific options are stored here. General options
are imported to the host-specific files which are then imported by their
respective hosts as a module within the `flake.nix`.

### misc

Where various miscellaneous files are stored that don't adhere to any of the
other directories (and I don't want them to clog up the root of the directory).

### wallpapers

Self-explanatory. Any images used to customize the system will be stored here.

## "Install Guide"

To see a "common sense" manual installation guide click [here.](https://github.com/notKuta/nixos-config/blob/496dea02908f54a52c722c010bddf84491aacb57/misc/install_guide.md)
This is a quick write-up I wrote since I was tired of scouring
through random webpages just to deploy a new system. These steps describe how to
deploy a new system with:

- LUKS-based encryption

- TPM auto-unlocking

- Swapfile

This does **NOT** cover all edge-cases nor is it exhaustive. In such cases,
the proper documentation should be referred to---see [here](https://nixos.org/manual/nixos/stable/)
or the [NixOS wiki](https://wiki.nixos.org/wiki/NixOS_Wiki).
