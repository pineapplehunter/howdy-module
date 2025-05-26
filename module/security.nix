{ config, ... }:
{
  config.security.pam.services.sudo.rules.auth = {
    howdy = {
      enable = true;
      control = "sufficient";
      modulePath = "${config.services.howdy.package}/lib/security/pam_howdy.so";
      order = config.security.pam.services.sudo.rules.auth.unix.order - 10;
    };
  };
}
