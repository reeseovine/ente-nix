{
	description = "ente.io Museum server";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, utils }:
		utils.lib.eachSystem [
			"x86_64-linux"
			"aarch64-linux"
			"x86_64-darwin"
			"aarch64-darwin"
		] (system: let
			pkgs = nixpkgs.legacyPackages.${system};
			version = "v2.0.34";
		in {
			packages = {
				default = pkgs.buildGoModule {
					pname = "museum";
					inherit version;
					src = ./.;
					subPackages = [ "cmd/museum" ];
					nativeBuildInputs = with pkgs; [ gcc libsodium musl pkg-config ];
					buildInputs = with pkgs; [ libsodium ];
					vendorHash = "sha256-D3pJYrip2EEj98q3pawnSkRUiIyjLm82jlmV7owA69Q=";
				};
			};

			# apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

			# Dependencies that are only needed for development
			devShells.default = pkgs.mkShell {
				buildInputs = with pkgs; [ gcc git go gopls gotools go-tools libsodium musl pkg-config ];
			};
		});
}
