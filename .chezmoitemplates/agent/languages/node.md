# Node.js/TypeScript設計方針

- 最終確認日: 2026-03-02
- 前提バージョン: プロジェクト定義値（`package.json` / `volta` 設定）を優先

## 設計
- 型安全を優先し、`any` は原則禁止（必要時は `unknown` で境界を明示）。
- 副作用を分離し、テストしやすい関数設計を優先する。
- ES Modules 前提で実装し、CommonJS は必要時のみ採用する。
- interface 定義時は共通化可能な処理を先に検討する。

## 品質
- Prettier/ESLint 準拠のフォーマットを維持する。
- テスト・lint は Volta 経由で実行する（例: `volta run npm test`）。
