{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.kdlt.darwin.bundles.kidlat-backup;
  home = "/Users/${username}";

  # restic -> Backblaze B2 backup of the kidlat-kitchens workspace and its
  # agent memory. The B2 credentials + repo password live in
  # ~/.config/restic/b2-env (mode 600, placed by hand, NOT nix-managed --
  # RESTIC_PASSWORD is the only key to the repo). The scripts source it.
  kidlat-backup = pkgs.writeShellApplication {
    name = "kidlat-backup.sh";
    runtimeInputs = [
      pkgs.restic
      pkgs.coreutils
    ];
    text = ''
      # shellcheck disable=SC1091
      source "$HOME/.config/restic/b2-env"

      LOGFILE="$HOME/.local/state/kidlat-backup.log"
      mkdir -p "$(dirname "$LOGFILE")"

      WS="$HOME/kidlat-kitchens"
      MEMDIR="$HOME/.claude/projects/-Users-kba-kidlat-kitchens/memory"

      if [ "$#" -eq 0 ]; then set -- --tag kidlat-manual; fi

      {
        echo "=== backup run: $(date +%Y-%m-%dT%H:%M:%S%z) ==="
        restic backup "$WS" "$MEMDIR" "$@"
        echo "--- forget/prune ---"
        # always scope retention to this host so one machine never prunes
        # another machine's snapshots in the shared repo
        restic forget --prune --host "$(hostname -s)" \
          --keep-daily 7 --keep-weekly 8 --keep-monthly 12
        echo "=== backup finished: $(date +%Y-%m-%dT%H:%M:%S%z) ==="
      } >> "$LOGFILE" 2>&1
    '';
  };

  kidlat-memory-watch = pkgs.writeShellApplication {
    name = "kidlat-memory-watch.sh";
    runtimeInputs = [
      pkgs.fswatch
      pkgs.coreutils
      kidlat-backup
    ];
    text = ''
      WATCH_DIR="$HOME/.claude/projects/-Users-kba-kidlat-kitchens/memory"
      WATCH_CLAUDE_MD="$HOME/kidlat-kitchens/CLAUDE.md"
      DEBOUNCE_SECS=30
      LOGFILE="$HOME/.local/state/kidlat-memory-watch.log"
      mkdir -p "$(dirname "$LOGFILE")"
      echo "$(date +%Y-%m-%dT%H:%M:%S%z) watcher started" >> "$LOGFILE"

      classify() { [ "$1" = "$WATCH_CLAUDE_MD" ] && echo claudemd || echo memory; }

      fswatch -r "$WATCH_DIR" "$WATCH_CLAUDE_MD" 2>>"$LOGFILE" | \
      while true; do
        saw_memory=0; saw_claudemd=0
        read -r p || { echo "$(date +%Y-%m-%dT%H:%M:%S%z) stream ended" >> "$LOGFILE"; break; }
        case "$(classify "$p")" in claudemd) saw_claudemd=1;; *) saw_memory=1;; esac
        while read -r -t "$DEBOUNCE_SECS" p; do
          case "$(classify "$p")" in claudemd) saw_claudemd=1;; *) saw_memory=1;; esac
        done
        tags=()
        [ "$saw_memory" -eq 1 ]   && tags+=(--tag kidlat-auto-memory)
        [ "$saw_claudemd" -eq 1 ] && tags+=(--tag kidlat-auto-claudemd)
        echo "$(date +%Y-%m-%dT%H:%M:%S%z) quiet period elapsed, backing up (''${tags[*]})" >> "$LOGFILE"
        kidlat-backup.sh "''${tags[@]}" || { rc=$?; echo "$(date +%Y-%m-%dT%H:%M:%S%z) backup FAILED rc=$rc" >> "$LOGFILE"; }
      done
    '';
  };
in
{
  options.kdlt.darwin.bundles.kidlat-backup.enable = lib.mkEnableOption ''
    restic -> Backblaze B2 backup for the kidlat-kitchens workspace:
    the restic package, the backup + fswatch-watcher scripts (symlinked
    into ~/.local/bin), and two launchd agents (daily 03:15 + a
    KeepAlive memory watcher). The B2 credential file
    ~/.config/restic/b2-env is placed by hand, not managed here'';

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.home = {
      packages = [ pkgs.restic ]; # for interactive `restic snapshots` etc.

      # keep the historical paths so the workspace's SessionEnd hook
      # (/Users/kba/.local/bin/kidlat-backup.sh ...) keeps resolving
      file.".local/bin/kidlat-backup.sh".source = "${kidlat-backup}/bin/kidlat-backup.sh";
      file.".local/bin/kidlat-memory-watch.sh".source = "${kidlat-memory-watch}/bin/kidlat-memory-watch.sh";
    };

    launchd.user.agents.kidlat-backup-daily.serviceConfig = {
      ProgramArguments = [
        "${kidlat-backup}/bin/kidlat-backup.sh"
        "--tag"
        "kidlat-auto-scheduled"
      ];
      StartCalendarInterval = [
        {
          Hour = 3;
          Minute = 15;
        }
      ];
      EnvironmentVariables.HOME = home;
      StandardOutPath = "/tmp/com.kidlat.backup.daily.out";
      StandardErrorPath = "/tmp/com.kidlat.backup.daily.err";
    };

    launchd.user.agents.kidlat-memory-watch.serviceConfig = {
      ProgramArguments = [ "${kidlat-memory-watch}/bin/kidlat-memory-watch.sh" ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables.HOME = home;
      StandardOutPath = "/tmp/com.kidlat.memory-watch.out";
      StandardErrorPath = "/tmp/com.kidlat.memory-watch.err";
    };
  };
}
