# Installation (NixOS)
## Install methods
### Declarative Nix
To install with nix, create a `.nix` file like this and import it to your `configuration.nix` :
```nix
{ config, pkgs, ... }:

let
    archbox = pkgs.stdenv.mkDerivation rec {
        name = "archbox";
        src = pkgs.fetchFromGitHub {
            owner = "your_user_here";
            repo = "archbox";
            rev = "rev_here";
            sha256 = "rev_sha256_here";
        };
        sourceRoot = ".";
        installPhase = ''
            mkdir -p $out
            cd source
            export FORCE_INSTALL_CONFIG=1
            export ETC_DIR=$out/etc
            export PREFIX=$out
            export ARCHBOX_USER=your_user_here
            export MOUNT_RUN=no
            ${pkgs.bash}/bin/bash install.sh
        '';
    };
in
{
    environment.systemPackages = [ archbox ];
    environment.etc = { 
        "archbox.conf" = { 
            source = "${archbox}/etc/archbox.conf";
        };
    };
}
```
Configuration can be done by modifying `installPhase` e.g. :
```sh
mkdir -p $out
cd source
export FORCE_INSTALL_CONFIG=1
export ETC_DIR=$out/etc
export PREFIX=$out
export ARCHBOX_USER=lemni
export MOUNT_RUN=no
export ENV_VAR="TERM=foot"
export SHARED_FOLDER=( /home /var/www )
${pkgs.bash}/bin/bash install.sh
```
### Regular Installation
See [INSTALL.md](INSTALL.md)
## Issues
See [issues](https://github.com/lemniskett/archbox/#nixos-specific-issues)
