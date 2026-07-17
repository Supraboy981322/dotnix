{ config, pkgs, ... }:
{
  "xdg/zls.json".text = builtins.toJSON {
    enable_semantic_tokens = true;
    global_cache_path = "/home/super/.cache/zig";
  };
}
