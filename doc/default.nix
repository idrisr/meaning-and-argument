{ pkgs, stdenvNoCC, python312Packages }:
let
  mytex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      biblatex
      enumitem
      glossaries
      latex-bin
      latexmk
      minted
      pdfcol
      rsfs cm-super
      scheme-small
      tcolorbox
      tikzfill
      titlesec
      upquote
      semantic
      prooftrees
      svn-prov
      forest
      xcolor
      ;
  };
in

stdenvNoCC.mkDerivation {
  name = "meaning and argument";
  pname = "meaning and argument";
  src = ./src;
  nativeBuildInputs = [ mytex python312Packages.pygments pkgs.biber ];
  buildPhase = ''
    latexmk 00-main.tex
  '';
  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/
  '';
}
