#!/bin/bash
set -euo pipefail

# 代码库克隆地址
REPO="git@github.com:sre-elite/website.git"

# 目标目录
TARGET_DIR="/opt/www.sre-elite.com/site"
CLONE_DIR="/root/website"
SOURCE_DIR="$CLONE_DIR/public"
DEPLOY_COMMIT_FILE="$TARGET_DIR/.deploy_commit"
DEPLOY_HISTORY_FILE="$TARGET_DIR/.deploy_history"

log() {
  printf '%s\n' "$*"
}

die() {
  log "ERROR: $*"
  exit 1
}

delete_dir_contents() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    log "WARN: 目录不存在，跳过删除: $dir"
    return 0
  fi
  # 删除目录下所有内容（包含隐藏文件），但保留目录本身
  find "$dir" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  if [ -n "$(ls -A "$dir" 2>/dev/null)" ]; then
    log "ERROR: 删除失败，目录不为空: $dir"
    return 1
  fi
  log "删除成功: $dir"
}

clone_or_update_repo() {
  if [ -d "$CLONE_DIR/.git" ]; then
    log "更新代码库: $CLONE_DIR"
    (cd "$CLONE_DIR" && git pull --ff-only)
    return 0
  fi

  rm -rf "$CLONE_DIR"
  for attempt in 1 2 3; do
    log "克隆代码库 (尝试 $attempt/3): $REPO"
    if git clone "$REPO" "$CLONE_DIR"; then
      return 0
    fi
    log "WARN: git clone 失败"
    sleep 2
  done
  return 1
}

if ! clone_or_update_repo; then
  die "git clone/pull 连续失败，终止部署。"
fi

if [ ! -d "$SOURCE_DIR" ] || [ -z "$(ls -A "$SOURCE_DIR" 2>/dev/null)" ]; then
  die "部署源目录为空或不存在: $SOURCE_DIR"
fi

NEW_COMMIT="$(cd "$CLONE_DIR" && git rev-parse HEAD)"
NEW_COMMIT_TS="$(cd "$CLONE_DIR" && git show -s --format=%ci HEAD)"
OLD_COMMIT=""
if [ -f "$DEPLOY_COMMIT_FILE" ]; then
  OLD_COMMIT="$(cat "$DEPLOY_COMMIT_FILE")"
fi

if [ "$NEW_COMMIT" = "$OLD_COMMIT" ]; then
  TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "$TS $NEW_COMMIT (no-change) commit_ts=$NEW_COMMIT_TS" >> "$DEPLOY_HISTORY_FILE"
  log "代码库无更新，未做部署。当前版本: $NEW_COMMIT (commit_ts=$NEW_COMMIT_TS)"
  exit 0
fi

read -r -p "确认部署到目标目录 $TARGET_DIR ? [y/N] " confirm
if [ "${confirm:-N}" != "y" ] && [ "${confirm:-N}" != "Y" ]; then
  log "已取消部署。"
  exit 0
fi

mkdir -p "$TARGET_DIR"
delete_dir_contents "$TARGET_DIR" || die "目标目录清理失败，终止部署。"

cp -r "$SOURCE_DIR"/* "$TARGET_DIR"
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "$NEW_COMMIT" > "$DEPLOY_COMMIT_FILE"
echo "$TS $NEW_COMMIT (deployed) commit_ts=$NEW_COMMIT_TS" >> "$DEPLOY_HISTORY_FILE"
log "部署完成。当前版本: $NEW_COMMIT (commit_ts=$NEW_COMMIT_TS)"
