#!/usr/bin/env bash
# Claude Code status line
# Line 1: 🤖 model  |  📁 path  🌿 branch ✅  |  🔀 worktree  |  🎨 session
# Line 2: 🧠 [bar] 140k left (turn ↑598 ↓13.6k) ⚡73%  |  5H bar 65% (1h30m)  |  7D bar 47% (3d14h)

input=$(cat)

# Initialise all vars so a failed eval degrades gracefully (empty fields) not catastrophically
cwd="" model="" used_pct="" ctx_size="" turn_in="" turn_out=""
cache_read="" cache_create="" session_name="" worktree_name="" worktree_branch=""

eval "$(printf '%s' "$input" | jq -r '
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "model=\(.model.display_name // "")",
  @sh "used_pct=\(.context_window.used_percentage // "")",
  @sh "ctx_size=\(.context_window.context_window_size // "")",
  @sh "turn_in=\(.context_window.current_usage.input_tokens // "")",
  @sh "turn_out=\(.context_window.current_usage.output_tokens // "")",
  @sh "cache_read=\(.context_window.current_usage.cache_read_input_tokens // "")",
  @sh "cache_create=\(.context_window.current_usage.cache_creation_input_tokens // "")",
  @sh "session_name=\(.session_name // "")",
  @sh "worktree_name=\(.worktree.name // .workspace.git_worktree // "")",
  @sh "worktree_branch=\(.worktree.branch // "")"
' 2>/dev/null)" 2>/dev/null

used_int=${used_pct%.*}
used_int=${used_int:-0}

# ── helpers ──────────────────────────────────────────────────────────────────

# fmt_countdown <seconds>
#   Returns a human-readable countdown string:
#     >= 86400s  → "Xd Yh"   e.g. "3d14h"
#     >= 3600s   → "XhYYm"   e.g. "1h30m"
#     > 0s       → "Xm"      e.g. "45m"
#     <= 0       → "now"
# (pure bash; called with pre-computed diff from the consolidated python3 block)
fmt_countdown() {
  local diff=$1
  if [ "$diff" -le 0 ] 2>/dev/null; then
    echo "now"
  elif [ "$diff" -ge 86400 ] 2>/dev/null; then
    local days=$(( diff / 86400 ))
    local hours=$(( (diff % 86400) / 3600 ))
    echo "${days}d${hours}h"
  elif [ "$diff" -ge 3600 ] 2>/dev/null; then
    local hours=$(( diff / 3600 ))
    local mins=$(( (diff % 3600) / 60 ))
    printf "%dh%02dm" "$hours" "$mins"
  elif [ "$diff" -gt 0 ] 2>/dev/null; then
    if [ "$diff" -lt 60 ]; then
      echo "<1m"
    else
      echo "$(( diff / 60 ))m"
    fi
  fi
}

