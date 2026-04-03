#!/bin/bash
# ENTJ 健身教練 Hook 系統 - 專案打包腳本
# 打包整個專案以便部署或分享

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOKS_DIR="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$HOOKS_DIR/version/changelog.md"
OUTPUT_DIR="${OUTPUT_DIR:-./dist}"

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

# 獲取版本號
get_version() {
    if [[ -f "$VERSION_FILE" ]]; then
        VERSION=$(grep -oP '\[\K[0-9]+\.[0-9]+\.[0-9]+(?=\])' "$VERSION_FILE" | head -1)
        echo "${VERSION:-1.0.0}"
    else
        echo "1.0.0"
    fi
}

# 創建打包清單
create_manifest() {
    local manifest_file="$HOOKS_DIR/MANIFEST.json"
    local version=$1
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    log_info "創建打包清單..."
    
    cat > "$manifest_file" << EOF
{
  "name": "entj-muscle-coach-hooks",
  "version": "$version",
  "description": "ENTJ 嚴厲健身教練 Hook 系統 - 用最高效率的方法讓你 achieve muscle up",
  "author": "workspace-hooks",
  "license": "MIT",
  "homepage": "https://github.com/openclaw/openclaw",
  "repository": {
    "type": "git",
    "url": "https://github.com/openclaw/openclaw.git"
  },
  "keywords": [
    "openclaw",
    "hooks",
    "entj",
    "fitness",
    "muscle-up",
    "workout",
    "trainer"
  ],
  "engines": {
    "node": ">=18.0.0",
    "openclaw": ">=1.0.0"
  },
  "files": [
    "HOOK.md",
    "identity.md",
    "state/",
    "cron/",
    "sync/",
    "version/",
    "bioclock/",
    "scripts/",
    "config/",
    "docs/"
  ],
  "scripts": {
    "setup": "./scripts/setup.sh",
    "sync": "./scripts/sync.sh",
    "package": "./scripts/package.sh"
  },
  "config": {
    "hookName": "entj-muscle-coach",
    "persona": "ENTJ Fitness Coach",
    "timezone": "UTC"
  },
  "buildInfo": {
    "timestamp": "$timestamp",
    "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
    "branch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
  }
}
EOF
    
    log_success "清單已創建：$manifest_file"
}

# 打包專案
create_package() {
    local version=$1
    local package_name="entj-muscle-coach-v${version}"
    local package_dir="$OUTPUT_DIR/$package_name"
    
    log_info "創建打包目錄..."
    mkdir -p "$OUTPUT_DIR"
    rm -rf "$package_dir"
    mkdir -p "$package_dir"
    
    log_info "複製文件..."
    
    # 複製所有必要文件
    cp -r "$HOOKS_DIR"/* "$package_dir/"
    
    # 排除不必要的文件
    cd "$package_dir"
    rm -rf node_modules .git dist .DS_Store
    
    log_success "文件複製完成"
}

# 創建壓縮包
create_archive() {
    local version=$1
    local package_name="entj-muscle-coach-v${version}"
    local archive_name="${package_name}.tar.gz"
    
    log_info "創建壓縮包..."
    
    cd "$OUTPUT_DIR"
    tar -czf "$archive_name" "$package_name"
    
    log_success "壓縮包已創建：$OUTPUT_DIR/$archive_name"
    
    # 計算 checksum
    if command -v shasum &> /dev/null; then
        CHECKSUM=$(shasum -a 256 "$archive_name" | cut -d' ' -f1)
        echo "$CHECKSUM  $archive_name" > "${archive_name}.sha256"
        log_success "SHA256: $CHECKSUM"
    elif command -v sha256sum &> /dev/null; then
        CHECKSUM=$(sha256sum "$archive_name" | cut -d' ' -f1)
        echo "$CHECKSUM  $archive_name" > "${archive_name}.sha256"
        log_success "SHA256: $CHECKSUM"
    fi
}

# 創建 ZIP 包 (可選)
create_zip() {
    local version=$1
    local package_name="entj-muscle-coach-v${version}"
    local zip_name="${package_name}.zip"
    
    if command -v zip &> /dev/null; then
        log_info "創建 ZIP 包..."
        
        cd "$OUTPUT_DIR"
        zip -r "$zip_name" "$package_name"
        
        log_success "ZIP 包已創建：$OUTPUT_DIR/$zip_name"
    else
        log_warning "zip 未安裝，跳過 ZIP 包創建"
    fi
}

# 清理臨時文件
cleanup() {
    local version=$1
    local package_name="entj-muscle-coach-v${version}"
    
    log_info "清理臨時文件..."
    rm -rf "$OUTPUT_DIR/$package_name"
    rm -f "$HOOKS_DIR/MANIFEST.json"
    
    log_success "清理完成"
}

# 顯示打包摘要
show_summary() {
    local version=$1
    
    echo ""
    echo "================================"
    echo "  ENTJ 健身教練 Hook 系統打包完成"
    echo "================================"
    echo ""
    log_success "版本：v$version"
    log_success "輸出目錄：$OUTPUT_DIR"
    echo ""
    log_info "生成的文件:"
    ls -lh "$OUTPUT_DIR"/entj-muscle-coach-v${version}.* 2>/dev/null || true
    echo ""
    log_motivation "教練提醒:"
    echo "  系統已打包，隨時可以部署。"
    echo "  現在開始你的訓練。沒有藉口，只有結果。"
    echo ""
    log_info "部署說明:"
    echo "  1. 解壓縮包到 OpenClaw hooks 目錄"
    echo "  2. 執行：openclaw hooks enable entj-muscle-coach"
    echo "  3. 參考 docs/technical-knowledge.md 了解更多"
    echo ""
}

# 主流程
main() {
    echo ""
    echo "================================"
    echo "  ENTJ 健身教練 Hook 系統打包腳本"
    echo "================================"
    echo ""
    
    log_motivation "開始打包。效率至上。"
    echo ""
    
    VERSION=$(get_version)
    log_info "版本：v$VERSION"
    
    # 創建清單
    create_manifest "$VERSION"
    
    # 創建打包
    create_package "$VERSION"
    
    # 創建壓縮包
    create_archive "$VERSION"
    
    # 創建 ZIP (可選)
    create_zip "$VERSION"
    
    # 清理
    cleanup "$VERSION"
    
    # 顯示摘要
    show_summary "$VERSION"
}

# 執行
main "$@"
