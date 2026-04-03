#!/bin/bash
# ENTJ 健身教練 Hook 系統 - 雲端同步腳本
# 支持 Git/WebDAV/S3/Dropbox/Google Drive

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOKS_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$HOOKS_DIR/sync/sync-config.json"

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_motivation() { echo -e "${MAGENTA}💪${NC} $1"; }

# 讀取配置
read_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        log_error "配置文件不存在：$CONFIG_FILE"
        exit 1
    fi
    
    # 需要 jq 來解析 JSON
    if ! command -v jq &> /dev/null; then
        log_error "需要安裝 jq 來解析 JSON 配置"
        exit 1
    fi
    
    SYNC_ENABLED=$(jq -r '.enabled' "$CONFIG_FILE")
    SYNC_PROVIDER=$(jq -r '.provider' "$CONFIG_FILE")
    
    if [[ "$SYNC_ENABLED" != "true" ]]; then
        log_warning "雲端同步未啟用"
        exit 0
    fi
}

# Git 同步
sync_git() {
    log_info "執行 Git 同步..."
    
    REMOTE=$(jq -r '.config.git.remote' "$CONFIG_FILE")
    BRANCH=$(jq -r '.config.git.branch' "$CONFIG_FILE")
    AUTO_COMMIT=$(jq -r '.config.git.autoCommit' "$CONFIG_FILE")
    
    if [[ -z "$REMOTE" ]] || [[ "$REMOTE" == "null" ]]; then
        log_error "Git remote 未配置"
        exit 1
    fi
    
    cd "$HOOKS_DIR"
    
    # 初始化 Git (如果尚未初始化)
    if [[ ! -d ".git" ]]; then
        git init
        git remote add origin "$REMOTE"
    fi
    
    # 自動提交
    if [[ "$AUTO_COMMIT" == "true" ]]; then
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        git add -A
        if ! git diff --cached --quiet; then
            git commit -m "💪 auto-sync: $TIMESTAMP"
            log_success "已提交變更"
        else
            log_info "沒有需要提交的變更"
        fi
    fi
    
    # 推送
    git push -u origin "$BRANCH"
    log_success "Git 同步完成"
}

# WebDAV 同步
sync_webdav() {
    log_info "執行 WebDAV 同步..."
    
    URL=$(jq -r '.config.webdav.url' "$CONFIG_FILE")
    USERNAME=$(jq -r '.config.webdav.username' "$CONFIG_FILE")
    
    if [[ -z "$URL" ]] || [[ "$URL" == "null" ]]; then
        log_error "WebDAV URL 未配置"
        exit 1
    fi
    
    # 使用 curl 進行 WebDAV 操作
    # 需要實現具體的同步邏輯
    log_warning "WebDAV 同步需要進一步實現"
}

# S3 同步
sync_s3() {
    log_info "執行 S3 同步..."
    
    BUCKET=$(jq -r '.config.s3.bucket' "$CONFIG_FILE")
    REGION=$(jq -r '.config.s3.region' "$CONFIG_FILE")
    
    if [[ -z "$BUCKET" ]] || [[ "$BUCKET" == "null" ]]; then
        log_error "S3 Bucket 未配置"
        exit 1
    fi
    
    if ! command -v aws &> /dev/null; then
        log_error "需要安裝 AWS CLI"
        exit 1
    fi
    
    aws s3 sync "$HOOKS_DIR/" "s3://$BUCKET/entj-muscle-coach/" --region "$REGION"
    log_success "S3 同步完成"
}

# Dropbox 同步
sync_dropbox() {
    log_info "執行 Dropbox 同步..."
    log_warning "Dropbox 同步需要進一步實現"
}

# Google Drive 同步
sync_gdrive() {
    log_info "執行 Google Drive 同步..."
    log_warning "Google Drive 同步需要進一步實現"
}

# 主流程
main() {
    log_motivation "開始雲端同步。效率至上。"
    
    read_config
    
    case "$SYNC_PROVIDER" in
        git)
            sync_git
            ;;
        webdav)
            sync_webdav
            ;;
        s3)
            sync_s3
            ;;
        dropbox)
            sync_dropbox
            ;;
        gdrive)
            sync_gdrive
            ;;
        *)
            log_error "未知的同步提供者：$SYNC_PROVIDER"
            exit 1
            ;;
    esac
    
    # 更新最後同步時間
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq --arg ts "$TIMESTAMP" '.lastSync = $ts' "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    
    log_success "同步完成於 $TIMESTAMP"
}

main "$@"
