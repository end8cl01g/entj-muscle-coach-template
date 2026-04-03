# ENTJ 嚴厲健身教練 Hook 系統

> 💪 用最高效率的方法讓你 achieve muscle up

---

## 快速開始

### 1. 安裝 Hook

```bash
cd ~/.openclaw/workspace/hooks/entj-muscle-coach
./scripts/setup.sh
```

### 2. 啟用 Hook

```bash
openclaw hooks enable entj-muscle-coach
```

### 3. 配置 (可選)

編輯 `config/project-config.json` 自定義設置。

### 4. 驗證

```bash
openclaw hooks list
```

---

## 功能特性

### ✅ 已實現

| 功能 | 說明 | 狀態 |
|------|------|------|
| 身份注入 | 強制所有回應以 ENTJ 嚴厲教練身份思考 | ✅ |
| 狀態持久化 | 自動保存訓練進度、目標、數據 | ✅ |
| Cron Job 提醒 | 晨間/晚間訓練、每週檢視 | ✅ |
| 雲端同步 | 支持 Git/WebDAV/S3/Dropbox/GDrive | ✅ |
| 版本追蹤 | 語義化版本 + Changelog | ✅ |
| 生物鐘系統 | 訓練時段識別、週期化訓練 | ✅ |
| 自適應安裝 | 自動檢測環境並安裝 | ✅ |
| 專案打包 | 一鍵打包整個專案 | ✅ |
| 技術知識庫 | 完整技術文檔 + Muscle Up 訓練知識 | ✅ |

---

## 目錄結構

```
hooks/entj-muscle-coach/
├── HOOK.md                 # Hook 主文件
├── identity.md             # ENTJ 教練身份定義
├── README.md               # 本文件
├── handler.ts              # TypeScript Hook 處理器
├── state/                  # 狀態持久化
│   ├── current-state.json  # 當前狀態
│   ├── workout-log.md      # 訓練日誌
│   └── goals.md            # 目標設定
├── cron/                   # Cron Job
│   └── reminders.json      # 提醒配置
├── sync/                   # 雲端同步
│   └── sync-config.json    # 同步配置
├── version/                # 版本追蹤
│   └── changelog.md        # 變更日誌
├── bioclock/               # 生物鐘
│   └── rhythm-config.json  # 訓練節奏配置
├── scripts/                # 自動化腳本
│   ├── setup.sh            # 安裝腳本
│   ├── sync.sh             # 同步腳本
│   └── package.sh          # 打包腳本
├── config/                 # 配置
│   └── project-config.json # 專案配置
└── docs/                   # 文檔
    └── technical-knowledge.md # 技術知識庫
```

---

## ENTJ 人格特質

| 維度 | 特質 | 健身教練表現 |
|------|------|--------------|
| **E** (外向) | 主導溝通 | 直接指令，不廢話，主動推動 |
| **N** (直覺) | 戰略思維 | 長期規劃，系統化訓練，願景導向 |
| **T** (思考) | 邏輯決策 | 數據驅動，效率優先，客觀分析 |
| **J** (判斷) | 結構執行 | 嚴格紀律，目標導向，結果至上 |

### 核心信條

- ⚡ **效率至上** - 拒絕浪費時間的訓練
- 🎯 **結果導向** - 藉口不會讓你 muscle up，行動才會
- 💪 **嚴格紀律** - 自律給你自由，但自律本身不自由
- 🧠 **戰略規劃** - 沒有計畫的訓練，只是在流汗
- 📢 **直接溝通** - 我不說好聽的話，我說有用的話

---

## 16 週 Muscle Up 計畫

| 階段 | 週期 | 重點 | 目標 |
|------|------|------|------|
| **基礎力量** | 1-4 週 | 拉力、推力基礎 | 引體向上 10+ |
| **爆發力** | 5-8 週 | 高拉、爆發引體 | 胸觸槓 5+ |
| **技術轉換** | 9-12 週 | 過渡動作 | 過渡控制 3 秒 |
| **完整動作** | 13-16 週 | 完整 muscle up | 連續 3 次 |

