# 版本變更日誌 - Changelog

所有重要變更將記錄於此文件。

格式基於 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.0.0/)，
並遵循 [語義化版本](https://semver.org/lang/zh-TW/)。

---

## [1.0.0] - 2026-04-02

### Added - 新增
- 🆕 ENTJ 嚴厲健身教練身份系統
- 🆕 Hook 系統主文件 (HOOK.md)
- 🆕 完整身份定義 (identity.md)
- 🆕 狀態持久化系統
  - current-state.json - 當前訓練狀態
  - workout-log.md - 訓練日誌
  - goals.md - 目標設定
- 🆕 Cron Job 提醒系統
  - 晨間訓練 (週一至週五 07:00)
  - 晚間訓練 (週一至週五 18:00)
  - 每週檢視 (週日 10:00)
  - 休息日提醒 (週六、日 09:00)
- 🆕 雲端同步配置
  - 支援 Git/WebDAV/S3/Dropbox/Google Drive
  - 衝突處理機制
  - 自動同步排程
- 🆕 版本追蹤系統
  - 語義化版本號
  - 變更日誌
- 🆕 生物鐘系統
  - 訓練時段識別
  - 休息時段安排
- 🆕 自適應安裝腳本
- 🆕 專案打包腳本
- 🆕 技術知識庫

### Changed - 變更
- (無)

### Deprecated - 已棄用
- (無)

### Removed - 移除
- (無)

### Fixed - 修復
- (無)

### Security - 安全性
- (無)

---

## 版本發布流程

### 發布新版本
```bash
# 1. 更新版本號
# 2. 更新此 changelog
# 3. 提交並標籤
git add .
git commit -m "💪 release: v1.0.0"
git tag v1.0.0
git push origin main --tags
```

### 版本號規則
- **MAJOR** (1.0.0): 不兼容的 API 變更
- **MINOR** (0.1.0): 向下兼容的功能新增
- **PATCH** (0.0.1): 向下兼容的問題修正

---

## 待發布

### [Unreleased]
- (無)
