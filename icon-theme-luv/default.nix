{ pkgs, ... }:

let
  stdenv = pkgs.stdenv;

  iconThemesBase = ./files;
  entries = builtins.readDir iconThemesBase;

  iconThemeNames =
    builtins.filter (name: entries.${name} == "directory")
      (builtins.attrNames entries);

  themes =
    builtins.listToAttrs
      (map (name: let
          lname = pkgs.lib.toLower name;
        in {
          name = lname;
          value = stdenv.mkDerivation {
            pname = lname;
            version = "1.0";

            src = "${iconThemesBase}/${name}";

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/share/icons
              cp -r $src $out/share/icons/${lname}
            '';
          };
        }) iconThemeNames);
in
  themes
