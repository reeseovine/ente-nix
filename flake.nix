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
				default = pkgs.buildGoModule {
					pname = "museum";
					inherit version;
					src = ./server;
					subPackages = [ "cmd/museum" ];
					nativeBuildInputs = with pkgs; [ gcc libsodium musl pkg-config ];
					buildInputs = with pkgs; [ libsodium ];
					vendorHash = "sha256-D3pJYrip2EEj98q3pawnSkRUiIyjLm82jlmV7owA69Q=";
				};
			});

			# apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

			# Dependencies that are only needed for development
			devShells = forAllSystems (system:
				let
					pkgs = nixpkgsFor.${system};
				in {
					default = pkgs.mkShell {
						buildInputs = with pkgs; [ gcc git go gopls gotools go-tools libsodium musl pkg-config ];
					};
				});
		}; # // {
		# 	nixosModules.museum = { config, lib, pkgs, ... }:
		# 		with lib;
		# 		let
		# 			cfg = config.services.museum;
		# 			pkg = self.packages.${pkgs.system}.default;
		# 		in {
		# 			options.services.museum = with types; {
		# 				enable = mkEnableOption (lib.mdDoc "Enable ente.io Museum server");

		# 				package = mkOption {
		# 					type = types.package;
		# 					default = pkgs.museum;
		# 					defaultText = literalExpression "pkgs.museum";
		# 					description = lib.mdDoc ''
		# 						The museum package to use.
		# 					'';
		# 				};

		# 				dbname = mkOption {
		# 					type = types.str;
		# 					default = "museum";
		# 					description = lib.mdDoc ''
		# 						Name of postgresql database
		# 					'';
		# 				};

		# 				dbuser = mkOption {
		# 					type = types.str;
		# 					default = "museum";
		# 					description = lib.mdDoc ''
		# 						User for postgresql database
		# 					'';
		# 				};
		# 			};

		# 			config = lib.mkIf cfg.enable {
		# 				systemd.services.museum = {
		# 					wantedBy = [ "multi-user.target" ];

		# 					serviceConfig = {
		# 						Restart = "on-failure";
		# 						ExecStart = ''
		# 							${pkgs.museum}/bin/museum
		# 						'';
		# 						DynamicUser = true;

		# 						StateDirectory = "museum";
		# 						WorkingDirectory = "/var/lib/museum";
		# 					};
		# 				};
		# 			};
		# 		};
		# };
}
