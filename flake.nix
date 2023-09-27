{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/23.05";
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = system; };
    in {
      devShells.${system}.default = with pkgs;
        mkShell { buildInputs = [ texlive.combined.scheme-full ]; };
    };
}
