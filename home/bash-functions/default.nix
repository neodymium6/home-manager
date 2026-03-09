{ pkgs, ... }:

let
  tmem = import ./tmem.nix { inherit pkgs; };
in
  tmem
