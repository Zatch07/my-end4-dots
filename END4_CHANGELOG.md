# End-4 Dotfiles Changelog & Master Ledger

This document keeps track of all customizations, bug fixes, and manual overrides applied to the End-4 Hyprland dotfiles. If the system is ever reinstalled or updated, this file will serve as the instruction manual to restore your specific preferences.
## 🎭 skwd Integrations (Window Switcher & Spotify Theme)
- **Spicetify Theme (`skwd`)**: Integrated a new Spicetify theme base directly sourced from the `skwd` window shell setup without replacing previous `Sleek` and `caelestia` configurations. Synced and applied via `Matugen` dynamically reading the current wallpaper state via the `~/.config/matugen/config.toml` post hooks.
- **Alt+Tab Window Switcher**: Deployed `quickshell -p ~/.config/skwd` to autostart in headless mode (with the bar and other UI disabled via `~/.config/skwd/data/config.json`) specifically to act as an `Alt+Tab` graphical window switcher. Configured new binds in `keybinds.conf` sending FIFO pipe inputs (`switcherNext` and `switcherPrev`) through `${XDG_RUNTIME_DIR}/skwd/cmd`.


## ⌨️ Keybinds & Shortcuts (`~/.config/hypr/hyprland/keybinds.conf`)

*   **Search / Launcher:** Changed from `Super` to `Alt + \`` (grave). Unbound `Super_L` and `Super_R` to prevent conflicts.
*   **Browser (Vivaldi):** Switched from Thorium to **Vivaldi**. Replaced the `Super + W` (and old `Super + B`) Thorium binds with `Super + B` and `Ctrl + B` both pointing to `vivaldi`.
*   **Wallpaper Selector:** Changed from `Ctrl + Super + T` to `Ctrl + Super + W`.
*   **Cleaned Sidebar Conflicts:** Removed the duplicate `Super + B` and `Super + O` bindings that opened the AI sidebar, so browser binds work cleanly.
*   **Media & Volume (Fn Keys):**
    *   Mapped standard `Fn + F6/F7/F8` keys to Previous, Play/Pause, and Next track using `playerctl`.
    *   Mapped `Fn + F2/F3` to system volume Decrease/Increase with `1%` interval steps. Configured with `bindle` (hold-to-repeat) so you can press and hold to smoothly adjust volume up to `140%`.
*   **Window Management (Layout Preserving):**
    *   `Super + Shift + Arrows` now uses `swapwindow` instead of `movewindow`. This prevents the dwindle layout from destroying your 70/30 window split ratios when moving windows around.
*   **Workspace Movement:**
    *   `Super + Alt + # (1-0)` is customized to use `movetoworkspace` (sends the active window to an entirely new workspace and instantly jumps the screen there). 
    *   `Super + Shift + # (1-0)` sends windows silently (`movetoworkspacesilent`).

*Note: All Custom keybinds were integrated directly inside `hyprland/keybinds.conf` overriding the original values instead of stacking them via `custom/keybinds.conf` so that the `Super + /` QuickShell Cheatsheet natively formats the buttons properly without duplicate visual clutter.*

---

## 💤 Keep Awake & Screen Idle Fixes 

The "Keep System Awake" notification bar toggle was broken out-of-the-box due to two distinct architectural bugs. We patched them manually:

1.  **`~/.config/hypr/hypridle.conf`**
    *   Removed `inhibit_sleep = 3` globally. This is an invalid configuration flag for modern `hypridle` and was causing the sleep-watching daemon to crash silently in the background, making the QuickShell toggle useless.
2.  **`~/.config/quickshell/ii/services/Idle.qml`**
    *   The QuickShell developer built the "Stay Awake" inhibitor attached to an invisible `0x0` transparent window. Modern Wayland/Hyprland strict compositors reject `0x0` windows as invalid session blockers.
    *   **Fix:** We edited `Idle.qml` to give the invisible `PanelWindow` a size of `implicitWidth: 1` and `implicitHeight: 1`. Wayland now legally respects the toggle button!

---

## 🚀 Startup Apps (`~/.config/hypr/custom/execs.conf`)

Configured custom apps to automatically spawn on login:
1. `nm-applet --indicator` (Network Manager)
2. `blueman-applet` (Bluetooth)
3. `vesktop` (Discord Client)
4. `kdeconnect-indicator`
5. `gnome-keyring-daemon --start --components=secrets`
6. `jdsp-gui --start-minimized` (JamesDSP Audio Equalizer)
7. `motrix --hidden` (Download Manager - starts minimized to tray)
8. `emacs --daemon` (Background editor server)

