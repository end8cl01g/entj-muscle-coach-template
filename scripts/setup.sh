#!/bin/bash
# ENTJ 健身教練 Hook 系統 - 自適應安裝腳本
# 自動檢測環境並安裝必要依賴

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# 日誌函數
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_motivation() {
    echo -e "${MAGENTA}💪${NC} $1"
}

# 檢測操作系統
detect_os() {
    log_info "檢測操作系統..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        log_info "檢測到 Linux 系統"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "檢測到 macOS 系統"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
        log_info "檢測到 Windows 系統"
    else
        OS="unknown"
        log_warning "未知操作系統：$OSTYPE"
    fi
    
    echo "$OS"
}

# 檢測包管理器
detect_package_manager() {
    log_info "檢測包管理器..."
    
    if command -v apt-get &> /dev/null; then
        PM="apt"
        log_info "使用 apt 包管理器"
    elif command -v yum &> /dev/null; then
        PM="yum"
        log_info "使用 yum 包管理器"
    elif command -v brew &> /dev/null; then
        PM="brew"
        log_info "使用 Homebrew 包管理器"
    elif command -v choco &> /dev/null; then
        PM="choco"
        log_info "使用 Chocolatey 包管理器"
    else
        PM="none"
        log_warning "未檢測到包管理器"
    fi
    
    echo "$PM"
}

# 檢測 Node.js
check_node() {
    log_info "檢查 Node.js..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        log_success "Node.js 已安裝：$NODE_VERSION"
        return 0
    else
        log_error "Node.js 未安裝"
        return 1
    fi
}

# 檢測 Git
check_git() {
    log_info "檢查 Git..."
    
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        log_success "Git 已安裝：$GIT_VERSION"
        return 0
    else
        log_warning "Git 未安裝"
        return 1
    fi
}

# 檢測 OpenClaw
check_openclaw() {
    log_info "檢查 OpenClaw..."
    
    if command -v openclaw &> /dev/null; then
        OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
        log_success "OpenClaw 已安裝：$OPENCLAW_VERSION"
        return 0
    else
        log_error "OpenClaw 未安裝或不在 PATH 中"
        return 1
    fi
}

# 安裝依賴
install_dependencies() {
    local os=$1
    local pm=$2
    
    log_info "安裝必要依賴..."
    
    case "$pm" in
        apt)
            sudo apt-get update
            sudo apt-get install -y git curl
            ;;
        yum)
            sudo yum install -y git curl
            ;;
        brew)
            brew install git curl
            ;;
        choco)
            choco install -y git curl
            ;;
        *)
            log_warning "無法自動安裝依賴，請手動安裝 Git 和 curl"
            ;;
    esac
}

# 設置 Hook
setup_hook() {
    log_info "設置 ENTJ 健身教練 Hook..."
    
    HOOKS_DIR="$(dirname "$(dirname "$0")")"
    
    if command -v openclaw &> /dev/null; then
        # 嘗試啟用 Hook
        if openclaw hooks list 2>/dev/null | grep -q "entj-muscle-coach"; then
            log_success "Hook 已安裝"
        else
            log_info "啟用 Hook..."
            openclaw hooks enable entj-muscle-coach 2>/dev/null || {
                log_warning "無法自動啟用 Hook，請手動執行：openclaw hooks enable entj-muscle-coach"
            }
        fi
    else
        log_warning "OpenClaw 未安裝，跳過 Hook 設置"
    fi
}

# 創建必要目錄
create_directories() {
    log_info "創建必要目錄..."
    
    SCRIPT_DIR="$(dirname "$0")"
    
    mkdir -p "$SCRIPT_DIR/state"
    mkdir -p "$SCRIPT_DIR/cron"
    mkdir -p "$SCRIPT_DIR/sync"
    mkdir -p "$SCRIPT_DIR/version"
    mkdir -p "$SCRIPT_DIR/bioclock"
    mkdir -p "$SCRIPT_DIR/config"
    mkdir -p "$SCRIPT_DIR/docs"
    
    log_success "目錄結構已就緒"
}

# 初始化配置文件
init_configs() {
    log_info "初始化配置文件..."
    
    # 檢查必要配置文件是否存在
    SCRIPT_DIR="$(dirname "$0")"
    
    REQUIRED_FILES=(
        "HOOK.md"
        "identity.md"
        "state/current-state.json"
        "cron/reminders.json"
        "sync/sync-config.json"
        "bioclock/rhythm-config.json"
    )
    
    MISSING=0
    for file in "${REQUIRED_FILES[@]}"; do
        if [[ ! -f "$SCRIPT_DIR/$file" ]]; then
            log_warning "缺少文件：$file"
            MISSING=$((MISSING + 1))
        fi
    done
    
    if [[ $MISSING -eq 0 ]]; then
        log_success "所有配置文件已就緒"
    else
        log_warning "有 $MISSING 個文件缺失，可能需要重新安裝"
    fi
}

# 顯示安裝摘要
show_summary() {
    echo ""
    echo "================================"
    echo "  ENTJ 健身教練 Hook 系統安裝完成"
    echo "================================"
    echo ""
    log_success "安裝摘要:"
    echo "  - 操作系統：$OS"
    echo "  - 包管理器：$PM"
    echo "  - Node.js: $(node -v 2>/dev/null || echo '未安裝')"
    echo "  - Git: $(git --version 2>/dev/null || echo '未安裝')"
    echo "  - OpenClaw: $(openclaw --version 2>/dev/null || echo '未安裝')"
    echo ""
    
    if [[ $OS != "unknown" ]] && [[ $PM != "none" ]]; then
        log_success "環境配置良好"
    else
        log_warning "部分環境未配置，可能影響功能"
    fi
    
    echo ""
    log_motivation "教練提醒:"
    echo "  系統已就緒，現在開始你的訓練。"
    echo "  沒有藉口，只有結果。"
    echo ""
    log_info "下一步:"
    echo "  1. 確認 OpenClaw 已正確安裝"
    echo "  2. 執行：openclaw hooks enable entj-muscle-coach"
    echo "  3. 修改 config/project-config.json 以自定義設置"
    echo "  4. 參考 docs/technical-knowledge.md 了解更多"
    echo ""
}

# 主流程
main() {
    echo ""
    echo "================================"
    echo "  ENTJ 健身教練 Hook 系統安裝腳本"
    echo "================================"
    echo ""
    
    log_motivation "準備開始安裝。讓我們高效完成這個任務。"
    echo ""
    
    OS=$(detect_os)
    PM=$(detect_package_manager)
    
    # 檢查必要依賴
    check_node || { log_error "Node.js 是必要依賴，請先安裝"; exit 1; }
    check_git || true
    check_openclaw || true
    
    # 創建目錄
    create_directories
    
    # 初始化配置
    init_configs
    
    # 設置 Hook
    setup_hook
    
    # 顯示摘要
    show_summary
}

# 執行
main "$@"
