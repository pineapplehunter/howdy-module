{ lib, config, ... }:
let
  cfg = config.howdy-module.security.pam.services.howdyAuth;
in
{
  options.howdy-module.security.pam.services.howdyAuth = lib.mkOption {
    default = config.services.howdy.enable;
    defaultText = lib.literalExpression "config.services.howdy.enable";
    type = lib.types.bool;
    description = ''
      If set, IR camera will be used (if it exists and your
      facial models are enrolled).
    '';
  };

  config.security.pam.services.sudo.rules.auth = {
    name = "howdy";
    enable = cfg.howdyAuth;
    control = "sufficient";
    modulePath = "${config.services.howdy.package}/lib/security/pam_howdy.so";
  };
}