---

## 🪟 Layout 

`~/.config/hypr/custom/layout.conf` is stripped back to standard `preserve_split = true` and `default_split_ratio = 1.4` (roughly 70/30) logic, relying primarily on `swapwindow` keybinds to maintain ratios cleanly.

---

*(Append any future feature additions, VPN toggles, or script adjustments below this line)*

## 🛡️ QuickShell Connectors

### ProtonVPN WireGuard Toggle
*   Bypassed the deprecated/broken `protonvpn-cli` entirely by importing standalone Proton WireGuard configurations (`wg-CA-FREE-13.conf`) directly into `NetworkManager` via `nmcli`.
*   Created `~/.config/hypr/scripts/vpn-manager.sh` — a bash script that handles `status` and `toggle` subcommands. On connect, it randomly picks from all installed WireGuard profiles for basic load distribution. 
*   **Adding new configs:** Run `nmcli connection import type wireguard file <path>` and then `nmcli connection modify <name> connection.autoconnect no` to prevent it from auto-starting on boot.
*   **Toggle file:** `~/.config/quickshell/ii/modules/common/models/quickToggles/ProtonVPNToggle.qml`
    *   Polls real VPN state every **3 seconds** — no optimistic flipping, so the button always reflects truth.
    *   Speeds up to 500ms polling for one tick after the button is pressed for responsiveness.
    *   Fires a `notify-send` desktop notification **only when state actually changes**: "🔒 VPN Connected" or "🔓 VPN Disconnected".
    *   Registered in `AndroidToggleDelegateChooser.qml` and `AndroidQuickPanel.qml` under the role key `protonVpn`.
    *   To add the toggle to the panel: open sidebar → Edit (pencil icon) → drag "Proton VPN" into the active grid.

### Keep Awake (Idle Inhibitor) Toggle Improvements
*   **`~/.config/quickshell/ii/modules/common/models/quickToggles/IdleInhibitorToggle.qml`** — Rewrote to add:
    *   Reactive binding to `Idle.inhibit` so state updates instantly from **any** source (button press, restart, external trigger).
    *   `onToggledChanged` notification handler: fires "☕ Screen will stay on" when enabled and "💤 Sleep re-enabled" when disabled.
    *   1.5s startup grace timer so QuickShell doesn't fire a spurious notification when it first loads the widget.
    *   Dynamic tooltip text that reflects current state.

---

## ✍️ Text Editors

### Doom Emacs — Dynamic Theming via Matugen
*   Created a custom Matugen Elisp generator template at `~/.config/matugen/templates/doom-matugen-theme.el`.
*   Added `[templates.doom]` block to `~/.config/matugen/config.toml` — every wallpaper change regenerates `~/.config/doom/themes/doom-matugen-theme.el` from the live Material You palette.
*   `post_hook` uses `timeout 2 emacsclient ...` so matugen never hangs waiting for the Emacs daemon.
*   Linked `doom-matugen` inside `~/.config/doom/config.el` via `(add-to-list 'custom-theme-load-path "~/.config/doom/themes/")` and `(setq doom-theme 'doom-matugen)`.
*   **Real-time updates** require Emacs running as a daemon (`emacs --daemon`). Otherwise theme applies on next launch.
*   Required variables for a valid `def-doom-theme`: `bg`, `fg`, `fg-alt`, `bg-alt`, `base0`–`base8`, `grey`, `red`, `orange`, `green`, `teal`, `yellow`, `blue`, `dark-blue`, `magenta`, `violet`, `cyan`, `dark-cyan` — all mapped to Matugen Material You tokens.

---

## 🐱 Kitty Terminal — Dynamic Colors via Matugen

*   **Root cause of missing colors:** the ML4W `20-customization.fish` file (now deleted) was the mechanism that applied ML4W's Matugen-generated Kitty colors. After deletion, end-4's `sequences.txt` escape sequence approach took over — but with `harmony: 0` in the illogical-impulse config, those sequences output **unmodified Gruvbox colors** with zero wallpaper influence.
*   **Conflict discovered:** `sequences.txt` was being `cat`'d via Fish's `config.fish` at runtime. This physically **overwrote** the kitty config background color after kitty loaded it — confirmed by `kitty +kitten query_terminal background` returning the sequences.txt value instead of kitty.conf value.
*   **Fix — Matugen Kitty Template:**
    *   Created `~/.config/matugen/templates/kitty-colors.conf` — maps Material You color roles (`surface`, `primary`, `on_surface`, etc.) to all 16 terminal colors, background, foreground, cursor, selection, tab bar, and window borders.
    *   Added `[templates.kitty]` to `matugen/config.toml` — generates `~/.config/kitty/matugen-colors.conf` on every wallpaper change.
    *   Added `include matugen-colors.conf` to `~/.config/kitty/kitty.conf` so it loads at startup.
    *   Removed the `sequences.txt` cat from `config.fish` — no longer needed and was causing the conflict.
