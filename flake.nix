{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = import nixpkgs { inherit system; };
      cleaner = pkgs.writeShellApplication {
        runtimeInputs = [ pkgs.texlive.combined.scheme-full ];
        name = "clean";
        text = ''
          ${pkgs.texlive.combined.scheme-full}/bin/latexmk -C -auxdir=aux -outdir=pdf
          ${pkgs.texlive.combined.scheme-full}/bin/latexmk -C -auxdir=. -outdir=.
        '';
      };
      makepdf = pkgs.writeShellApplication {
        runtimeInputs = [ pkgs.texlive.combined.scheme-full ];
        name = "makepdf";
        text = ''
          mkdir -p aux pdf
          ${pkgs.texlive.combined.scheme-full}/bin/latexmk -interaction=nonstopmode -lualatex -pdf -auxdir=aux -outdir=pdf ./00-all.tex
        '';
      };
    in {
      devShells.${system}.default = with pkgs;
        mkShell { buildInputs = [ texlive.combined.scheme-full ]; };
      apps.${system} = {
        clean = {
          type = "app";
          program = "${cleaner}/bin/clean";
        };
        makepdf = {
          type = "app";
          program = "${makepdf}/bin/makepdf";
        };
      };
    };
}
