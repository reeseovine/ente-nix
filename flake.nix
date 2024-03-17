{
	description = "ente.io Museum server";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		utils.url = "github:numtide/flake-utils";
	};

	outputs = { self, nixpkgs, utils }:
		let
			version = "v2.0.34";
			supportedSystems = [
				"x86_64-linux"
				"x86_64-darwin"
				"aarch64-linux"
				"aarch64-darwin"
			];
			forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
			nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
		in {
			# Provide some binary packages for selected system types.
			packages = forAllSystems (system:
				let
					pkgs = nixpkgsFor.${system};
				in {
				museum = pkgs.buildGoModule {
					pname = "museum";
					inherit version;
					src = ./server;
					subPackages = [ "cmd/museum" ];
					nativeBuildInputs = with pkgs; [ gcc libsodium musl pkg-config ];
					buildInputs = with pkgs; [ libsodium ];
					vendorHash = "sha256-D3pJYrip2EEj98q3pawnSkRUiIyjLm82jlmV7owA69Q=";
				};
			});
			defaultPackage = forAllSystems (system: self.packages.${system}.museum);

			# apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };
		};
}
