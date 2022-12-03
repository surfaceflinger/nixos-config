{ ... }: {
  # Overlays
  nixpkgs.overlays = [
    (self: super: {
      gnome = super.gnome.overrideScope' (gself: gsuper: {
        mutter = gsuper.mutter.overrideAttrs (oldAttrs: {
          patchFlags = [ "-N" "-p1" "-F3" ];
          patches =
            oldAttrs.patches
            ++ [
              ../packages/patches/mutter/vrr.patch
            ];
        });
        gnome-control-center = gsuper.gnome-control-center.overrideAttrs (oldAttrs: {
          patches =
            oldAttrs.patches
            ++ [
              ../packages/patches/gnome-control-center/vrr.patch
            ];
        });
      });
    })
  ];
}
