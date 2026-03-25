# ClaudeOS Proactive Monitor — systemd user services
#
# Tier 1: Health check timer (every 15 min, pure bash, $0 cost)
# Tier 2: Claude notification service (OnFailure handler, rate-limited)
# Tier 3: Daily morning briefing (9 AM)
{ pkgs, ... }:

let
  healthCheckScript = ../scripts/health-check.sh;

  notifyScript = pkgs.writeShellScript "claudeos-notify" ''
    export PATH="${
      pkgs.lib.makeBinPath [
        pkgs.coreutils
        pkgs.libnotify
        pkgs.ghostty
      ]
    }:$PATH"

    CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/claudeos-monitor"
    CONTEXT_FILE="$CACHE_DIR/alert-context.txt"
    COOLDOWN_FILE="$CACHE_DIR/last-claude-call"
    COOLDOWN=1800  # 30 minutes

    [[ ! -s "$CONTEXT_FILE" ]] && exit 0
    context=$(<"$CONTEXT_FILE")

    # Rate limit
    use_claude=true
    if [[ -f "$COOLDOWN_FILE" ]]; then
      last=$(stat -c %Y "$COOLDOWN_FILE" 2>/dev/null || echo 0)
      now=$(date +%s)
      (( now - last < COOLDOWN )) && use_claude=false
    fi

    if $use_claude; then
      CLAUDE_BIN="$HOME/.local/bin/claude"
      if [[ -x "$CLAUDE_BIN" ]]; then
        prompt="You are ClaudeOS, the AI monitoring this Ubuntu system. Analyze these alerts and respond with ONLY the notification body text (2-3 sentences max). Be specific and actionable. No markdown, no emoji, plain text only.

    $context"

        notification=$("$CLAUDE_BIN" -p "$prompt" --model sonnet 2>/dev/null) || notification=""

        if [[ -n "$notification" ]]; then
          touch "$COOLDOWN_FILE"
          action=$(notify-send \
            --app-name=ClaudeOS --urgency=critical \
            -A "fix=Open in Claude" -A "dismiss=Dismiss" \
            "ClaudeOS Monitor" "$notification")

          if [[ "$action" == "fix" ]]; then
            alert_file="$CACHE_DIR/alert-for-claude.txt"
            printf '%s\n\n--- Claude summary ---\n%s\n' "$context" "$notification" > "$alert_file"
            ghostty --class=claude-quick -e bash -c "
              claude -p 'ClaudeOS health monitor detected issues. Alert context:

    $(cat "$alert_file")

    Diagnose and fix these issues.' --allowedTools 'Bash,Read,Grep,Glob,mcp__system-health*'
              echo
              echo \"Press Enter to close...\"
              read
            "
          fi
          exit 0
        fi
      fi
    fi

    # Fallback: raw context
    fallback=$(echo "$context" | head -15)
    notify-send --app-name=ClaudeOS --urgency=critical "System Alert" "$fallback"
  '';

  dailyBriefScript = pkgs.writeShellScript "claudeos-daily-brief" ''
    export PATH="${
      pkgs.lib.makeBinPath [
        pkgs.coreutils
        pkgs.systemd
        pkgs.procps
        pkgs.gawk
        pkgs.git
        pkgs.libnotify
        pkgs.ghostty
      ]
    }:$PATH"

    CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/claudeos-monitor"
    BRIEF_FILE="$CACHE_DIR/daily-brief.txt"
    STATS_FILE="$CACHE_DIR/daily-stats.txt"
    CLAUDEOS_DIR="$HOME/Projects/claudeos"
    mkdir -p "$CACHE_DIR"

    now=$(date +%s)
    host=$(hostname 2>/dev/null || echo unknown)
    up=$(uptime -p 2>/dev/null || echo unknown)

    failed_sys=$(systemctl --failed --no-legend --no-pager 2>/dev/null | awk '{print $2}' | paste -sd", " || true)
    failed_usr=$(systemctl --user --failed --no-legend --no-pager 2>/dev/null | awk '{print $2}' | paste -sd", " || true)
    [[ -z "$failed_sys" ]] && failed_sys="none"
    [[ -z "$failed_usr" ]] && failed_usr="none"

    disk_pct=$(df / 2>/dev/null | awk 'NR==2 {gsub(/%/,"",$5); print $5}')

    # Pending updates
    upgradable=$(apt list --upgradable 2>/dev/null | grep -c -v "^Listing" || echo 0)

    # Config repo status
    if [[ -d "$CLAUDEOS_DIR/.git" ]]; then
      dirty=$(git -C "$CLAUDEOS_DIR" status --porcelain 2>/dev/null | wc -l)
      unpushed=$(git -C "$CLAUDEOS_DIR" log @{u}..HEAD --oneline 2>/dev/null | wc -l)
      git_info=""
      [[ $dirty -gt 0 ]] && git_info="$dirty uncommitted changes"
      [[ $unpushed -gt 0 ]] && git_info="''${git_info:+$git_info, }$unpushed unpushed commits"
      [[ -z "$git_info" ]] && git_info="clean, up to date"
      branch=$(git -C "$CLAUDEOS_DIR" branch --show-current 2>/dev/null || echo unknown)
    else
      git_info="not a git repo"
      branch="n/a"
    fi

    stats="Host: $host
    Uptime: $up
    Failed services (system): $failed_sys
    Failed services (user): $failed_usr
    Root disk: ''${disk_pct}% used
    Pending apt updates: $upgradable
    Config branch: $branch
    Config repo: $git_info"

    echo "$stats" > "$STATS_FILE"

    CLAUDE_BIN="$HOME/.local/bin/claude"
    if [[ -x "$CLAUDE_BIN" ]]; then
      prompt="You are ClaudeOS, the AI managing this Ubuntu system. Write a concise daily briefing (2-4 sentences) for the terminal MOTD. Focus on what needs attention. If everything is healthy, say so briefly. No markdown, no emoji, plain text only.

    $stats"

      brief=$("$CLAUDE_BIN" -p "$prompt" --model sonnet 2>/dev/null) || brief=""

      if [[ -n "$brief" ]]; then
        echo "$brief" > "$BRIEF_FILE"
        action=$(notify-send \
          --app-name=ClaudeOS \
          -A "details=Details" -A "dismiss=Dismiss" \
          "Good Morning" "$brief")

        if [[ "$action" == "details" ]]; then
          ghostty --class=claude-quick -e bash -c "
            claude -p 'Good morning. System stats:

    $(cat "$STATS_FILE")

    Review and let me know if anything needs attention.' --allowedTools 'Bash,Read,Grep,Glob,mcp__system-health*'
            echo
            echo \"Press Enter to close...\"
            read
          "
        fi
        exit 0
      fi
    fi

    echo "$stats" > "$BRIEF_FILE"
    notify-send --app-name=ClaudeOS "Good Morning" "Daily briefing ready — check your terminal."
  '';
in
{
  # Tier 1: Health check (pure bash, zero cost)
  systemd.user.services.claudeos-health-check = {
    Unit = {
      Description = "ClaudeOS system health check";
      OnFailure = "claudeos-notify.service";
    };
    Service = {
      Type = "oneshot";
      ExecStart = toString healthCheckScript;
    };
  };

  systemd.user.timers.claudeos-health-check = {
    Unit.Description = "Run ClaudeOS health check every 15 minutes";
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "15min";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Tier 2: Claude notification handler (on health check failure)
  systemd.user.services.claudeos-notify = {
    Unit = {
      Description = "ClaudeOS Claude-authored notification handler";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = toString notifyScript;
      TimeoutStartSec = "30min";
    };
  };

  # Tier 3: Daily morning briefing
  systemd.user.services.claudeos-daily-brief = {
    Unit.Description = "ClaudeOS morning system briefing";
    Service = {
      Type = "oneshot";
      ExecStart = toString dailyBriefScript;
      TimeoutStartSec = "30min";
    };
  };

  systemd.user.timers.claudeos-daily-brief = {
    Unit.Description = "ClaudeOS daily morning briefing at 9 AM";
    Timer = {
      OnCalendar = "*-*-* 09:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
