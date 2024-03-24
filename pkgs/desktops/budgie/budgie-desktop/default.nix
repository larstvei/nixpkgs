{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, accountsservice
, alsa-lib
, budgie-screensaver
, docbook-xsl-nons
, glib
, gnome
, gnome-desktop
, graphene
, gst_all_1
, gtk-doc
, gtk3
, ibus
, intltool
, libcanberra-gtk3
, libgee
, libGL
, libnotify
, libpeas
, libpulseaudio
, libuuid
, libwnck
, magpie
, mesa
, meson
, ninja
, pkg-config
, polkit
, sassc
, upower
, vala
, xfce
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.9.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-H+J/zFUjiXbr5ynDkkjrRsEbyO4LPOhqe8DdG60ikRw=";
  };

  patches = [
    ./plugins.patch

    # vapi: Update libxfce4windowing to 4.19.3
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/546
    (fetchpatch2 {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/a040ccb96094f1d3a1ee81a6733c9434722bdf6c.patch";
      hash = "sha256-9eMYB5Zyn3BDYvAwORXTHaPGYDP7LnqHAwp+6Wy6XLk=";
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    alsa-lib
    budgie-screensaver
    glib
    gnome-desktop
    gnome.gnome-settings-daemon
    gnome.mutter
    gnome.zenity
    graphene
    gtk3
    ibus
    libcanberra-gtk3
    libgee
    libGL
    libnotify
    libpeas
    libpulseaudio
    libuuid
    libwnck
    magpie
    mesa
    polkit
    sassc
    upower
    xfce.libxfce4windowing
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  passthru.providedSessions = [
    "budgie-desktop"
  ];

  meta = {
    description = "A feature-rich, modern desktop designed to keep out the way of the user";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30 ];
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
  };
})