*   **Reload after wallpaper change:** Press `Ctrl+Shift+F5` in an open Kitty window to hot-reload the config without restarting.

---

## 🐟 Fish Shell (`~/.config/fish/conf.d/`)

### Path Variable Infinite Loop Fix
*   `00_init.fish` used `set -U fish_user_paths` which appended paths to a **Universal (persistent) variable** on every shell open, causing exponential duplication and eventual crashes.
*   Fixed by replacing all `set -U fish_user_paths` calls with `fish_add_path`, which is idempotent and never duplicates.
*   Wiped the bloated `SETUVAR fish_user_paths` line manually from `~/.config/fish/fish_variables`.

### Removed sequences.txt Color Override
*   Removed the `cat sequences.txt` block from `config.fish` entirely — it was fighting with the new proper Matugen kitty config approach and losing (escape sequences applied at runtime override static config).

---

## 🚀 Startup Apps (`~/.config/hypr/custom/execs.conf`)

*   **Vesktop (Discord) Crash Fix:** 
    *   Changed `exec-once = vesktop` to `exec-once = bash -c "sleep 3 && vesktop"`.
    *   Electron apps like Vesktop tend to ask for network sockets or Wayland system tray interfaces before the environment has fully initialized during boot, causing silent background crashes. Waiting 3 seconds guarantees everything is ready, ensuring Vesktop consistently appears in the system tray.

---

## 🧠 Antigravity (VSCode) — Matugen Integration

*   Antigravity does not support CSS live-watching directly like GTK or Discord, so we use a fully synthesized extension.
*   The `[templates.antigravity]` block in `matugen/config.toml` outputs to `~/.antigravity/extensions/matugen-theme/themes/matugen-color-theme.json`.
*   The JSON template (`dankshell.json`) meticulously maps Material You colors to VSCode UI elements and token colors.
*   **Result:** Every time the QuickShell wallpaper changes, Matugen overwrites the local JSON file. Antigravity dynamically re-reads it on launch or natively patches its active theme.

---

## 🚫 Critical Developer Warnings & "Gotchas"

*   **`tooltipText` in Custom Quickshell Widgets:**
    *   Do **NOT** add arbitrary properties like `tooltipText` to QuickShell components unless the underlying QML type natively defines them.
    *   Example: Adding `tooltipText` to an instance of `RippleButton.qml` (which does not have it defined) will hard-crash the entire Quickshell UI on launch with a `ReferenceError / TypeError`.
    *   If you need tooltips on custom buttons, wrap them in or implement a proper `PopupToolTip` instead of blindly mutating properties.
*   **Uninstalling Bloatware (Dependency Checks):**
    *   Removing KDE Developer bloat (`plasma-sdk`) will attempt to remove `plasma5support`. QuickShell fundamentally relies on `plasma5support` to render system tray widgets via Qt5 compat. If `plasma5support` is removed, the entire top bar and search launcher will vanish. Always check `pacman` dependency cascades before accepting `[Y/n]`! (Fix: `sudo pacman -S --noconfirm plasma5support`).
*   **Running Quickshell Manually:**
    *   If you ever manually restart QuickShell from a terminal using `qs -c ii` without sending it to the background (`& disown`), QuickShell becomes a *child process* of that specific terminal window. 
    *   When you close that terminal (or use `Ctrl+C`), Linux sends a termination signal to all child processes, resulting in your entire desktop UI instantly vanishing. Always use `killall qs quickshell 2>/dev/null; WAYLAND_DISPLAY=wayland-1 qs -c ii & disown`.

---

## 🎨 Matugen Dynamic Theming Pipeline — Full Architecture

