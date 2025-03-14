{ config, pkgs, ... }:

let
  username = "personal";
in
import ./base-home.nix { inherit config pkgs username; }