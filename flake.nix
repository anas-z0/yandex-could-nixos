{
  description = "yandex vm";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.YANDEX-VM = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ({config, pkgs, ...}: {
        nixpkgs.hostPlatform = "x86_64-linux";
        networking.hostName = "YANDEX-VM";
        virtualisation = {
          useBIOSBoot = true;
          useBootLoader = true;
          fileSystems."/" = {
            fsType = "btrfs";
            options = [ "compress=zstd:3" "noatime" "autodefrag" ];
          };
        };
        boot.kernelParams = [ "console=ttyS0" ];
        users.extraUsers.root.password = "anasisveryshort";
        services = {
          cloud-init = { enable = true; };
          openssh = {
            enable = true;
            listenAddresses = [{
              addr = "0.0.0.0";
              port = 22;
            }];
          };
        };
      })];
    };
  };
}
