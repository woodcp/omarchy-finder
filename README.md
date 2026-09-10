# omarchy-finder

A Spotlight / Alfred style finder for [Omarchy](https://omarchy.org): press a
hotkey, type part of a file or folder name, hit Enter to open it. The same box
composes an email or runs a web search from whatever you typed.

Built from what Omarchy already ships: `plocate` for instant indexed search,
`fzf` for the picker, `xdg-open` to hand results to the default app, and a
floating terminal styled by your current theme.

## Keys

| Key    | Action                                            |
|--------|---------------------------------------------------|
| Enter  | Open the selected file or folder in its default app |
| Ctrl-O | Reveal the selection in the file manager          |
| Ctrl-Y | Copy the selected path to the clipboard           |
| Ctrl-E | Compose a Gmail message from the typed text (see below) |
| Ctrl-W | Web search the typed text                          |
| Esc    | Close                                              |

For email, any word containing `@` becomes a recipient and the remaining
words become the subject, so `bob@example.com invoice for august` opens a
compose window addressed to Bob with that subject. Several addresses work
too. Text with no address just sets the subject.

Type a math expression instead of a name (`245+33*16`, `(1200*0.07)/12`,
`2^10`) and the answer shows as the first row. Enter copies it to the
clipboard.

Multiple words all have to match somewhere in the path, so `afoa report md`
narrows quickly. Matching is case-insensitive.

## Previews

The right-hand pane previews the highlighted result: images, SVGs, and the
first page of PDFs render as pictures using sixel graphics, which foot (the
Omarchy terminal) supports natively. Videos show a frame, text files show
their head, and folders show their listing. Rendering uses ImageMagick and
poppler, both part of the Omarchy base install; if `chafa` is installed it is
used for images instead.

## Install

```bash
git clone https://github.com/woodcp/omarchy-finder.git ~/Work/omarchy-finder
~/Work/omarchy-finder/install.sh
```

That links `omarchy-finder` into `~/.local/bin`, adds a `SUPER + D` binding
and a floating window rule to `~/.config/hypr/bindings.lua`, and reloads
Hyprland. Set `FINDER_KEY="SUPER + PERIOD"` before running the installer to
pick a different key.

## Configuration

Environment variables read at launch:

| Variable          | Default                 | Purpose                          |
|-------------------|-------------------------|----------------------------------|
| `FINDER_ROOT`     | `$HOME`                 | Directory the search is limited to |
| `FINDER_LIMIT`    | `400`                   | Maximum rows shown               |
| `FINDER_MAIL_URL` | Gmail compose URL       | Base URL; `&to=` and `&su=` are appended |
| `FINDER_WEB_URL`  | Google search URL       | Prefix the query is appended to  |

Noisy directories (`.git`, `node_modules`, `.cache`, build output, package
caches) are excluded.

## Index freshness

Results come from the plocate database, refreshed nightly by
`plocate-updatedb.timer`. Files created since the last run won't appear until
then; `sudo updatedb` refreshes it immediately.
