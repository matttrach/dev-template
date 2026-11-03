{
  description = "A reliable testing environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};

        gemini-cli = pkgs.gemini-cli-bin.overrideAttrs (oldAttrs: rec {
          version = "0.62.0";
          src = pkgs.fetchzip {
            url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini-cli-bundle.zip";
            hash = "sha256-OJx8+Lu/QPszslPzot3d3LgefU+XVR0uI7AWXIsLLhY=";
            stripRoot = false;
          };
        });

        macVscode = pkgs.writeShellScriptBin "code" ''
          exec /usr/local/bin/code "$@"
        '';

        swVers = pkgs.writeShellScriptBin "sw_vers" ''
          exec /usr/bin/sw_vers "$@"
        '';

        initNodeEnv = pkgs.writeShellScriptBin "init-node-env" ''
          echo "Setting up Node environment..."
          if [ ! -f package.json ]; then
            npm init -y
          fi
          if ls eslint.config.* 1> /dev/null 2>&1; then
            echo "ESLint config already exists, skipping."
          else
            npm init @eslint/config@latest
          fi
        '';

        unfreePkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        claude-code = unfreePkgs.claude-code;
        github-copilot-cli = unfreePkgs.github-copilot-cli;

        devPackages = [
          # downloaded packages here
          initNodeEnv
          gemini-cli
        ] ++ ([
          # unfree packages from the nix repository
          claude-code
          github-copilot-cli
        ]) ++ (with pkgs; [
          # free packages from the nix repository
          actionlint
          age
          awscli2
          bashInteractive
          cspell
          curl
          dig
          docker-client
          docker-compose
          eslint
          gh
          git
          gitleaks
          gnupg
          go
          golangci-lint
          google-cloud-sdk
          goreleaser
          gotestfmt
          gotestsum
          jq
          kubectl
          kubernetes-helm
          less
          markdownlint-cli
          nodejs_24
          openssh
          openssl
          prettier
          ripgrep
          shellcheck
          shfmt
          tflint
          tfsec
          time
          tree
          trivy
          updatecli
          vim
          which
          xz
          yq-go
        ]) ++ ( if pkgs.stdenv.hostPlatform.isDarwin then [
          # mac only packages
          macVscode
          swVers
          pkgs.pinentry_mac
          pkgs.colima
          pkgs.age-plugin-se
        ] else []);

        devShellPackage = pkgs.symlinkJoin {
          name = "dev-shell-package";

          # buildEnv properly handles combining all outputs (like bin, out, etc.)
          paths = [
            (pkgs.buildEnv {
              name = "dev-shell-env";
              paths = devPackages;
            })
          ];
        };
        in
        {
          packages.default = devShellPackage;

          devShells.default = pkgs.mkShell {
            buildInputs = [ devShellPackage ];
            shellHook = ''
            '';
          };
        }
      );
}