### How It Works (End-to-End)
When you change your wallpaper via the QuickShell UI:
1. QuickShell calls `~/.config/quickshell/ii/scripts/colors/switchwall.sh`
2. `switchwall.sh` runs `matugen image <wallpaper_path> --mode dark`
3. Matugen reads `~/.config/matugen/config.toml` and exports **15 templates** in parallel
4. Each template generates a themed config file for a specific app
5. `post_hook` scripts defined in `config.toml` fire after each template to live-reload apps
6. `switchwall.sh` then runs `generate_colors_material.py` (Python AI) → `material_colors.scss`
7. `applycolor.sh` runs to apply QuickShell-side colors (terminal escape sequences disabled — see below)

### Template Output Map (`~/.config/matugen/config.toml`)
| Template name | Output file | Post-hook |
|---|---|---|
| `m3colors` | `~/.local/state/quickshell/user/generated/colors.json` | none |
| `hyprland` | `~/.config/hypr/hyprland/colors.conf` | none |
| `hyprlock` | `~/.config/hypr/hyprlock/colors.conf` | none |
| `fuzzel` | `~/.config/fuzzel/fuzzel_theme.ini` | none |
| `gtk3` | `~/.config/gtk-3.0/gtk.css` (symlink → `.mydotfiles`) | none |
| `gtk4` | `~/.config/gtk-4.0/gtk.css` (symlink → `.mydotfiles`) | none |
| `kde_colors` | `~/.local/state/quickshell/user/generated/color.txt` | none |
| `wallpaper` | `~/.local/state/quickshell/user/generated/wallpaper/path.txt` | none |
| `discord` | `~/.config/vesktop/themes/midnight.theme.css` | none |
| `spicetify` | `~/.config/spicetify/Themes/caelestia/color.ini` | `spicetify_theme_apply.sh` |
| `btop` | `~/.config/btop/themes/matugen.theme` | none |
| `doom` | `~/.config/doom/themes/doom-matugen-theme.el` | `emacsclient reload` |
| `kitty` | `~/.config/kitty/matugen-colors.conf` | `killall -USR1 kitty` |
| `antigravity` | `~/.antigravity/extensions/matugen-theme/themes/matugen-color-theme.json` | none |
| `vscode` | `~/.vscode/extensions/matugen-theme/themes/matugen-color-theme.json` | none |

### Live Reload Status Per App
| App | Updates live? | Method |
|---|---|---|
| QuickShell Bar / Waybar | ✅ Yes | Reads `colors.json` via QML property binding |
| Kitty Terminal | ✅ Yes | `SIGUSR1` signal via `killall -USR1 kitty` |
| Spicetify (Spotify) | ✅ Yes (usually) | `spicetify refresh -s` CSS injection |
| GTK Apps (Thorium, etc.) | ✅ Yes | matugen writes `gtk.css` on top of base theme |
| Doom Emacs | ✅ Yes | `emacsclient` hot-swaps the loaded theme |
| Antigravity | ✅ Yes | Built-in native theme hot-reload (fork feature) |
| VSCode | ❌ Restart required | Stock VSCode has no built-in theme file watcher |
| Vesktop / Discord | ❌ Restart/Ctrl+R | Chromium sandboxes CSS injection |
| Btop | ❌ Restart | Caches theme in RAM |

---

## 🐛 Critical Bug: ML4W GTK Symlink Write-Protection

### Problem
`~/.config/gtk-3.0` and `~/.config/gtk-4.0` are **symlinks** pointing into the ML4W dotfiles backup:
```
gtk-3.0 → /home/zatch/.mydotfiles/com.ml4w.dotfiles.stable/.config/gtk-3.0
gtk-4.0 → /home/zatch/.mydotfiles/com.ml4w.dotfiles.stable/.config/gtk-4.0
```
The `gtk.css` files inside those symlinked directories were initially installed with btrfs write-protection (or similar), making `chmod` and `chattr` both fail with "Operation not permitted" / "Operation not supported". Matugen would process 7 of 15 templates successfully, then crash with `Permission denied (os error 13)`.

### Symptoms
- First wallpaper change: QuickShell was *slow* to update colors (working via Python, not matugen)
- Second wallpaper change: Nothing updated at all
- `matugen -v` showed failure after 7th export (before gtk templates)
- `chmod 644 ~/.config/gtk-4.0/gtk.css` returned "Operation not permitted"

### Fix
Delete and recreate the write-protected `gtk.css` files as fresh, normal files:
```bash
sudo rm ~/.config/gtk-4.0/gtk.css && echo "" > ~/.config/gtk-4.0/gtk.css
sudo rm ~/.config/gtk-3.0/gtk.css && echo "" > ~/.config/gtk-3.0/gtk.css
```
After this, matugen writes all 15/15 templates correctly.

