{ stdenv, git, fetchFromGitHub, goPackages, python34, makeWrapper }:

with goPackages;

buildGoPackage rec {
  rev = "14b91615c66c4e75bc0ae8576be105f6a1e2075b";
  version = "${stdenv.lib.strings.substring 0 7 rev}";
  name = "limetext-qml-${version}";
  goPackagePath = "limetext-qml";

  src = fetchFromGitHub {
    inherit rev;
    owner = "limetext";
    repo = "lime-qml";
    sha256 = "0mi6x9k4yjyb1x41n5cai501c1rmqz20n4dvprbxxa7vxbkfb1bx";
  };

  subPackages = [ "main" ];

  buildInputs = [ lime-backend lime-termbox-go python34 makeWrapper fsnotify.v0 qml.v1 ];

  postInstall = ''
    mv $out/bin/main $out/bin/limetext-qml
    wrapProgram "$out/bin/limetext-qml" --prefix PYTHONPATH : "$PYTHONPATH" \
                        --prefix PATH : ${python34}/bin
  '';

  dontInstallSrc = true;

  meta = with stdenv.lib; {
    description = "Lime Text is a powerful and elegant text editor primarily developed in Go that aims to be a Free and open-source software successor to Sublime Text.";
    homepage = http://limetext.org/;
    license = stdenv.lib.licenses.free;
    platforms = with platforms; linux;
  };

}
