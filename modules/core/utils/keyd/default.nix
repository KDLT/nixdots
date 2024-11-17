{
  pkgs,
  ...
}:
{
  # keyd is a key remapping daemon
  environment.systemPackages = [ pkgs.keyd ];

  services.keyd = {
    enable = true;

    keyboards.t480 = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          leftshift = "overload(shift, esc)";
          capslock = "overload(control, esc)";
          backslash = "backspace";
          backspace = "backslash";
          leftcontrol = "layer(leftcontrol)";
        };
        control = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          slash = "delete";
        };
      };
    };

    keyboards.hhkb = {
      ids = [ "04fe:0021" ];
      settings = {
        main = {
          #leftshift = "overload(shift, esc)";
          leftcontrol = "overload(control, esc)";
        };
        control = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          slash = "delete";
        };
      };
    };
  };
}
