/**
 * ENTJ 嚴厲健身教練 Hook Handler
 * 
 * 實現 ENTJ 人格特質的嚴厲健身教練身份注入系統
 * 所有回應強制以 ENTJ active 嚴厲健身教練身份思考與回應
 * 目標：用最高效率的方法讓你 achieve muscle up
 * 
 * @module entj-muscle-coach/handler
 * @version 1.0.0
 */

import type {
  InternalHookEvent,
  InternalHookHandler,
  AgentBootstrapHookContext,
  MessageReceivedHookContext,
  MessageSentHookContext,
  MessagePreprocessedHookContext,
} from "../plugin-sdk/hooks/internal-hooks.js";

import { registerInternalHook, triggerInternalHook } from "../plugin-sdk/hooks/internal-hooks.js";
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

// ============================================================================
// 類型定義
// ============================================================================

/**
 * ENTJ 教練狀態接口
 */
interface ENTJCoachState {
  version: string;
  persona: string;
  initialized: string;
  lastActive: string | null;
  sessionCount: number;
  workoutsCompleted: number;
  workoutsPending: number;
  userProfile: UserProfile;
  milestones: Milestones;
  currentPhase: TrainingPhase;
  lastSync: string | null;
  syncEnabled: boolean;
  bioClock: BioClockConfig;
  notes: string[];
}

/**
 * 用戶資料
 */
interface UserProfile {
  name: string | null;
  timezone: string;
  fitnessLevel: string;
  currentGoals: string[];
  maxPullUps: number | null;
  maxDips: number | null;
  bodyWeight: number | null;
  trainingDaysPerWeek: number;
  availableEquipment: string[];
}

/**
 * 里程碑
 */
interface Milestones {
  pullUps: { current: number; target: number; unit: string };
  dips: { current: number; target: number; unit: string };
  highPulls: { current: number; target: number; unit: string };
  muscleUp: { current: number; target: number; unit: string };
}

/**
 * 訓練階段
 */
interface TrainingPhase {
  name: string;
  week: number;
  startDate: string | null;
  endDate: string | null;
}

/**
 * 生物鐘配置
 */
interface BioClockConfig {
  trainingHours: string[];
  restHours: string[];
  sleepHours: string[];
}

/**
 * Hook 配置
 */
interface HookConfig {
  version: string;
  persona: {
    type: string;
    role: string;
    traits: {
      extraverted: boolean;
      intuitive: boolean;
      thinking: boolean;
      judging: boolean;
    };
    capabilities: string[];
  };
  workspace: {
    basePath: string;
    restrictReadWrite: boolean;
    allowedDirectories: string[];
  };
  persistence: {
    enabled: boolean;
    format: string;
    autoSave: boolean;
    saveInterval: number;
  };
  cron: {
    enabled: boolean;
    timezone: string;
    defaultReminders: string[];
  };
  bioclock: {
    enabled: boolean;
    timezone: string;
    trainingHours: string[];
    sleepHours: string[];
    trainingReminders: boolean;
  };
}

// ============================================================================
// 常數定義
// ============================================================================

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Hook 基礎路徑
const HOOKS_BASE_PATH = join(__dirname, "..", "..", "workspace", "hooks", "entj-muscle-coach");

// ENTJ 人格特質常量
const ENTJ_TRAITS = {
  extraverted: {
    name: "外向 (Extraverted)",
    description: "從主導溝通和推動他人中獲得能量",
    behaviors: [
      "直接下達指令，不拐彎抹角",
      "主動推動用戶行動",
      "喜歡明確的對話和反饋",
      "主導訓練節奏",
    ],
  },
  intuitive: {
    name: "直覺 (Intuitive)",
    description: "關注整體戰略和長期願景",
    behaviors: [
      "制定系統化訓練計畫",
      "關注長期進步而非單次表現",
      "善於識別模式和趨勢",
      "願景導向：看到最終的 muscle up",
    ],
  },
  thinking: {
    name: "思考 (Thinking)",
    description: "做決定時基於邏輯和數據",
    behaviors: [
      "數據驅動：次數、組數、重量、進步曲線",
      "效率優先：拒絕無效訓練",
      "客觀分析，不情緒化",
      "用科學方法優化訓練",
    ],
  },
  judging: {
    name: "判斷 (Judging)",
    description: "偏好結構化、有計劃的執行",
    behaviors: [
      "嚴格紀律：訓練時間不妥協",
      "目標導向：每個動作都有目的",
      "結果至上：進步是唯一標準",
      "結構化反饋：明確的 do's and don'ts",
    ],
  },
} as const;

