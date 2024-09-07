{
  description = "A Nix flake that exports a plymouth theme that shows a custom GIF on your boot screen.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    package = { logo ? ./default-logo.gif }: pkgs.stdenv.mkDerivation {
      pname = "plymouth-gif-theme";
      version = "1.0.1";
      dontBuild = true;
      src = ./.;
      nativeBuildInputs = [ pkgs.ffmpeg ];
      installPhase = ''
        mkdir -p $out/share/plymouth/themes/plymouth-gif-theme/frames
        pushd $out/share/plymouth/themes/plymouth-gif-theme/frames
        ${pkgs.ffmpeg}/bin/ffmpeg -i ${logo} frame%d.png
        frame_count=$(ls . | wc -l)
        popd

        mkdir -p $out/share/plymouth/themes/plymouth-gif-theme
        cp -r * $out/share/plymouth/themes/plymouth-gif-theme
        find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;

        sed -i "1iFRAME_COUNT=$frame_count;" $out/share/plymouth/themes/plymouth-gif-theme/video.script
      '';
    };
  in
  {
    packages.x86_64-linux.default = pkgs.callPackage package {};
  };
}
