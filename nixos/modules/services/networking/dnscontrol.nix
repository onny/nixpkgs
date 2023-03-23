{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dnscontrol;

  settingsFile = pkgs.writeTextFile {
    name = "dnsconfig.js";
    text = cfg.settings;
    destination = "/dnsconfig.js";
  };

  credsFile = pkgs.writeTextFile {
    name = "credsFile";
    text = builtins.toJSON cfg.creds;
    destination = "/creds.json";
  };

  workingDir = pkgs.symlinkJoin {
    name = "dnscontrol-working-directory";
    paths = [
      credsFile
      settingsFile
    ];
  };

in {

  options = {
    services.dnscontrol = {

      enable = mkEnableOption (mdDoc ''
        Apply DNS configuration accross any number of DNS hosts using the 
        `dnsconfig push` command. Reference [https://docs.dnscontrol.org](upstream documentation)
        on how to configure credentials and the main DNSConfig file.
      '');

      creds = mkOption {
        default = {};
        example = lib.literalExpression ''
          {
            "inwx" = {
              TYPE = "INWX";
              username = "myuser";
              password = "mypassword";
            };
          };
        '';
        description = lib.mdDoc ''
          Declarative configuration of networkd-dispatcher rules. See
          [https://gitlab.com/craftyguy/networkd-dispatcher](upstream instructions)
          for an introduction and example scripts.
        '';
        type = types.attrsOf types.anything;
      };

      settings = mkOption {
         type = types.lines;
         description = lib.mdDoc ''
           test
        '';
      };

    };
  };

  config = mkIf (cfg.enable) {
    systemd.services = {
      dnscontrol = {
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        description = "dnscontrol configuration";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.dnscontrol}/bin/dnscontrol push";
          WorkingDirectory = workingDir;
        };
      };
    };
  };

}
