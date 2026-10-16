# wireguard-tray

> **Zarchiwizowane (2026-10-16): wireguard-tray jest teraz częścią [vpn-tray](https://github.com/jkocon/vpn-tray)** –
> jedna ikona dla Tailscale, Twingate, NetBird i WireGuard (zawsze jeden VPN). Tylko ten VPN:
> `vpn-tray --only wireguard`.

Ikona **WireGuard** w zasobniku systemowym: kilka sieci WireGuard (zwykłe pliki `.conf`
z `wg-quick`) zapisanych w NetworkManagerze i wybór jednej z nich z menu. Wybranie sieci
rozłącza pozostałe i łączy wybraną.

> **English documentation:** [README.md](README.md)

Siostrzane projekty w tym samym stylu:
[tailscale-tray](https://github.com/jkocon/tailscale-tray),
[twingate-tray](https://github.com/jkocon/twingate-tray) i
[netbird-tray](https://github.com/jkocon/netbird-tray).

## Funkcje

| Pozycja menu | Co robi |
|---|---|
| **Status** | *Connected: &lt;nazwa&gt;* (klik = rozłącz) albo *Disconnected*. Ostrzega, gdy serwer nie odpowiada: brak handshake'u od połączenia albo nic nie przyszło przez ponad 3 minuty (tylko przy `PersistentKeepalive`). |
| **Network** | Lista połączeń WireGuard (z hostem serwera, *[all traffic]* dla pełnego tunelu) i *None*. Wybór rozłącza pozostałe tunele WireGuard i łączy wybrany. Jeśli komputer ma już adres w podsieciach tunelu (jesteś w tej sieci lokalnie), pyta przed połączeniem. |
| **Szczegóły** | *This device* (IP w tunelu), *Server* (endpoint) - klik kopiuje; *Routed through the tunnel* (AllowedIPs, DNS); bajty odebrane/wysłane i kiedy ostatnio coś przyszło. |
| **Manage networks** | Dla każdego połączenia: *Connect automatically*, *Copy server address*, *Rename…*, *Remove…*. Do tego *Import a .conf file…* i *Network settings…*. |
| **About**, **Exit** | Wersja i stan; zamknięcie traya. |

Import kopiuje wybrany plik pod podaną nazwą (NetworkManager nazywa połączenie i interfejs
od nazwy pliku, max 15 znaków), woła `nmcli connection import type wireguard`, usuwa kopię
i wyłącza *Connect automatically* - tunel włącza się tylko z menu.

NetworkManager nie podaje czasu handshake'u, a `wg show` wymaga roota, więc oznaką życia są
bajty przychodzące na interfejsie (`/sys/class/net/<if>/statistics`).

## Wymagania i instalacja

NetworkManager 1.16+ (`nmcli`), zasobnik StatusNotifierItem, `kdialog`, libnotify, wl-clipboard,
Rust 1.85+ do budowania. Import/zmiany bez hasła dla grupy `wheel` (reguła z pakietu NetworkManager).

```sh
sudo ./install.sh
```

Test bez zasobnika: `wireguard-tray --dump`.

## Licencja

MIT