// 健身教練核心信條
const COACH_MOTTOS = [
  { id: "efficiency", motto: "效率至上", emoji: "⚡" },
  { id: "results", motto: "結果導向", emoji: "🎯" },
  { id: "discipline", motto: "嚴格紀律", emoji: "💪" },
  { id: "strategy", motto: "戰略規劃", emoji: "🧠" },
  { id: "direct", motto: "直接溝通", emoji: "📢" },
] as const;

// 教練口頭禪
const COACH_PHRASES = {
  motivation: [
    "沒有藉口，只有結果。",
    "Muscle up 不是夢想，是計畫。",
    "效率至上，拒絕無效訓練。",
    "自律給你自由，但自律本身不自由。",
    "我不說好聽的話，我說有用的話。",
  ],
  push: [
    "再一個，標準做。",
    "休息結束，繼續。",
    "這不是你的極限，你在撒謊。",
    "告訴我你的 12 週計畫。",
    "這個動作的 ROI 是什麼？",
  ],
  approval: [
    "好。很好。",
    "這就是我要的。",
    "進步了，但不夠。繼續。",
    "驕傲可以，自滿不行。",
  ],
} as const;

// ============================================================================
// 狀態管理
// ============================================================================

/**
 * 獲取狀態文件路徑
 */
function getStatePath(): string {
  return join(HOOKS_BASE_PATH, "state", "current-state.json");
}

/**
 * 獲取配置檔案路徑
 */
function getConfigPath(): string {
  return join(HOOKS_BASE_PATH, "config", "project-config.json");
}

/**
 * 確保目錄存在
 */
function ensureDirectoryExists(dirPath: string): void {
  if (!existsSync(dirPath)) {
    mkdirSync(dirPath, { recursive: true });
  }
}

/**
 * 讀取狀態
 */
function readState(): ENTJCoachState | null {
  const statePath = getStatePath();
  if (!existsSync(statePath)) {
    return null;
  }
  try {
    const content = readFileSync(statePath, "utf-8");
    return JSON.parse(content) as ENTJCoachState;
  } catch (error) {
    console.error("[ENTJ Hook] 讀取狀態失敗:", error);
    return null;
  }
}

/**
 * 寫入狀態
 */
function writeState(state: ENTJCoachState): boolean {
  try {
    const statePath = getStatePath();
    ensureDirectoryExists(dirname(statePath));
    state.lastActive = new Date().toISOString();
    writeFileSync(statePath, JSON.stringify(state, null, 2), "utf-8");
    return true;
  } catch (error) {
    console.error("[ENTJ Hook] 寫入狀態失敗:", error);
    return false;
  }
}

/**
 * 讀取配置
 */
function readConfig(): HookConfig | null {
  const configPath = getConfigPath();
  if (!existsSync(configPath)) {
    return null;
  }
  try {
    const content = readFileSync(configPath, "utf-8");
    return JSON.parse(content) as HookConfig;
  } catch (error) {
    console.error("[ENTJ Hook] 讀取配置失敗:", error);
    return null;
  }
}

/**
 * 初始化預設狀態
 */
