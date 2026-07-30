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

## "Install Guide"

To see a "common sense" manual installation guide click [here.]()
This is a quick write-up I wrote describing the steps I take to
deploy a new system with LUKS-based encryption, TPM auto-unlocking, and a swapfile.
This does NOT cover all edge-cases and in such cases the proper documentation
should be referred to---see [here](), for instance.
