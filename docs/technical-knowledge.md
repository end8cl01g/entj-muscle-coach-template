# 技術知識庫 - Technical Knowledge

> 💪 ENTJ 健身教練 Hook 系統的完整技術文檔

---

## 目錄

1. [Hook 系統原理](#hook-系統原理)
2. [狀態管理機制](#狀態管理機制)
3. [同步協議](#同步協議)
4. [生物鐘系統](#生物鐘系統)
5. [版本追蹤](#版本追蹤)
6. [最佳實踐](#最佳實踐)
7. [故障排除](#故障排除)

---

## Hook 系統原理

### 什麼是 Hook？

Hook 是一種事件驅動的機制，允許在特定事件發生時執行自定義邏輯。

### OpenClaw Hook 架構

```
┌─────────────────────────────────────────────────────┐
│                   OpenClaw Core                     │
├─────────────────────────────────────────────────────┤
│                  Event Dispatcher                   │
├──────────────┬──────────────┬───────────────────────┤
│ agent:       │ message:     │ gateway:              │
│  bootstrap   │  received    │  startup              │
│  new         │  sent        │  shutdown             │
│  reset       │  transcribed │                       │
│  stop        │  preprocessed│                       │
└──────────────┴──────────────┴───────────────────────┘
         │              │              │
         ▼              ▼              ▼
   ┌─────────────────────────────────────────┐
   │         Hook Handlers (你的代碼)         │
   └─────────────────────────────────────────┘
```

### Hook 註冊流程

1. **定義 Hook** - 在 `HOOK.md` 中定義元數據
2. **註冊事件** - 指定監聽的事件類型
3. **實現處理** - 编写事件處理邏輯
4. **啟用 Hook** - 使用 `openclaw hooks enable` 啟用

### Hook 元數據格式

```yaml
---
name: entj-muscle-coach
description: "ENTJ 嚴厲健身教練人格注入"
metadata:
  openclaw:
    emoji: "💪"
    events: ["agent:bootstrap", "message:received"]
    persona: "entj-muscle-coach"
  version: "1.0.0"
---
```

---

## 狀態管理機制

### 狀態結構

```json
{
  "version": "1.0.0",
  "persona": "entj-muscle-coach",
  "lastActive": "2026-04-02T23:10:00Z",
  "userProfile": { ... },
  "milestones": { ... },
  "currentPhase": { ... }
}
```

### 狀態持久化策略

| 策略 | 說明 | 適用場景 |
|------|------|----------|
| 即時保存 | 每次變更立即寫入 | 關鍵狀態 |
| 延遲保存 | 變更後延遲 N 秒寫入 | 頻繁變更的狀態 |
| 定期保存 | 每隔 N 秒自動保存 | 會話狀態 |
| 事件驅動 | 特定事件觸發保存 | 會話結束時 |

### 狀態版本控制

```
state/
├── current-state.json      # 當前狀態
├── current-state.json.bak  # 備份
└── history/
    ├── 2026-04-02.json
    └── 2026-04-01.json
```

### 狀態同步衝突處理

```javascript
// 衝突解決策略
const strategies = {
  newest: '使用最新時間戳的版本',
  oldest: '使用最早時間戳的版本',
  manual: '要求用戶手動選擇',
  merge: '嘗試合併兩個版本'
};
```

---

## 同步協議

### 支持的同步提供者

| 提供者 | 協議 | 認證方式 | 適用場景 |
|--------|------|----------|----------|
| Git | HTTPS/SSH | Token/Key | 版本控制、代碼托管 |
| WebDAV | HTTP(S) | Basic Auth | 私有雲、Nextcloud |
| S3 | REST API | AWS SigV4 | AWS S3、MinIO |
| Dropbox | REST API | OAuth2 | 個人雲存儲 |
| Google Drive | REST API | OAuth2 | Google 生態 |

### 同步流程

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  本地    │────▶│  檢測    │────▶│  上傳    │
│  變更    │     │  衝突    │     │  新版本  │
└──────────┘     └──────────┘     └──────────┘
                      │
                      ▼
                 ┌──────────┐
                 │  衝突？  │
                 └──────────┘
                      │
           ┌──────────┴──────────┐
           │                     │
          是                    否
           │                     │
           ▼                     ▼
     ┌──────────┐          ┌──────────┐
     │  解決    │          │  完成    │
     │  衝突    │          │  同步    │
     └──────────┘          └──────────┘
```

### 離線同步

1. 本地變更記錄到隊列
2. 網絡恢復時重放隊列
3. 處理可能的衝突

---

## 生物鐘系統

### 訓練時段配置

```json
{
  "trainingHours": ["06:00-08:00", "17:00-20:00"],
  "restHours": ["12:00-14:00"],
  "sleepHours": ["22:00-06:00"]
}
```

### 週期化訓練

| 階段 | 週期 | 重點 | 指標 |
|------|------|------|------|
| **基礎力量** | 1-4 週 | 拉力、推力基礎 | 引體向上 10+ |
| **爆發力** | 5-8 週 | 高拉、爆發引體 | 胸觸槓 5+ |
| **技術轉換** | 9-12 週 | 過渡動作 | 過渡控制 3 秒 |
| **完整動作** | 13-16 週 | 完整 muscle up | 連續 3 次 |

### 週期化原則

1. **漸進式超負荷** - 每週都要比上週強
2. **複合動作優先** - 引體、雙槓、推舉
3. **質量 > 數量** - 標準動作勝過 cheating
4. **恢復即訓練** - 睡眠、營養、主動恢復

---

## 版本追蹤

### 語義化版本 (SemVer)

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ 向下兼容的問題修正
  │     └─────── 向下兼容的功能新增
  └───────────── 不兼容的 API 變更
```

### 版本發布流程

```bash
# 1. 更新版本號
# 2. 更新 changelog
# 3. 提交並標籤
git add .
git commit -m "💪 release: v1.0.0"
git tag v1.0.0
git push origin main --tags

# 4. 打包發布
./scripts/package.sh
```

### Changelog 格式

```markdown
## [1.0.0] - 2026-04-02

### Added
- 新功能描述

### Changed
- 變更描述

### Fixed
- 修復描述
```

---

## 最佳實踐

### Hook 開發

✅ **應該做的：**
- 保持 Hook 輕量，避免阻塞主流程
- 提供清晰的錯誤信息
- 記錄 Hook 執行日誌
- 處理異常情況

❌ **不應該做的：**
- 在 Hook 中執行耗時操作
- 忽略錯誤處理
- 修改核心狀態而不通知
- 假設環境總是可用

### 狀態管理

✅ **應該做的：**
- 使用原子操作更新狀態
- 定期清理舊狀態
- 備份重要狀態
- 驗證狀態完整性

❌ **不應該做的：**
- 直接修改共享狀態
- 無限制增長狀態文件
- 忽略狀態同步衝突
- 存儲敏感信息明文

### 同步策略

✅ **應該做的：**
- 先檢測再同步
- 處理網絡失敗
- 提供衝突解決選項
- 記錄同步歷史

❌ **不應該做的：**
- 盲目覆蓋遠程數據
- 忽略同步錯誤
- 同步大文件不壓縮
- 暴露認證信息

---

## 故障排除

### 常見問題

#### Hook 不觸發

```bash
# 檢查 Hook 是否啟用
openclaw hooks list

# 檢查 Hook 文件是否存在
ls -la hooks/entj-muscle-coach/HOOK.md

# 重啟 Gateway
openclaw gateway restart
```

#### 狀態不保存

```bash
# 檢查寫入權限
ls -la hooks/entj-muscle-coach/state/

# 檢查 JSON 格式
jq . hooks/entj-muscle-coach/state/current-state.json

# 查看日誌
tail -f ~/.openclaw/logs/gateway.log
```

#### 同步失敗

```bash
# 檢查配置
cat hooks/entj-muscle-coach/sync/sync-config.json

# 測試連接
# Git: git ls-remote <remote>
# WebDAV: curl -I <url>
# S3: aws s3 ls s3://<bucket>

# 查看同步日誌
cat hooks/entj-muscle-coach/sync/sync.log
```

### 日誌位置

| 組件 | 日誌位置 |
|------|----------|
| Gateway | `~/.openclaw/logs/gateway.log` |
| Hook 執行 | `hooks/entj-muscle-coach/state/hook-exec.log` |
| 同步 | `hooks/entj-muscle-coach/sync/sync.log` |

### 調試模式

啟用調試模式獲取更多詳細信息：

```bash
export OPENCLAW_DEBUG=hooks:*
openclaw gateway restart
```

---

## Muscle Up 訓練知識

### 肌肉上槓 (Muscle Up) 動作要領

#### 準備動作
1. 抓握寬度：略寬於肩
2. 身體角度：微傾後仰
3. 核心張緊：保持身體剛性

#### 動作階段
1. **爆發下拉** - 快速、有力
2. **轉換** - 槓在胸前的瞬間翻腕
3. **推舉** - 將身體推過槓

#### 常見錯誤
- ❌ 只用手臂力量
- ❌ 轉換時機錯誤
- ❌ 核心鬆散
- ❌ 過度依賴 momentum

#### 訓練建議
- 從負重引體開始
- 練習高拉 (chest-to-bar)
- 使用彈力帶輔助
- 分解動作練習

---

## 附錄

### 相關資源

- [OpenClaw 文檔](https://docs.openclaw.ai)
- [Hook 系統規範](/app/docs/hooks.md)
- [語義化版本](https://semver.org/lang/zh-TW/)
- [MBTI 人格類型](https://www.16personalities.com/ch/entj-人格)

### 聯繫支持

- GitHub Issues: https://github.com/openclaw/openclaw/issues
- Discord: https://discord.com/invite/clawd
- 文檔: https://docs.openclaw.ai

---

**文檔版本**: 1.0.0  
**最後更新**: 2026-04-02  
**維護者**: ENTJ Muscle Coach System