---

## 🐛 Legacy Terminal Escape Sequence Overwrite

### Problem
After Matugen updated Kitty terminal colors via `SIGUSR1`, the old QuickShell `applycolor.sh` script immediately overwrote them with legacy terminal escape sequences (piped directly into `/dev/pts/*` PTY file descriptors). This caused a brief flash of correct colors followed by an instant revert to "wonky" colors.

### Fix
Disabled the `apply_term` calls in `applycolor.sh`:
```bash
# File: ~/.config/quickshell/ii/scripts/colors/applycolor.sh
# Lines 64 and 69: comment out apply_term &
# apply_term &    # Disabled: Overwrites Matugen SIGUSR1 hot-reloading
```
Matugen's `killall -USR1 kitty` post_hook now has sole authority over Kitty terminal theming.

---

## 🔧 VSCode / Antigravity Matugen Live-Reload Extension

### Why Antigravity Works But VSCode Doesn't
**Antigravity** is a VSCode fork that includes a **built-in native theme file watcher** added to its core. When any file inside its extension theme directories changes, Antigravity hot-reloads the colors without needing any extension at all. This is a custom feature specific to the fork.

**Stock VSCode** has NO built-in theme hot-reload. It only re-reads its theme JSON when the window is explicitly reloaded (`Developer: Reload Window`). Three approaches were attempted for VSCode live-reload:

1. **`fs.watch` on theme file** — Failed silently: Matugen writes files atomically (temp → rename), which changes the inode. `fs.watch` fires a `rename` event and then loses track of the new file forever.
2. **`fs.watch` on parent directory** — Also failed: btrfs does not reliably deliver inotify events to directory watchers for atomic file replacements.
3. **`fs.watchFile` polling** — Also failed: VSCode's Extension Host process has sandbox restrictions that prevent Node.js polling I/O from working reliably.
4. **`vscode.workspace.createFileSystemWatcher`** — The official VSCode API for file watching. Still did not trigger automatic reloads in practice with stock VSCode 1.110.0.

### Current Status
- **Antigravity**: ✅ Updates automatically on wallpaper change (built-in fork feature)
- **VSCode**: ❌ Requires **manual** `Developer: Reload Window` after wallpaper change
  - Shortcut: `Ctrl+Shift+P` → type `reload window` → Enter
  - At least the theme IS correct after reload (matugen writes the JSON correctly)

### Files (kept for reference, not harmful to have installed)
- `~/.vscode/extensions/matugen-live-reload/package.json` — Extension manifest
- `~/.vscode/extensions/matugen-live-reload/extension.js` — File watcher logic
- Duplicated to `~/.antigravity/extensions/matugen-live-reload/` (redundant but harmless)

### Requirements
- Color theme must be set to **"Matugen Dynamic Theme"** in both editors (`Ctrl+K, Ctrl+T`)
- Restart VSCode once after any wallpaper change to see new colors

---

## ⌨️ Keybind: Super+Shift+Number → Move Window to Workspace

Added `Super+Shift+1-10` keybinds in `~/.config/hypr/hyprland/keybinds.conf` to send the currently focused window to a specific workspace number directly (mirroring the existing `Super+Alt+1-10` behavior, which moves AND follows). Both number row and numpad keys are mapped.

---

## 🐛 Unwanted GTK Theme & Icon Theme Overwrites

### Problem 1: GTK Theme Resetting to `adw-gtk3`
Every time the wallpaper changed (or the system rebelled on boot), the `switchwall.sh` script forcibly reset the system GTK theme to GNOME's default `adw-gtk3`. This erased custom GTK themes like Catppuccin, ruining Chrome/Thorium window styles.
**Fix:** Commented out the `gsettings set org.gnome.desktop.interface gtk-theme` lines inside `~/.config/quickshell/ii/scripts/colors/switchwall.sh`.

### Problem 2: KDE/Dolphin Icons Resetting to `breeze-plus-dark`
Similarly, the secondary color script `kde-material-you-colors` was hardcoded to forcibly assert `breeze-plus-dark` (or `breeze-plus` on light mode) onto Dolphin and all KDE Native UI menus every time a wallpaper triggered a color change.
**Fix:** Commented out the `iconslight` and `iconsdark` configuration overrides in `~/.config/kde-material-you-colors/config.conf`.