# make_bar <pct> <width> [color]
#   color="cyan"  — solid cyan (#0af) gradient for the context window bar
#   color omitted — green → yellow → red gradient for subscription usage bars
make_bar() {
  local pct=${1:-0} width=$2 color=${3:-""}
  case $pct in ''|*[!0-9]*) pct=0 ;; esac
  local filled=$(( pct * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$(( width - filled ))
  local result="" i t r g b
  for (( i=0; i<filled; i++ )); do
    if [ "$color" = "cyan" ]; then
      # Cyan: interpolate from bright cyan (#00cfff) to steel blue (#0066cc) as fill increases
      if [ "$width" -le 1 ]; then t=0; else t=$(( i * 100 / (width - 1) )); fi
      r=$(( t * 0 / 100 ))
      g=$(( 207 - t * 105 / 100 ))
      b=$(( 255 - t * 51 / 100 ))
      result="${result}\033[38;2;${r};${g};${b}m█"
    else
      if [ "$width" -le 1 ]; then t=0; else t=$(( i * 100 / (width - 1) )); fi
      if [ "$t" -lt 50 ]; then
        r=$(( t * 150 / 50 + 30 )); g=180
      else
        r=180; g=$(( (100 - t) * 150 / 50 + 30 ))
      fi
      result="${result}\033[38;2;${r};${g};0m█"
    fi
  done
  result="${result}\033[0m"
  [ "$empty" -gt 0 ] && result="${result}\033[2;37m$(printf "%${empty}s" | tr ' ' '░')\033[0m"
  printf "%b" "$result"
}

# semantic colour based on percentage
pct_color() {
  local pct=$1
  if   [ "$pct" -ge 90 ] 2>/dev/null; then printf '\033[0;31m'
  elif [ "$pct" -ge 70 ] 2>/dev/null; then printf '\033[0;33m'
  else                                      printf '\033[0;32m'
  fi
}

# human-readable tokens (e.g. 12.3k)
fmt_tokens() {
  local n=${1:-0}
  [[ $n =~ ^-?[0-9]+$ ]] || { echo "0"; return; }
  if   (( n >= 1000000 )); then printf "%d.%01dm" $(( n / 1000000 )) $(( (n % 1000000) / 100000 ))
  elif (( n >= 1000    )); then printf "%d.%01dk" $(( n / 1000 ))    $(( (n % 1000) / 100 ))
  else echo "$n"
  fi
}

# ── path ─────────────────────────────────────────────────────────────────────
short_cwd="${cwd/#$HOME/~}"
# Truncate long paths to …/last/two/components
if [ "${#short_cwd}" -gt 40 ]; then
  parent=${short_cwd%/*}
  short_cwd="…/${parent##*/}/${short_cwd##*/}"
fi

# ── git ──────────────────────────────────────────────────────────────────────
git_part=""
# Fast pre-check: skip git entirely if no .git entry exists at cwd root (avoids ~40ms git spawn)
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)
  dirty=0
  git -C "$cwd" -c core.fsmonitor=false diff-index --quiet HEAD -- 2>/dev/null || dirty=1
  if [ "$dirty" -eq 0 ]; then
    git_part="🌿 \033[0;32m(${branch})\033[0m ✅"
  else
    git_part="🌿 \033[0;33m(${branch})\033[0m ⚠️"
  fi
fi

# ── account usage (5h / 7d) via Anthropic OAuth API ─────────────────────────
usage_json=""
cache_file="/tmp/.claude_usage_cache"
reset_times_file="/tmp/.claude_reset_times"
now=$(date +%s)

cache_age=999999
[ -f "$cache_file" ] && cache_age=$(( now - $(stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
if [ "$cache_age" -lt 300 ]; then
  usage_json=$(cat "$cache_file")
else
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
          | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
  if [ -n "$token" ]; then
    usage_json=$(curl -s --max-time 3 \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -H "anthropic-beta: oauth-2025-04-20" \
      "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
    if echo "$usage_json" | jq -e '.five_hour' > /dev/null 2>&1; then
      echo "$usage_json" > "$cache_file"
      # Persist reset timestamps as epoch integers so per-tick reads are pure bash
      fresh_fh_reset=$(echo "$usage_json" | jq -r '.five_hour.resets_at // empty')
      fresh_wd_reset=$(echo "$usage_json" | jq -r '.seven_day.resets_at  // empty')
      read -r fresh_fh_epoch fresh_wd_epoch <<EOF
$(python3 -c "
import datetime, sys
for s in sys.argv[1:]:
    try: print(int(datetime.datetime.fromisoformat(s).timestamp()), end=' ')
    except: print(0, end=' ')
print()
" "$fresh_fh_reset" "$fresh_wd_reset" 2>/dev/null)
EOF
      printf '%s\n%s\n' "$fresh_fh_epoch" "$fresh_wd_epoch" > "$reset_times_file"
    fi
  fi
fi

# Read persisted reset epoch integers (written on every fresh API fetch, survive the 5-min cache window)
stored_fh_epoch=""
stored_wd_epoch=""
if [ -f "$reset_times_file" ]; then
  { read -r stored_fh_epoch; read -r stored_wd_epoch; } < "$reset_times_file"
fi

fh_diff=""
wd_diff=""
if [ -n "$stored_fh_epoch" ] && [ "$stored_fh_epoch" -gt 0 ] 2>/dev/null; then
  if [ "$stored_fh_epoch" -le "$now" ]; then
    # Window has rolled — invalidate caches so the next tick forces a fresh API fetch
    rm -f "$reset_times_file" "$cache_file"
    stored_fh_epoch=""
    stored_wd_epoch=""
  else
    fh_diff=$(( stored_fh_epoch - now ))
    [ -n "$stored_wd_epoch" ] && wd_diff=$(( stored_wd_epoch - now ))
  fi
fi

# ── worktree ──────────────────────────────────────────────────────────────────
worktree_part=""
if [ -n "$worktree_name" ]; then
  if [ -n "$worktree_branch" ]; then
    worktree_part="🔀 \033[0;35m${worktree_name}\033[0m \033[2;37m(${worktree_branch})\033[0m"
  else
    worktree_part="🔀 \033[0;35m${worktree_name}\033[0m"
  fi
fi

# ── assemble line 1: location ─────────────────────────────────────────────────
sep=" \033[2;37m|\033[0m "

line1="📁 \033[1m${short_cwd}\033[0m"
[ -n "$git_part"      ] && line1="${line1}  ${git_part}"
[ -n "$worktree_part" ] && line1="${line1}${sep}${worktree_part}"
if [ -n "$session_name" ]; then
  if [ "${#session_name}" -gt 28 ]; then
    session_name="${session_name:0:28}…"
  fi
  line1="${line1}${sep}🎨 \033[0;35m${session_name}\033[0m"
fi
if [ -n "$model" ]; then
  model_lower=$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]')
  case $model_lower in
    *opus*)   model_color='\033[0;35m' ;;
    *sonnet*) model_color='\033[0;34m' ;;
    *haiku*)  model_color='\033[0;32m' ;;
    *)        model_color='\033[0;36m' ;;
  esac
  line1="🤖 ${model_color}${model}\033[0m${sep}${line1}"
fi

# ── assemble line 2: usage ───────────────────────────────────────────────────
line2=""

# context window + inline token counts
if [ -n "$used_pct" ]; then
  bar=$(make_bar "$used_int" 8 "cyan")

  # Calculate used and remaining tokens using ctx_size and the corrected used_pct fraction
  if [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ] 2>/dev/null; then
    used_tokens=$(( ctx_size * used_int / 100 ))
    used_fmt=$(fmt_tokens "$used_tokens")
    ctx_fmt=$(fmt_tokens "$ctx_size")
    ctx_part="🧠 ${bar} \033[0;36m${used_fmt}/${ctx_fmt}\033[0m"
  else
    ctx_part="🧠 ${bar} \033[0;36m${used_int}%\033[0m"
  fi

  # Append per-turn token counts inline
  if [ -n "$turn_in" ] && [ "$turn_in" -gt 0 ] 2>/dev/null; then
    tin_fmt=$(fmt_tokens "$turn_in")
    tout_fmt=$(fmt_tokens "$turn_out")
    ctx_part="${ctx_part} \033[2;37m(\033[0m\033[2;37m↑\033[0m\033[37m${tin_fmt}\033[0m \033[2;37m↓\033[0m\033[37m${tout_fmt}\033[2;37m)\033[0m"
  fi

  line2="${ctx_part}"

  # Cache hit indicator
  if [ -n "$cache_read" ] && [ "$cache_read" -gt 0 ] 2>/dev/null; then
    cache_create_val=${cache_create:-0}
    [ "$cache_create_val" = "null" ] && cache_create_val=0
    denom=$(( cache_read + cache_create_val ))
    if [ "$denom" -gt 0 ]; then
      hit_pct=$(( cache_read * 100 / denom ))
      line2="${line2} \033[0;33m⚡ ${hit_pct}%\033[0m"
    fi
  fi
fi

# 5h and 7d account usage
if [ -n "$usage_json" ]; then
  read -r fh_pct wd_pct <<EOF
$(printf '%s' "$usage_json" | jq -r '"\(.five_hour.utilization // "") \(.seven_day.utilization // "")"' 2>/dev/null)
EOF

  if [ -n "$fh_pct" ]; then
    fh_int=${fh_pct%.*}
    col=$(pct_color "$fh_int")
    bar=$(make_bar "$fh_int" 8)
    remaining=$([ -n "$fh_diff" ] && fmt_countdown "$fh_diff" || echo "?")
    fh_part="${bar} ${col}${fh_int}%\033[0m \033[2;37m(${remaining})\033[0m"
    line2="${line2}${sep}5H ${fh_part}"
  fi

  if [ -n "$wd_pct" ]; then
    wd_int=${wd_pct%.*}
    col=$(pct_color "$wd_int")
    bar=$(make_bar "$wd_int" 8)
    countdown=$([ -n "$wd_diff" ] && fmt_countdown "$wd_diff" || echo "?")
    wd_part="${bar} ${col}${wd_int}%\033[0m \033[2;37m(${countdown})\033[0m"
    line2="${line2}${sep}7D ${wd_part}"
  fi
fi

printf "%b\n" "${line1}"
[ -n "$line2" ] && printf "%b\n" "${line2}"
