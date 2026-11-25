# cosmic-overlay

Gentoo overlay for the [COSMIC](https://github.com/pop-os/cosmic-epoch) desktop, built for DepOS.

- Packages follow upstream `epoch-*` release tags (`cosmic-base/*`, keyword `~amd64`).
- Every component ships as `<pn>-<pv>.full.tar.zst`: the upstream tag with all Cargo
  dependencies vendored. These tarballs are attached to the `epoch-<pv>` releases here.
- Build and install go through each upstream `justfile` (`depos-cosmic.eclass`).
- COSMIC Store and Flatpak are not packaged.

## Automation

- `update` (daily): checks `pop-os/cosmic-epoch` for a new epoch tag, vendors every component,
  publishes the release assets, regenerates ebuilds and Manifests, then starts `build`.
- `build`: builds each package in a `gentoo/stage3:systemd` container (desktop/systemd profile,
  dependencies from the Gentoo binary host) and keeps binary packages and logs as artifacts.

## Use

```
# /etc/portage/repos.conf/depos-cosmic.conf
[depos-cosmic]
location = /var/db/repos/depos-cosmic
sync-type = git
sync-uri = https://github.com/ycderman/cosmic-overlay.git
```

```
# /etc/portage/package.accept_keywords/cosmic
cosmic-base/*::depos-cosmic ~amd64
acct-user/cosmic-greeter::depos-cosmic ~amd64
acct-group/cosmic-greeter::depos-cosmic ~amd64
x11-themes/pop-icon-theme::depos-cosmic ~amd64
x11-themes/adw-gtk3::depos-cosmic ~amd64
```

`emerge cosmic-base/cosmic-meta`

Dependency lists were adapted from [fsvm88/cosmic-overlay](https://github.com/fsvm88/cosmic-overlay) (GPL-3).
