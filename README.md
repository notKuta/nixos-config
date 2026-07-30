# NixOS Configuration + "Install Guide"

This repository stores my personal configuration for NixOS. Feel free
to try it! To do so, simply clone the repo and copy its contents
into `/etc/nixos`:

```bash
git clone https://github.com/notKuta/nixos-config.git

cd nixos-config

cp * /etc/nixos
```

Then, simply rebuild the system with:

```bash
sudo nixos-rebuild switch
````

>[!caution]
> Make sure to replace the `desktop-hardware-configuration.nix` file with your
> own---usually called `hardware-configuration.nix`. This is usually
> where critical information, such as the file systems that need to be mounted, is stored
> and is normally generated during installation. 

## "Install Guide"

To see a "common sense" manual installation guide click [here.](https://github.com/notKuta/nixos-config/blob/experimental/install_guide.md)
This is a quick write-up I wrote since I was tired of scouring
through random webpages just to deploy a new system. These steps describe how to
deploy a new system with:

- LUKS-based encryption

- TPM auto-unlocking

- Swapfile

This does **NOT** cover all edge-cases nor is it exhaustive. In such cases,
the proper documentation should be referred to---see [here](https://nixos.org/manual/nixos/stable/)
or the [NixOS wiki](https://wiki.nixos.org/wiki/NixOS_Wiki).
