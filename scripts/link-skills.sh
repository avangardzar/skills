#!/usr/bin/env bash
set -euo pipefail

# NOTE: This is a dev-only script, intended for use by maintainers of this repo.
# It is not a supported installer.
#
# Links the skills the plugin does not ship into the local skill directories
# used by each agent harness:
#   - ~/.claude/skills: Claude Code (override with SKILLS_CLAUDE_DIR)
#   - ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
#     (override with SKILLS_AGENTS_DIR)
# Each entry is a symlink into this repo, so a `git pull` is all that's needed
# to keep linked skills up to date.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DEST="${SKILLS_CLAUDE_DIR:-$HOME/.claude/skills}"
AGENTS_DEST="${SKILLS_AGENTS_DIR:-$HOME/.agents/skills}"
DESTS=("$CLAUDE_DEST" "$AGENTS_DEST")

# Collect the repo's skills once, link into every destination. The promoted
# buckets (`engineering/`, `productivity/`) are not linked: the zar-skills
# plugin ships them, and a linked copy would show up as an unprefixed duplicate
# next to `/zar-skills:...`. `deprecated/` is retired, and `misc/` is kept
# around but rarely used and not promoted (see each bucket's own README):
# neither belongs in a daily-driver skill directory. `in-progress/` IS still
# linked: it's public on purpose, feedback wanted, not in the plugin, and this
# local install is exactly where that feedback loop runs.
names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' \
  -not -path "$REPO/skills/engineering/*" -not -path "$REPO/skills/productivity/*" \
  -not -path "$REPO/skills/deprecated/*" -not -path "$REPO/skills/misc/*" -print0)

promoted=()
while IFS= read -r -d '' skill_md; do
  promoted+=("$(basename "$(dirname "$skill_md")")")
done < <(find "$REPO/skills/engineering" "$REPO/skills/productivity" -name SKILL.md -not -path '*/node_modules/*' -print0)

for DEST in "${DESTS[@]}"; do
  # If $DEST is a symlink that resolves into this repo, we'd end up writing the
  # per-skill symlinks back into the repo's own skills/ tree. Detect and bail
  # out instead of polluting the working copy.
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  # Clear out every link an earlier run left that this run would not make: a
  # promoted skill (the plugin's duplicate), a skill since renamed, moved to
  # another bucket, or deleted (a dangling link), and links from any other
  # clone of the repo. A link is ours when it points at skills/<bucket>/<name>.
  for target in "$DEST"/*; do
    [ -L "$target" ] || continue
    name="$(basename "$target")"
    link="$(readlink "$target")"
    case "$link" in
      */skills/engineering/"$name"|*/skills/productivity/"$name"|*/skills/in-progress/"$name"|*/skills/misc/"$name"|*/skills/deprecated/"$name") ;;
      *) continue ;;
    esac
    wanted=false
    for src in ${srcs[@]+"${srcs[@]}"}; do
      if [ "$link" = "$src" ]; then wanted=true; break; fi
    done
    if [ "$wanted" = false ]; then
      rm "$target"
      echo "removed stale link $name -> $link ($DEST)"
    fi
  done

  # Anything left under a promoted name is not ours to delete, but it hides
  # or duplicates the plugin's skill, so say so.
  for name in ${promoted[@]+"${promoted[@]}"}; do
    target="$DEST/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
      echo "warning: $target duplicates the plugin's $name and was left alone." >&2
    fi
  done

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $src ($DEST)"
  done
done
