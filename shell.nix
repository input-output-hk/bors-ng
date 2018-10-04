
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  erlangDrv = { mkDerivation }:
    mkDerivation rec {
      version = "21.0";
      # Use `nix-prefetch-github --rev OTP-<version> erlang otp` to update.
      sha256 = "0khprgawmbdpn9b8jw2kksmvs6b45mibpjralsc0ggxym1397vm8";

      prePatch = ''
        substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
      '';
    };

  elixirDrv = { mkDerivation }:
    mkDerivation rec {
      version = "1.6.6";
      # Use `nix-prefetch-github --rev v<version> elixir-lang elixir` to update.
      sha256 = "1wl8rfpw0dxacq4f7xf6wjr8v2ww5691d0cfw9pzw7phd19vazgl";
      minimumOTPVersion = "19";
    };

  erlang = beam.lib.callErlang erlangDrv { wxGTK = wxGTK30; };
  rebar = pkgs.rebar.override { inherit erlang; };

  elixir = beam.lib.callElixir elixirDrv {
    inherit erlang rebar;
    debugInfo = true;
  };
in

mkShell {
  buildInputs = [ elixir git fwup squashfsTools file inotify-tools ];
  shellHooks = ''
    mix deps.get
    mix release --env=prod
  '';
}

