{ pkgs, ... }:

''
  tmem() {
    local editor="''${EDITOR:-nvim}"
    local base="''${XDG_STATE_HOME:-$HOME/.local/state}"
    local dir="$base/tmem"
    mkdir -p "$dir" || return 1

    # List mode: select and open existing memo
    if [[ "$1" == "list" || "$1" == "-l" ]]; then
      local selected
      selected=$(${pkgs.coreutils}/bin/ls -t "$dir"/memo.*.md 2>/dev/null | \
                 ${pkgs.fzf}/bin/fzf --preview="${pkgs.bat}/bin/bat --color=always {}" \
                                     --preview-window=right:70%)

      if [[ -n "$selected" ]]; then
        "$editor" "$selected"
      fi
      return
    fi

    # Create new memo
    local ts
    ts="$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)"

    local f
    f="$(${pkgs.coreutils}/bin/mktemp "$dir/memo.$ts.XXXXXXXX.md")" || return 1

    ${pkgs.coreutils}/bin/ln -sf "$f" "$dir/latest.md"
    printf '[tmem] %s\n' "$f" >&2
    "$editor" "$f"
  }
''