function createDefaultState(): ENTJCoachState {
  return {
    version: "1.0.0",
    persona: "entj-muscle-coach",
    initialized: new Date().toISOString(),
    lastActive: null,
    sessionCount: 0,
    workoutsCompleted: 0,
    workoutsPending: 0,
    userProfile: {
      name: null,
      timezone: "UTC",
      fitnessLevel: "unknown",
      currentGoals: ["muscle-up"],
      maxPullUps: null,
      maxDips: null,
      bodyWeight: null,
      trainingDaysPerWeek: 4,
      availableEquipment: ["pullup-bar", "parallel-bars"],
    },
    milestones: {
      pullUps: { current: 0, target: 10, unit: "reps" },
      dips: { current: 0, target: 15, unit: "reps" },
      highPulls: { current: 0, target: 5, unit: "reps" },
      muscleUp: { current: 0, target: 1, unit: "reps" },
    },
    currentPhase: {
      name: "assessment",
      week: 0,
      startDate: null,
      endDate: null,
    },
    lastSync: null,
    syncEnabled: false,
    bioClock: {
      trainingHours: ["06:00-08:00", "17:00-20:00"],
      restHours: ["12:00-14:00"],
      sleepHours: ["22:00-06:00"],
    },
    notes: [],
  };
}

/**
 * 獲取或創建狀態
 */
function getOrCreateState(): ENTJCoachState {
  let state = readState();
  if (!state) {
    state = createDefaultState();
    writeState(state);
  }
  return state;
}

// ============================================================================
// ENTJ 身份注入
// ============================================================================

/**
 * 生成 ENTJ 教練身份注入提示
 */
function generateIdentityInjection(): string {
  const state = getOrCreateState();

  return `
💪 **ENTJ 嚴厲健身教練模式已啟動**

**身份確認：**
- 人格類型：ENTJ-A (指揮官型)
- 職業角色：嚴厲健身教練 / 肌力與體能教練
- 服務宗旨：用最高效率的方法讓你 achieve muscle up

**核心信條：**
| 信條 | 表現 |
|------|------|
| ⚡ 效率至上 | 拒絕浪費時間的訓練 |
| 🎯 結果導向 | 藉口不會讓你 muscle up，行動才會 |
| 💪 嚴格紀律 | 自律給你自由，但自律本身不自由 |
| 🧠 戰略規劃 | 沒有計畫的訓練，只是在流汗 |
| 📢 直接溝通 | 我不說好聽的話，我說有用的話 |

**訓練哲學：**
- 數據驅動：次數、組數、重量、進步曲線
- 效率優先：複合動作 > 孤立動作
- 漸進超負荷：每週都要比上週強
- 恢復即訓練：睡眠、營養、主動恢復

**16 週 Muscle Up 計畫：**
1. 基礎力量 (週 1-4)：引體向上 10+
2. 爆發力 (週 5-8)：高拉 5+
3. 技術轉換 (週 9-12)：過渡控制
4. 完整動作 (週 13-16)：Muscle up 達成

---
*沒有藉口，只有結果。告訴我你的目標，我們開始執行。*
`.trim();
}

/**
 * 生成 ENTJ 風格的回應前綴
 */
function generateResponsePrefix(context: string): string {
  const state = getOrCreateState();

  // 根據生物鐘調整語氣
  const currentHour = new Date().getHours();
  let timeGreeting = "";

  if (currentHour >= 5 && currentHour < 12) {
    timeGreeting = "🌅";
  } else if (currentHour >= 12 && currentHour < 18) {
    timeGreeting = "☀️";
  } else {
    timeGreeting = "🌙";
  }

  // 隨機選擇一個教練口號
  const motto = COACH_MOTTOS[Math.floor(Math.random() * COACH_MOTTOS.length)];

  return `${timeGreeting} ${motto.emoji} **${motto.motto}**`;
}

// ============================================================================
// Hook 處理器
// ============================================================================

/**
 * Agent Bootstrap Hook 處理器
 *
 * 在代理啟動時注入 ENTJ 教練身份
 */
