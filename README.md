# omarchy-finder

Spotlight for [Omarchy](https://omarchy.org). Press **Super+D**, start typing,
and the thing you want is one Enter away: a file, a folder, a quick
calculation, an email, or a web search.

```
┌──────────────────────────────────────────────────────────────────────┐
│  ⏎ open · ^O reveal · ^Y copy · ^E email · ^W web · esc close        │
│    afoa scouting md                                                  │
│  > ~/Work/afoa/scouting-reports/2026-08-28-leander/scouting-report.md│  # Leander at Pflugerville
│    ~/Work/afoa/scouting-reports/2026-09-04-hutto/scouting-report.md  │
│    ~/Work/afoa/college/2026-09-05-mcmurry/scouting-report.md         │  ## Offense
│                                                                      │  ...
└──────────────────────────────────────────────────────────────────────┘
```

Nothing to install beyond this repo. It is a shell script on top of tools
Omarchy already ships: `plocate` for instant indexed search, `fzf` for the
picker, `xdg-open` to hand results to the right app, and a floating `foot`
terminal that picks up your current theme.

## Install

```bash
git clone https://github.com/woodcp/omarchy-finder.git ~/Work/omarchy-finder
~/Work/omarchy-finder/install.sh
```

The installer:

1. Symlinks `omarchy-finder` into `~/.local/bin`, so updates are a `git pull`.
2. Appends a `SUPER + D` binding and a floating window rule to
   `~/.config/hypr/bindings.lua`.
3. Reloads Hyprland and validates the config.

Prefer another key? Set it before running the installer:

```bash
FINDER_KEY="SUPER + PERIOD" ~/Work/omarchy-finder/install.sh
```

The installer is idempotent. Running it again after a `git pull` is safe and
changes nothing if the binding is already present.

### Requirements

Everything below is part of a stock Omarchy 4 install.

| Tool | Used for |
|------|----------|
| `plocate` | The search index (`plocate-updatedb.timer` refreshes it nightly) |
| `fzf` | The picker |
| `foot` | Floating terminal with sixel graphics for previews |
| `xdg-open`, `uwsm-app` | Opening results in the default app, detached from the picker |
| `wl-copy` | Clipboard |
| ImageMagick, poppler, ffmpeg | Image, PDF, and video previews |

Optional: `chafa` (`omarchy pkg add chafa`) gives slightly better image
previews and is used automatically when present.

## Using it

Press **Super+D**. A floating picker opens with an empty search box.

### Find and open files

Type any part of a file or folder name. Results appear as you type, newest
matches from the index first. Every word you type has to match somewhere in
the path, so narrowing is fast:

| You type | You get |
|----------|---------|
| `scouting` | Everything with "scouting" in its path |
| `scouting md` | Only the Markdown files among those |
| `afoa scouting md` | Only the ones under a folder named afoa |

Matching is case-insensitive. Noisy directories are skipped: `.git`,
`node_modules`, `.cache`, package caches, and .NET build output.

Move with the arrow keys, then:

| Key | Action |
|-----|--------|
| **Enter** | Open the file or folder in its default app |
| **Ctrl-O** | Reveal it: open the containing folder in the file manager |
| **Ctrl-Y** | Copy the full path to the clipboard |
| **Esc** | Close without doing anything |

The pane on the right previews whatever is highlighted: images, SVGs, and the
first page of PDFs as pictures, a frame from videos, the head of text files,
and the listing of folders.

### Calculate

Type an expression instead of a name and the answer is the first row.
**Enter** copies it to the clipboard.

| You type | First row |
|----------|-----------|
| `245+33*16` | `= 773` |
| `(1200*0.07)/12` | `= 7` |
| `2^10` | `= 1024` |
| `10/3` | `= 3.333333333` |

Supported: `+ - * / % ^` and parentheses. Anything that isn't a complete
expression, including division by zero, is treated as a file search instead.

### Email

Press **Ctrl-E** and a Gmail compose window opens, filled in from what you
typed. Words containing `@` are recipients; the rest is the subject.

| You type | Compose window |
|----------|----------------|
| `bob@example.com invoice for august` | To: bob@example.com, Subject: invoice for august |
| `lane@woodcp.com, todd@dhango.com game notes` | Two recipients, Subject: game notes |
| `weekly status` | Subject only |

Names without an address are not resolved. Type the first letters of the
name in Gmail's To field once the window is open and Gmail completes it.

### Web search

Press **Ctrl-W** to search the web for whatever you typed.

## Configuration

Set these in the environment of the Hyprland session (for example in
`~/.config/environment.d/finder.conf`, applied at next login) or in the
binding itself.

| Variable | Default | Purpose |
|----------|---------|---------|
| `FINDER_ROOT` | `$HOME` | Directory the search is limited to |
| `FINDER_LIMIT` | `400` | Maximum rows shown |
| `FINDER_MAIL_URL` | Gmail compose URL | Base compose URL; `&to=` and `&su=` are appended |
| `FINDER_WEB_URL` | Google search URL | Prefix the encoded query is appended to |
| `FINDER_DEBUG` | unset | Path of a log file; records what the picker returned and launched |

To use a different mail client or search engine, point the URL variables at
their compose or search endpoints. For Outlook on the web, for instance:

```
FINDER_MAIL_URL=https://outlook.office.com/mail/deeplink/compose?
FINDER_WEB_URL=https://duckduckgo.com/?q=
```

## Keeping the index fresh

Results come from the plocate database, which `plocate-updatedb.timer`
rebuilds nightly. A file created today shows up tomorrow unless you refresh
by hand:

```bash
sudo updatedb
```

## Troubleshooting

**Super+D does nothing.** Check the binding is present with
`omarchy menu keybindings --print | grep -i finder`, then
`hyprctl configerrors` for a config problem.

**Results never appear.** The index may be missing. `plocate -l 1 -- "$HOME/"`
should print a path. If it errors, run `sudo updatedb` once.

**A key seems to close the picker but nothing opens.** Set `FINDER_DEBUG` to a
file path, reproduce, and read the file. It shows the query, which key was
pressed, and the command handed to `uwsm-app`.

**Previews show a text dump for an image.** The terminal running the picker
must support sixel graphics. Omarchy's default `foot` does; if you switched
terminals, Alacritty does not.

## Uninstall

```bash
rm ~/.local/bin/omarchy-finder
```

Then delete the three `omarchy-finder` lines at the bottom of
`~/.config/hypr/bindings.lua` and run `hyprctl reload`.

## License

MIT, Wood Consulting Partners, LLC.