Both changes ensure that **shapes** (GTK UI Elements and Icons) respect the user's manual KDE Settings selections and persist completely independently of Matugen/QuickShell's continuous wallpaper **color** updates.

---

## 🛑 QuickShell Idle Inhibitor (Keep Awake) vs Hypridle

### Problem
The "Keep Awake" quick toggle in the Quickshell control center relies on creating an invisible 1x1 pixel Wayland surface using the `zwp_idle_inhibit_manager_v1` protocol to block sleep. `hypridle` ignores this surface by default and continues with its hardcoded countdown timers, forcefully locking and suspending the PC regardless of the toggle state.

### Fix
Instead of relying on Wayland protocol semantics, the toggle now forcefully pauses the `hypridle` daemon itself in RAM.
In `~/.config/quickshell/ii/services/Idle.qml`, added `import Quickshell.Io` and injected two new `Process` blocks:
- Activating the toggle runs: `killall -STOP hypridle` (Freezes the lock/sleep timers entirely)
- Deactivating the toggle runs: `killall -CONT hypridle` (Resumes the timers where they left off)

---

## 🤖 AI Interaction Directives (Hard Rules)

1. **NO AUTO-RUNNING COMMANDS:** The AI must NEVER auto-run terminal commands (even safe ones). It must explicitly write the commands out in code blocks and ask the user to copy-paste and run them in their own terminal. This prevents silent failures.
2. **DIAGNOSE FIRST:** Every new issue must follow a strict "Diagnose and Identify -> Fix" pipeline. The AI must first ask for logs or debugging outputs to locate the root cause before attempting to apply any code fixes.
3. **HELP THE USER HELP THE AI:** Provide clear, copy-pasteable reconnaissance commands that the user can run to help the AI understand the current state of the system.

---

## 🚀 Emacs Daemon Autostart

### Problem
Emacs is a heavyweight application that takes several seconds to launch from scratch, causing latency when opening editors.

### Fix
Added the Emacs daemon into the Hyprland autostart sequence so it boots quietly in the background on login. From now on, using `emacsclient -c` will launch a GUI frame instantly.
- **Configured in:** `~/.config/hypr/custom/execs.conf`
- **Line added:** `exec-once = emacs --daemon`
- **Removed Emacs:** 'removed emacs for nvim as it was easier to configure' 

---

## 🛠️ Quickshell / UI Updates (Applied PRs)

> [!NOTE]
> All PRs were applied manually by cherry-picking relevant changes. Only changes that were stable and non-breaking were kept.

### System Updates Button (Bar) — from PR #2732
*   Added `UpdatesButton.qml` to the bar — shows the pending update count with an update icon.
*   **Position:** Left of the CPU/RAM/Swap resource meters in the center-left group (`leftCenterGroup`).
*   Only visible when updates are actually pending (`Updates.count > 0`). Disappears when the system is fully up to date.
*   Shows the raw count (number) with a 2px downward offset for better visual alignment.
*   **Click behavior:** Runs `yay -Syu` in a terminal window to perform the update.
*   **Files modified:** `BarContent.qml` (wired in), `UpdatesButton.qml` (created), `UpdatesPopup.qml` (created)
*   Update check interval is set to **5 minutes** down from 30 minutes, checking both pacman + AUR via `(checkupdates; yay -Qum)`. Checks immediately on startup.
*   Check interval + yay AUR support added to `Updates.qml` and `Config.qml`.

### Network Speed Widget (Bar) — from PR #1826
*   Added `NetworkSpeed.qml` to the bar — shows live ethernet download/upload speed.
*   **Position:** Leftmost item in the right section, directly to the left of the system tray / background apps.
*   No icon — just raw text for a clean look.
*   Reads from `/proc/net/dev`, filtering only interfaces that start with `en` (ethernet only, e.g. `enp12s0`).
*   Speed data is populated by `ResourceUsage.qml` which was updated with `networkDownloadSpeed`, `networkUploadSpeed`, and `previousNetworkStats` properties.
*   **Click behavior:** Cycles display mode — Total → Download Only → Upload Only → Both (↓ / ↑).
*   **Files modified:** `BarContent.qml` (wired in), `NetworkSpeed.qml` (created), `ResourceUsage.qml` (network parsing added), `Config.qml` (added `bar.networkSpeed.enable: true`)

### Dismiss All Notifications — from PR #2739
*   Added a "Dismiss All" button to the notification panel.
*   When clicked, it clears all pending notifications in one action instead of having to dismiss them one by one.