async function handleAgentBootstrap(event: InternalHookEvent): Promise<void> {
  console.log("[ENTJ Hook] Agent Bootstrap 觸發");

  const context = event.context as AgentBootstrapHookContext;
  const state = getOrCreateState();

  // 更新會話計數
  state.sessionCount += 1;
  writeState(state);

  // 注入身份提示到 bootstrap 文件
  const identityInjection = generateIdentityInjection();

  // 將身份注入到消息隊列
  if (event.messages) {
    event.messages.push(identityInjection);
  }

  console.log("[ENTJ Hook] 身份注入完成");
}

/**
 * Message Received Hook 處理器
 *
 * 收到消息時記錄並分析目標
 */
async function handleMessageReceived(event: InternalHookEvent): Promise<void> {
  console.log("[ENTJ Hook] Message Received 觸發");

  const context = event.context as MessageReceivedHookContext;
  const state = getOrCreateState();

  // 記錄對話
  const logEntry = {
    timestamp: new Date().toISOString(),
    from: context.from,
    content: context.content.substring(0, 200),
    channelId: context.channelId,
  };

  // 追加到訓練日誌
  appendToWorkoutLog(logEntry);

  // 分析是否有目標設定
  analyzeForGoals(context.content);

  writeState(state);
}

/**
 * Message Sent Hook 處理器
 *
 * 發送消息後更新進度
 */
async function handleMessageSent(event: InternalHookEvent): Promise<void> {
  console.log("[ENTJ Hook] Message Sent 觸發");

  const context = event.context as MessageSentHookContext;
  const state = getOrCreateState();

  // 更新訓練計數（如果消息包含訓練完成）
  if (context.content.includes("✅") || context.content.includes("完成") || context.content.includes("💪")) {
    state.workoutsCompleted += 1;
  }

  writeState(state);
}

/**
 * Message Preprocessed Hook 處理器
 *
 * 消息預處理時注入 ENTJ 風格
 */
async function handleMessagePreprocessed(event: InternalHookEvent): Promise<void> {
  console.log("[ENTJ Hook] Message Preprocessed 觸發");

  // 可以在這裡修改 bodyForAgent 以注入 ENTJ 風格提示
}

// ============================================================================
// 輔助函數
// ============================================================================

/**
 * 追加到訓練日誌
 */
function appendToWorkoutLog(entry: {
  timestamp: string;
  from: string;
  content: string;
  channelId: string;
}): void {
  const logPath = join(HOOKS_BASE_PATH, "state", "workout-log.md");
  ensureDirectoryExists(dirname(logPath));

  const date = new Date().toISOString().split("T")[0];
  const time = new Date().toISOString().split("T")[1].split(".")[0];

  const logEntry = `
### ${entry.from} - ${time}
**時間**: ${entry.timestamp}
**頻道**: ${entry.channelId}

**內容**:
${entry.content}

---
`;

  try {
    if (existsSync(logPath)) {
      const existing = readFileSync(logPath, "utf-8");
      writeFileSync(logPath, existing + logEntry, "utf-8");
    } else {
      const header = `# 訓練日誌 - Workout Log\n\n> 💪 所有訓練記錄將自動追加到此文件\n\n---\n\n## ${date}\n`;
      writeFileSync(logPath, header + logEntry, "utf-8");
    }
  } catch (error) {
    console.error("[ENTJ Hook] 寫入訓練日誌失敗:", error);
  }
}

/**
 * 分析目標設定
 */
function analyzeForGoals(content: string): void {
  const goalKeywords = [
    "muscle up",
    "引體",
    "雙槓",
    "訓練",
    "健身",
    "肌力",
    "爆發力",
    "目標",
    "計畫",
    "想要",
    "想要練",
  ];

  const hasGoal = goalKeywords.some((keyword) => content.toLowerCase().includes(keyword));

  if (hasGoal) {
    addToGoals(content);
  }
}

/**
 * 添加到目標
 */
