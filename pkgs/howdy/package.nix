{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  bzip2,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  fmt,
  gettext,
  gtk3,
  inih,
  libevdev,
  pam,
  python3,
}:

let
  baseurl = "https://github.com/davisking/dlib-models/raw/fd81b6308a6a73d4ce08859eb2f4b628a21e27a2";
  data = [
    {
      name = "dlib_face_recognition_resnet_model_v1.dat";
      model = fetchurl {
        url = "${baseurl}/dlib_face_recognition_resnet_model_v1.dat.bz2";
        hash = "sha256-q7H2EEHkNEZYVc6Bwr1UboMNKLy+2NJ/++W7QIsRVTo=";
      };
    }
    {
      name = "mmod_human_face_detector.dat";
      model = fetchurl {
        url = "${baseurl}/mmod_human_face_detector.dat.bz2";
        hash = "sha256-256eQPCSwRjV6z5kOTWyFoOBcHk1WVFVQcVqK1DZ/IQ=";
      };
    }
    {
      name = "shape_predictor_5_face_landmarks.dat";
      model = fetchurl {
        url = "${baseurl}/shape_predictor_5_face_landmarks.dat.bz2";
        hash = "sha256-bnh7vr9cnv23k/bNHwIyMMRBMwZgXyTymfEoaflapHI=";
      };
    }
  ];

  # wrap howdy and howdy-gtk
  py =
    (python3.withPackages (p: [
      p.elevate
      p.face-recognition
      p.keyboard
      (p.opencv4.override { enableGtk3 = true; })
      p.pycairo
      p.pygobject3
    ])).override
      (old: {
        # https://github.com/NixOS/nixpkgs/pull/216245#issuecomment-3076597039
        makeWrapperArgs = (old.makeWrapperArgs or [ ]) ++ [
          "--set OMP_NUM_THREADS 1"
        ];
      });
in
stdenv.mkDerivation {
  pname = "howdy";
  version = "2.6.1-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "boltgolt";
    repo = "howdy";
    rev = "d3ab99382f88f043d15f15c1450ab69433892a1c";
    hash = "sha256-Xd/uScMnX1GMwLD5GYSbE2CwEtzrhwHocsv0ESKV8IM=";
  };

  patches = [
    # Don't install the config file. We handle it in the module.
    ./dont-install-config.patch
    ./python-path.patch
  ];

  mesonFlags = [
    "-Dconfig_dir=/etc/howdy"
    "-Dpython_path=${py}/bin/python"
    "-Duser_models_dir=/var/lib/howdy/models"
  ];

  nativeBuildInputs = [
    bzip2
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    fmt
    gettext
    gtk3
    inih
    libevdev
    pam
    py
  ];

  postInstall = ''
    # install dlib data
    rm -rf $out/share/dlib-data/*
    ${lib.concatStringsSep "\n" (
      map ({ name, model }: "bzip2 -dc ${model} > $out/share/dlib-data/${name}") data
    )}
  '';

  meta = {
    description = "Windows Hello™ style facial authentication for Linux";
    homepage = "https://github.com/boltgolt/howdy";
    license = lib.licenses.mit;
    mainProgram = "howdy";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fufexan ];
  };
}