---

## 使用示例

### 查看當前狀態

```bash
cat state/current-state.json | jq .
```

### 添加自定義提醒

編輯 `cron/reminders.json`，添加：

```json
{
  "id": "custom-workout",
  "name": "自定義訓練",
  "schedule": {
    "type": "cron",
    "expression": "0 19 * * *",
    "description": "每天晚上 7 點"
  },
  "message": "💪 訓練時間到了。沒有藉口，開始執行。",
  "enabled": true
}
```

### 啟用雲端同步

編輯 `sync/sync-config.json`：

```json
{
  "enabled": true,
  "provider": "git",
  "config": {
    "git": {
      "enabled": true,
      "remote": "https://github.com/your/repo.git",
      "branch": "main"
    }
  }
}
```

然後執行：

```bash
./scripts/sync.sh
```

### 打包專案

```bash
./scripts/package.sh
```

輸出：
```
dist/entj-muscle-coach-v1.0.0.tar.gz
dist/entj-muscle-coach-v1.0.0.zip
```

---

## 配置選項

### 項目配置 (`config/project-config.json`)

| 選項 | 類型 | 說明 | 預設 |
|------|------|------|------|
| `workspace.restrictReadWrite` | boolean | 限制讀寫僅在 hooks 目錄內 | true |
| `persistence.enabled` | boolean | 啟用狀態持久化 | true |
| `cron.enabled` | boolean | 啟用 Cron Job | true |
| `sync.enabled` | boolean | 啟用雲端同步 | false |
| `bioclock.enabled` | boolean | 啟用生物鐘系統 | true |

### 生物鐘配置 (`bioclock/rhythm-config.json`)

| 選項 | 類型 | 說明 |
|------|------|------|
| `dailyRhythm.trainingHours` | array | 訓練時段配置 |
| `dailyRhythm.sleep` | object | 睡眠時段配置 |
| `periodization` | object | 週期化訓練配置 |

---

## 腳本說明

### setup.sh

自適應安裝腳本，自動檢測：
- 操作系統 (Linux/macOS/Windows)
- 包管理器 (apt/yum/brew/choco)
- 依賴 (Node.js, Git, OpenClaw)

```bash
./scripts/setup.sh
```

### sync.sh

雲端同步腳本，支持多種提供者：

```bash
./scripts/sync.sh
```

### package.sh

專案打包腳本：

```bash
./scripts/package.sh
```

---

## 故障排除

### Hook 不觸發

```bash
openclaw hooks list
openclaw gateway restart
```

### 狀態不保存

```bash
ls -la state/
jq . state/current-state.json
```

### 同步失敗

```bash
cat sync/sync-config.json | jq .
```

詳細故障排除請參考 [docs/technical-knowledge.md](docs/technical-knowledge.md)

---

## 版本歷史

| 版本 | 日期 | 說明 |
|------|------|------|
| 1.0.0 | 2026-04-02 | 初始發布 |

完整變更日誌請參考 [version/changelog.md](version/changelog.md)

---

## 教練提醒

> 💪 **記住：**
> 
> - 沒有藉口，只有結果
> - Muscle up 不是夢想，是計畫
> - 效率至上，拒絕無效訓練
> - 自律給你自由，但自律本身不自由

---

## 貢獻

歡迎提交 Issue 和 Pull Request！

- GitHub: https://github.com/openclaw/openclaw
- Discord: https://discord.com/invite/clawd
- 文檔：https://docs.openclaw.ai

---

## 許可證

MIT License

---

**版本**: 1.0.0  
**作者**: workspace-hooks  
**最後更新**: 2026-04-02  
**服務宗旨**: 用最高效率的方法讓你 achieve muscle up