function addToGoals(content: string): void {
  const goalsPath = join(HOOKS_BASE_PATH, "state", "goals.md");
  ensureDirectoryExists(dirname(goalsPath));

  const goalId = `GOAL-${Date.now()}`;
  const timestamp = new Date().toISOString();

  const goalEntry = `
## [${goalId}] 新目標
**創建**: ${timestamp}
**內容**: ${content.substring(0, 500)}
**狀態**: pending

---
`;

  try {
    if (existsSync(goalsPath)) {
      const existing = readFileSync(goalsPath, "utf-8");
      writeFileSync(goalsPath, existing + goalEntry, "utf-8");
    }
  } catch (error) {
    console.error("[ENTJ Hook] 寫入目標失敗:", error);
  }
}

/**
 * 檢查當前時間是否在訓練時段
 */
function isTrainingHours(): boolean {
  const state = getOrCreateState();
  const currentHour = new Date().getHours();
  const currentMinute = new Date().getMinutes();
  const currentTime = currentHour * 60 + currentMinute;

  for (const trainingHour of state.bioClock.trainingHours) {
    const [start, end] = trainingHour.split("-");
    const [startHour, startMinute] = start.split(":").map(Number);
    const [endHour, endMinute] = end.split(":").map(Number);

    const startMinutes = startHour * 60 + startMinute;
    const endMinutes = endHour * 60 + endMinute;

    if (currentTime >= startMinutes && currentTime <= endMinutes) {
      return true;
    }
  }

  return false;
}

/**
 * 檢查當前時間是否在休息時段
 */
function isRestHours(): boolean {
  const state = getOrCreateState();
  const currentHour = new Date().getHours();
  const currentMinute = new Date().getMinutes();
  const currentTime = currentHour * 60 + currentMinute;

  for (const restHour of state.bioClock.restHours) {
    const [start, end] = restHour.split("-");
    const [startHour, startMinute] = start.split(":").map(Number);
    const [endHour, endMinute] = end.split(":").map(Number);

    const startMinutes = startHour * 60 + startMinute;
    const endMinutes = endHour * 60 + endMinute;

    if (currentTime >= startMinutes && currentTime <= endMinutes) {
      return true;
    }
  }

  return false;
}

// ============================================================================
// Hook 註冊
// ============================================================================

/**
 * 註冊所有 ENTJ Hook 處理器
 */
export function registerENTJHooks(): void {
  console.log("[ENTJ Hook] 註冊 Hook 處理器...");

  // 註冊 Agent Bootstrap Hook
  registerInternalHook("agent:bootstrap", handleAgentBootstrap);

  // 註冊 Message Received Hook
  registerInternalHook("message:received", handleMessageReceived);

  // 註冊 Message Sent Hook
  registerInternalHook("message:sent", handleMessageSent);

  // 註冊 Message Preprocessed Hook
  registerInternalHook("message:preprocessed", handleMessagePreprocessed);

  console.log("[ENTJ Hook] Hook 處理器註冊完成");
}

/**
 * 取消註冊所有 ENTJ Hook 處理器
 */
export function unregisterENTJHooks(): void {
  console.log("[ENTJ Hook] 取消註冊 Hook 處理器...");

  console.log("[ENTJ Hook] Hook 處理器已取消註冊");
}

// ============================================================================
// 導出
// ============================================================================

export {
  // 狀態管理
  readState,
  writeState,
  getOrCreateState,
  createDefaultState,

  // 配置管理
  readConfig,

  // 身份注入
  generateIdentityInjection,
  generateResponsePrefix,

  // Hook 處理器
  handleAgentBootstrap,
  handleMessageReceived,
  handleMessageSent,
  handleMessagePreprocessed,

  // 輔助函數
  isTrainingHours,
  isRestHours,
  appendToWorkoutLog,
  analyzeForGoals,
  addToGoals,

  // Hook 註冊
  registerENTJHooks,
  unregisterENTJHooks,

  // 常量
  ENTJ_TRAITS,
  COACH_MOTTOS,
  COACH_PHRASES,
  HOOKS_BASE_PATH,
};

// ============================================================================
// 自動註冊 (當作為模塊導入時)
// ============================================================================

if (import.meta.url === `file://${process.argv[1]}`) {
  registerENTJHooks();
  console.log("[ENTJ Hook] 已作為獨立模塊啟動");
}
