{
  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          name = "python-venv";
          venvDir = "./.venv";
          buildInputs = with pkgs; [
            texliveFull
            firefox
            geckodriver
            (python3.withPackages (ps:
              with ps; [
                ipython
                pip
                jupyter
                widgetsnbextension
                ipympl
                jupyter-nbextensions-configurator
                jedi-language-server
                plotly
                osmnx
                anywidget
                ipywidgets
                owslib
                mypy
                pandas
                us
                selenium
                numpy
                geopandas
                geodatasets
                bokeh
                bokeh-sampledata
                googlemaps
                pyogrio
                geopy
                matplotlib
                pyproj
                folium
                mapclassify
                scipy
                shapely
                xarray
                rioxarray
                rasterio
                ortools
              ]))
          ];
          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            pip install -r requirements.txt
          '';

          shellHook = ''
                    export BROWSER=brave
                        # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
            # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
                    export PIP_PREFIX=$(pwd)/_build/pip_packages
                    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
                    export PATH="$PIP_PREFIX/bin:$PATH"
                    export BOKEH_BROWSER=/home/biscotty/.nix-profile/bin/brave
                    unset SOURCE_DATE_EPOCH
                    #jupyter lab
          '';

          postShellHook = ''
            # allow pip to install wheels
            unset SOURCE_DATE_EPOCH
          '';
        };
      });
}