### Scrollable Cheatsheet — from PR #2483
*   Wrapped `CheatsheetKeybinds.qml` in a horizontal and vertical `ScrollView`.
*   Width is clamped to 80% of the screen to prevent overflow on any resolution.
*   Added a placeholder when no keybinds are found.
*   Fixed section column centering bug.

> [!WARNING]
> The following PRs were **attempted but reverted** due to instability or visual glitches. Do NOT re-apply without thorough testing of each change in isolation:
> - **PR #2658** (Overlay Taskbar Settings) — Rewrote `OverlayTaskbar.qml` with animated ListView but caused the entire Quickshell UI to crash. Reverted to upstream.
> - **PR #2709** (Live Lyrics) — Caused layout glitches in the media bar widget. Reverted to upstream.
> - **PR #2717** (Application Drawer) — `ApplicationDrawer.qml` changes were incompatible with the current file structure. Reverted.
### Media Widget Expansion
*   Increased the width of the center-left group from **360px to 420px**.
*   This compensates for the space taken by the new Updates widget, giving the song title/artist text more room to breathe.
*   **Files modified:** `Appearance.qml` (updated `barCenterSideModuleWidth`).

### Upstream March 25th Integration
*   Integrated recent quality-of-life updates directly from the `end-4/dots-hyprland` upstream repository.
*   **Volume Mixer Mute Toggle:** App icons in the volume mixer (`VolumeMixerEntry.qml`) are now clickable to instantly mute/unmute the application. Hovering them displays a helpful tooltip.
*   **Gamma Logic Expansion:** 
*   Decreasing the brightness slider below 0% will now automatically decrease the display gamma down to a floor of `25%`.
    *   A dedicated Gamma slider was added to the "Eye protection" (`NightLightDialog.qml`) menu.
    *   Added visual gamma step indicators directly to the quick sliders inside `QuickSliders.qml`.
*   **Files modified:** `VolumeMixerEntry.qml`, `Hyprsunset.qml` (added gamma variables & API), `Brightness.qml` (connected brightness-below-0 logic to gamma API), `QuickSliders.qml`, `NightLightDialog.qml`, `StyledSlider.qml` (added dividerValues support from upstream).

### Motrix Autostart added
Added the `motrix` download manager into the Hyprland autostart sequence so it boots automatically and sits ready to receive downloads from Thorium on startup.
- **Configured in:** `~/.config/hypr/custom/execs.conf`
- **Line added:** `exec-once = motrix`

### Stylish Slanted Wallpaper Picker UI Activated
Replaced the default grid-based wallpaper picker with the customized, slanted horizontal scrolling gallery based on the visual design found in the `nixos-configuration` repository, exactly as requested.
*   **Completely Integrated**: Unlike the raw code which broke `matugen` and system theming, the rewritten UI bridges directly into your current `Wallpapers.qml` backend. Selecting a wallpaper via the slanted UI flawlessly triggers all of your system's auto-theming, image upscaling, and wallpaper transition scripts.
*   **Video Compatible**: This beautifully slanted UI automatically renders your `.mp4`/video loops alongside standard static pictures thanks to the custom script extensions implemented earlier.
*   **Dimensions Restructured**: Expanded the `WallpaperSelector.qml` window constraints from a tiny grid popup into a massive 1800x520 horizontal floating gallery to allow the slanted rectangles room to breathe and look premium.

### Native Video Wallpaper Support
Instead of manually tearing apart the `ilyamiro` NixOS configuration widget which uses outdated code that conflicts with Matugen, I unlocked the hidden native video wallpaper support directly inside your current setup.
*   **Video Extensions Whitelisted**: `.mp4`, `.webm`, `.mov`, `.mkv`, and `.avi` were exposed to the `Wallpapers.qml` UI menu. They will now appear natively right next to your standard picture wallpapers!
*   **Dynamic UI Thumbnails**: Installed `ffmpegthumbnailer` and modified `generate-thumbnails-magick.sh` so whenever a video wallpaper is detected, it instantly extracts the first frame using `ffmpeg` and crops it into a perfectly sized thumbnail for your wallpaper menu to display.
*   **Wallpaper Service Automation**: Upon selecting a video wallpaper via the UI menu, `switchwall.sh` safely suspends standard wallpaper processes, launches `mpvpaper` to smoothly loop the video behind your windows, and natively extracts a still-frame using `ffmpeg` to feed to your dynamic `matugen` coloring engine! Your windows, borders, and UI will still perfectly theme to the colors inside the video!
*   **Added Dependencies**: Installed `ffmpeg`, `mpv`, `mpvpaper`, `ffmpegthumbnailer` to allow all of this.

