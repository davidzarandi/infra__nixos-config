disks: {
  disko.devices = {
    disk = builtins.mapAttrs (name: value: {
      type = "disk";
      device = name;
      content = {
        type = "gpt";
        partitions = builtins.listToAttrs (map (partition: {
          name = partition.label;
          value = {
            label = partition.label;
            size = partition.size;
            content = (if partition.fileSystem == "swap" then {
              type = "swap";
              resumeDevice = true;
            } else {
              type = "filesystem";
              format = partition.fileSystem;
              mountpoint = partition.mountPoint;
            });
          };
        }) value);
      };
    }) disks;
  };
}
