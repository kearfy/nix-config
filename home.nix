{ config, pkgs, ... }:

let
  username = "micha";
in
import ./base-home.nix { inherit config pkgs username; }