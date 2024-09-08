{
  description = "A Nix flake that exports a plymouth theme that shows a custom GIF on your boot screen.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter."${system}" = pkgs.nixfmt-rfc-style;
      packages."${system}".default = pkgs.callPackage (import ./plymouth-gif-theme.nix) { };
    };
}
