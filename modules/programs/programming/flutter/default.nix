{
  pkgs,
  nixpkgs,
  ...
}: {
  environment.systemPackages = with nixpkgs[
    flutterPackages-source.v3_32
    
  ];
}
