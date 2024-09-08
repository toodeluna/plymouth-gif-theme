{
  pkgs,
  logo ? ./default-logo.gif,
}:
let
  out-dir = "$out/share/plymouth/themes/plymouth-gif-theme";
in
pkgs.stdenv.mkDerivation {
  pname = "plymouth-gif-theme";
  version = "1.0.1";
  src = ./.;
  dontBuild = true;
  nativeBuildInputs = [ pkgs.ffmpeg ];

  installPhase = ''
    mkdir -p ${out-dir}
    mkdir -p ${out-dir}/frames

    pushd ${out-dir}/frames
    ${pkgs.ffmpeg}/bin/ffmpeg -i ${logo} frame%d.png
    frame_count=$(ls . | wc -l)
    popd

    cp -r * ${out-dir}
    find ${out-dir} -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;

    sed -i "1iFRAME_COUNT=$frame_count;" ${out-dir}/video.script
  '';
}
