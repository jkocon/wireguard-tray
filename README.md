# wireguard-tray

> **Archived (2026-10-16): wireguard-tray lives on in [vpn-tray](https://github.com/jkocon/vpn-tray)** –
> one tray icon for Tailscale, Twingate, NetBird and WireGuard (one VPN at a time). For only this VPN
> run `vpn-tray --only wireguard`.

A **WireGuard** icon for the Linux system tray: keep several WireGuard networks (plain
`wg-quick` `.conf` files) in NetworkManager and pick the one you want from a single menu.
Choosing a network disconnects the others and connects the chosen one.

> **Polish documentation:** [README.pl.md](README.pl.md)

Sibling projects with the same look and behaviour:
[tailscale-tray](https://github.com/jkocon/tailscale-tray),
[twingate-tray](https://github.com/jkocon/twingate-tray) and
[netbird-tray](https://github.com/jkocon/netbird-tray).

---

## Features

The menu opens on a left **or** right click:

| Menu entry | What it does |
|---|---|
| **Status** | *Connected: &lt;name&gt;* (click to disconnect) or *Disconnected*. Warns when the server does not answer: no handshake since connecting, or nothing received for over 3 minutes (only for peers with `PersistentKeepalive`). |
| **Network** | All WireGuard connections as a list (with the server host, *[all traffic]* for full tunnels) plus *None*. Selecting one disconnects every other WireGuard tunnel and connects it. If this computer already has an address inside the tunnel's subnets (you are on that LAN), it asks before connecting. |
| **Details** | *This device* (tunnel IP), *Server* (endpoint) – click to copy; *Routed through the tunnel* (AllowedIPs, DNS); received/sent bytes and when something last arrived. |
| **Manage networks** | Per connection: *Connect automatically*, *Copy server address*, *Rename…*, *Remove…*. *Import a .conf file…* and *Network settings…* (KDE System Settings or nm-connection-editor). |
| **About**, **Exit** | Version and state; quit the tray. |

Import copies the chosen file under the name you give (NetworkManager names the connection and
the interface after the file, max 15 characters), runs `nmcli connection import type wireguard`,
deletes the copy and sets *Connect automatically* off – the tunnel only comes up from the menu.

### Tray icon

| Icon | State |
|---|---|
| white shield | connected |
| grey shield | disconnected |
| translucent shield | connecting |
| orange "!" | connected, but the server does not answer |

NetworkManager does not expose the WireGuard handshake time and `wg show` needs root, so the
tray treats "bytes arriving on the interface" (`/sys/class/net/<if>/statistics`) as the sign of life.

---

## Requirements

- Linux desktop with a **StatusNotifierItem** tray (KDE Plasma; GNOME with the AppIndicator extension).
- **NetworkManager** 1.16+ (`nmcli`) – it has WireGuard built in, `wireguard-tools` is not needed.
- Connecting/disconnecting works for any user in the active session. Import, rename and remove
  need `settings.modify.system`: no password for the `wheel` group thanks to the rule shipped
  with NetworkManager, otherwise your polkit agent asks.
- Runtime helpers: `kdialog`, `notify-send` (libnotify), `wl-copy` (wl-clipboard) or `xclip`/`xsel`.
- To build: Rust 1.85+ (`cargo`).

## Install

```sh
sudo ./install.sh
```

Builds as your user (never as root), installs to `/usr/local/lib/wireguard-tray/`, adds the
autostart entry `/etc/xdg/autostart/wireguard-tray.desktop`, a launcher and the icon.
Exit code 10 means NetworkManager is missing.

Test without a tray: `wireguard-tray --dump` prints the menu once.

## License

MIT
