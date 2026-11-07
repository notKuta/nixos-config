# Optical Audio Issues with JDS Labs Atom 2 DAC And Its Fix

## The Problem

So, to explain the genesis of why I even had to solve this problem: I recently
purchased a new DAC for myself to complement my amplifier I bought earlier this year.
I like audio, I think its a cool world---I shudder at the usage of the term `audiophile`
however, like ew---and my current headphones have a fairly high impedance---at least
higher than anything you'd find on a regular set of earbuds or headphones. This usually
would implicate overall volume issues but I found that my volume was "fine" for the most part
and could be pushed sufficiently. Nevertheless, I caved to my over-optimization ridden brain 
and bought my amplifier---the JDS Labs Amp 2 for those keeping score at home. Few months
would pass and I was really happy with the amp overall. So I thought: "Why not finish out
the audio stack and get the DAC as well." Oh, how I was in for a rude awakening.

To put it simply, whenever I would connect my DAC to my motherboards optical out / TOSLINK
port and start listening to any form of audio there would be slight "hitches" and the audio
would randomly drop-out. Which if you're listening to Quadeca's new hit album, life1, is not
what you want in an audio interface!

So, I scurried across the internet and surfed far and wide until I stumbled across a Reddit
thread that mentioned my problem, a DAC from the same company, and A LINK! CAN YOU BELIEVE IT!
A LINK! Which can be found [here](https://jdslabs.com/support/troubleshooting/#category-1-question-5).

TLDR: The solution included flashing a purpose-built firmware version onto your DAC, restarting it,
and then voila everything would be fixed.

To flash firmware for the device you have to connect it via USB to your PC, visit [this](https://pwatest.jdslabs.com/dfu.php)
site, choose your DAC (or have it autodetected by your browser), choose what firmware you want flashed, then
go along with the guided process.

But, boy oh boy, that firmware flashing would not be easy. *Cries in NixOS.*

Essentially, the main problem arose when attempting to upgrade the firmware. It detected the device
and everything fine, but when it came to actually flashing it a pop-up window appeared saying something
along the lines of "insufficient permissions for given USB device."

## The Solution

In order to fix this permissions problem, one must write a udev rule specifically for the device
in order to expand the permissions for regular user access. The Arch Wiki has a fantastic
entry which I used to format my rule which can be found [here](https://wiki.archlinux.org/title/Udev#Allowing_regular_users_to_use_devices).

In short, the rule was of the form:

```console
ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="vendor_id", ATTRS{idProduct}=="product_id", MODE="0660", TAG+="uaccess"
```

and it should be placed under `/etc/udev/rules.d/` with a name of the format: `x-my.rules` where `x` is a number below 73
and `my` can be any string---usually one which describes the device the rule is made for. So, the final file would be
something like: `/etc/udev/rules.d/x-my.rules`.

Then, to fill in the idVendor and idProduct fields above one simply must run `lsusb`, find your device, then copy
the id's where the output will be of the form `XXXX:YYYY` with `XXXX` being the vendor ID and `YYYY` being the
product ID.

Finale, right?

**WRONG**

If you're used to NixOS, the Linux-based operating system, you should realize Nix ALWAYS and I mean ALWAYS makes
things more difficult. Sigh, why do I always subject myself to such toxic relationships? Well, I'm joking, because
NixOS is a very unique and awesome operating system but that is neither here nor there.

### NixOS Fix

The problem with NixOS is that the `rules.d` directory is completely read-only for any non-privileged user AND
root. This poses an immediate problem because... how the HELL are you supposed to write a file in the directory
if its READ-ONLY. Well, I'll answer that for you: YOU CANT BUCKO.

So, I naturally went to search through NixOS' modules to see if there was a module for writing udev rules. Thankfully
there is! Well, as one would expect for such a critical feature. However, my joy was too quick: the module only allowed
for writing all given rules into a specified `99-local-rules.rules` file. That poses another immediate problem. For the
`uaccess` tag to work, all rules which utilize it must lexigraphically be before `73-seat-late.rules` ie you must preface
the rule name with a number less than 73. Well, shit. How the hell do we do that now. 

Thankfully, we can utilize NixOS AWESOME functions to come to the rescue as demonstrated in [this](https://github.com/NixOS/nixpkgs/issues/308681)
GitHub issue. In short, the fix includes writing the following into your `configuration.nix` or similar file:

```nix
services.udev.packages = lib.singleton (pkgs.writeTextFile
      { name = "my-rules";
        text = ''
         <rules>
        '';
        destination = "/etc/udev/rules.d/<priority>-my.rules";
      });
```

where, remember, priority must be below 73. Inputting this into the configuration, rebuilding your system,
and switching to the new generation: the file should be written to the configured destination!

Hip hip hooray! ^_^

### Return to Reality

After all those solutions, simply going through the aforementioned firmware updater website and installing
the needed firmware *should* fix all related problems. So far, after some audio playback, I can happily report
that there are **no** audio hitches, cut-outs, dropouts, etc! Hopefully it stays that way because, man oh man,
was this absolutely getting on my nerves!


