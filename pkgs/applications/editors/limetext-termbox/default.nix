{ stdenv, git, fetchFromGitHub, goPackages, python34, makeWrapper }:

with goPackages;

buildGoPackage rec {
  rev = "a049c703e97850e5154b57253ba27869d99aa077";
  version = "${stdenv.lib.strings.substring 0 7 rev}";
  name = "limetext-termbox-${version}";
  goPackagePath = "limetext-termbox";

  src = fetchFromGitHub {
    inherit rev;
    owner = "limetext";
    repo = "lime-termbox";
    sha256 = "026qs44iiqlv325lzkxjjxg2fp4c3b3c6gza5d03yx50c8hsdjj6";
  };

  subPackages = [ "main" ];

  buildInputs = [ lime-backend lime-termbox-go python34 makeWrapper ];

  postInstall = ''
    mv $out/bin/main $out/bin/limetext-termbox
    wrapProgram "$out/bin/limetext-termbox" --prefix PYTHONPATH : "$PYTHONPATH" \
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
