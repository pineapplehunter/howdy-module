{ config, ... }:
{
  config.security.pam.services.login.rules.auth = {
    howdy = {
      enable = true;
      control = "sufficient";
      modulePath = "${config.services.howdy.package}/lib/security/pam_howdy.so";
      order = config.security.pam.services.sudo.rules.auth.unix.order - 500;
    };
  };

  config.security.pam.services.sudo.rules.auth = {
    howdy = {
      enable = true;
      control = "sufficient";
      modulePath = "${config.services.howdy.package}/lib/security/pam_howdy.so";
      order = config.security.pam.services.sudo.rules.auth.unix.order - 500;
    };
  };
  config.security.pam.services.polkit-1.rules.auth = {
    howdy = {
      enable = true;
      control = "sufficient";
      modulePath = "${config.services.howdy.package}/lib/security/pam_howdy.so";
      order = config.security.pam.services.sudo.rules.auth.unix.order - 500;
    };
  };
}