---

## 🔴 Incident: System Crash During Wallpaper Picker Integration (2026-03-26)

### What happened
After the first attempt at integrating the slanted wallpaper picker, the system became unresponsive, the lockscreen broke, and the bar/UI disappeared on every Quickshell restart.

### Root causes (3 bugs)
1. **Corrupted `config.json` wallpaperPath** — The wallpaper picker applied a thumbnail path (`Yae_miko.jpg`) from the thumbs cache instead of the original source file. Since thumbnails are named `<original>.jpg` (`.jpg` always appended), the stored path ended up as `Yae_miko.jpg.jpg`. This file doesn't exist, so `Background.qml` called `magick identify` on it, got no output, and crashed with `Cannot assign [undefined] to int`. **Fixed by:** correcting the path in `config.json` and ensuring the picker always strips the trailing `.jpg` before calling `Wallpapers.select()`.
2. **Full-screen Wayland overlay window** — `WallpaperSelector.qml` was anchored to all four sides (`top/bottom/left/right: true`), which created a full-monitor invisible layer shell window. With `WlrKeyboardFocus.OnDemand` active, Quickshell entered an infinite Wayland focus-grab loop and spiked to 99% CPU. **Fixed by:** anchoring only `top/left/right` with a fixed `implicitHeight: 520`.
3. **Infinite `onCountChanged` loop** — The `FolderListModel` handler fired `focusCurrentWallpaper()` on every item count change, which caused layout shifts that triggered more count changes. **Fixed by:** adding a `_focusDone` guard flag and only running focus logic once when `status === FolderListModel.Ready`.

### Files fixed
- `~/.config/illogical-impulse/config.json` — wallpaperPath corrected
- `~/.config/quickshell/ii/modules/ii/wallpaperSelector/WallpaperSelector.qml` — anchor crash fixed
- `~/.config/quickshell/ii/modules/ii/wallpaperSelector/WallpaperSelectorContent.qml` — loop fixed, path reconstruction cleaned up

---

## Git Dotfiles Backup System (2026-03-26)

### Unified Backup Script
Added a Git-based backup system to safely track and roll back changes to the entire `end-4` desktop environment. Since modifying QML UI can sometimes lead to catastrophic system lockups (as seen above), this provides a pristine system state to revert to.
*   **Location:** `~/end4-dots-backup/`
*   **Script:** `~/end4-dots-backup/backup.sh`
*   **Filtering:** Updated to include **Vivaldi** configurations while automatically excluding massive binary cache folders (`Cache`, `GPUCache`, etc.) to keep the GitHub repository small and fast.

---

## 🛠️ March 29th System Optimizations

### Resource Monitoring & Stability
- **`ResourceUsage.qml` Performance Fix**: Discovered the CPU monitoring service was polling `/proc/stat` and `/proc/meminfo` every **1ms**, causing significant system lag and wasted cycles. 
    - **Fix:** Increased polling interval to **2000ms** (2 seconds).
    - **Memory Parsing:** Corrected the regex for memory values to handle variable spacing in system files.
- **Matugen Path Safety**: Finalized the fix for `switchwall.sh` by enforcing the absolute path to `matugen` (`/home/zatch/.local/bin/matugen`), preventing background service failures.

### Theming & Aesthetics
- **Discord (Vesktop) - Midnight Template**:
    - Replaced the basic Matugen template with the premium **Midnight** theme from the NixOS-configuration-master dotfiles.
    - Full Material You support: Backgrounds, accents, and status indicators now all update dynamically when you change your wallpaper.
- **Thumbnail Engine Refactor**:
    - Re-wrote `generate-wallpaper-thumbs.sh` to remove Bash function exports that were causing "command not found" errors.
    - Switched to inlined `nice` calls and standard backgrounding (`&`) for full-speed, error-free thumbnail generation.

### Browser Migration (Thorium → Vivaldi)
- Successfully migrated **History** and **Extensions** from Thorium to Vivaldi by manually bridging the `Default` profile folders.
- Since passwords are managed via **Dashlane**, browser encryption keys were safely ignored to maintain a clean Vivaldi Sync setup.
- Updated all Hyprland keybinds to launch `vivaldi` natively.
