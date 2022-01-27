{config, lib, ...}:
{
  options.hostname = lib.mkOption {
    type = lib.types.str;
    description = "Hostname of the current system";
  };
}
