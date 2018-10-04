{ stdenv, buildMix, hexPackages ? import ./hex-packages.nix {} }:

buildMix {
  name = "bors-ng";
  beamDeps = with hexPackages; [
    phoenix_ecto
    phoenix_html
    phoenix
    poison
    gettext
    cowboy
    httpoison
    etoml
    wobserver
    hackney
    ex_link_header
    oauth2
    joken
    dialyxir
    distillery
    edeliver
    ex_doc
    credo
    confex
    postgrex
    mariaex
    ecto
  ];
  version = "1.0";
  src = ./.;
}
