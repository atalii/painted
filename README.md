# painted
plain text notification daemon

## Overview
painted is a dead simple notification daemon: it reads commands from a file
(which may be a UNIX socket for IPC or any text file such as stdin for
simplicity), notifications from dbus, and writes output to a given file (usually
stdout). It aims to be a UNIX-ish replacement for standard notification daemons,
primarily for usage with bars.

Despite the name (a rough contraction of the initialism PTND, for Plain Text
Notification Daemon), the scope of Painted is not limited to plain text: planned
features include actions, sounds, and more. The goal is to achieve 'minimalism'
through an unrestrictive design that facilitates scripting, run-time
modification, and, of course, completeness.

## Building
Painted is built with Nix Flakes. On a system with Nix Flakes, run `nix build`.
If you don't have Flakes and/or Nix, `go build ./cmd/painted` will probably
work, too, though this isn't :sparkles: officially supported :sparkles:.

## Usage

### In General
With no other notification daemons running, run the server (with the command
`painted`). If you send a notification with `notify-send`, you should see it
show up in the terminal window where you've run painted.

With no arguments, painted defaults to reading input commands from stdin.
Available commands (those currently implemented shown checked) are:

- [x] help (list commands).
- [x] clear (print a blank line to hide the notification)
- [ ] remove (remove the notification from history)
- [x] previous (show the previous notification)
- [x] next (show the next notification)
- [x] expand (show body text for the currently selected notification)
- [x] summarize (show overview of the currently selected notification)
- [ ] action \<N> (select the n\'th action)
- [x] exit (close the server)

You may specify the input and output file anywhere, including /dev/stdin
(default in) and /dev/stdout (default out). If you want to control it from a
different file, specify it. For instance, in bars, you wouldn't want to have
input be given over stdin because there is no (convenient) way to access a
process's stdin without an interactive shell.

If the input file ends in `.sock`, painted connects to it as a client on a UNIX
socket.

### Configuring
Painted looks for a config file at `~/.config/painted/conf.toml`. This is toml,
and stores the following options:

```toml
[formats]
summary  = "[%o] %s"
expanded = "%b | %a"
```

A format string is just a normal string, with the exception that a % sign
followed by a specific character will insert information about the notification.
A % sequence may be one of the following:

+ `%b`: the body text of the notification
+ `%a`: any actions that may be performed
+ `%i`: the ID of the notification.
+ `%o`: the app that *o*riginated the notification.
+ `%s`: the summary text of the notification.

The above format sequences may be interleaved with anything valid in a standard
toml string.

### Some Specific Config Files
Check the contrib/ folder for some config files that invoke painted in a way
that makes sense. Note that the contrib directory isn't super well-maintained,
and just exists as a dumping ground for stuff that you may or may not want to
use[^1].

## Roadmap and TODOs
This isn't supposed to be one of those highly minimal UNIX utilities, but it's
also not supposed to be massive. That said, here's what I'm currently wanting to
implement:

- Basic:
  - [x] Actually record notifications (obviously)
  - [x] Notification history and navigation
  - [x] persistence
  - [x] Command matching by prefix (i.e., only `pr` to activate `previous` so
        long as no other command begins with `pr`)
  - [x] notification format strings
  - [x] body text
- Additional (everything necessary for a 1.0.0):
  - [ ] Actions
  - [ ] Docs
- Unneeded, but nice:
  - [ ] Do not disturb mode
  - [ ] Sounds

[^1]: https://drewdevault.com/2020/06/06/Add-a-contrib-directory.html

## Releases and Changelog
Painted roughly follows SemVer. Changes are documented in annotated git tags. To
view the release notes for a given release, run `git show v[release-number]`,
for example, `git show v0.1.0`.
