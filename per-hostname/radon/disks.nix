{
  "/dev/nvme0n1" = [
    { label = "ESP"; type = "EF00"; size = "300M"; fileSystem = "vfat"; mountPoint = "/boot"; }
    { label = "ROOT"; type = "8300"; size = "100%"; fileSystem = "ext4"; mountPoint = "/"; }
  ];
  "/dev/nvme1n1" = [
    { label = "SWAP"; type = "8200"; size = "38G"; fileSystem = "swap"; }
    { label = "HOME"; type = "8300"; size = "100%"; fileSystem = "ext4"; mountPoint = "/home"; }
  ];
}