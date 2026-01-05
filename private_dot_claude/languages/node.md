# Node.js/TypeScript設計方針
- 型安全を優先（any禁止、unknown推奨）
- 関数型アプローチ推奨（副作用の分離）
- ESModules前提（CommonJSは必要な場合のみ）
- Prettier/ESLint準拠のフォーマット
- interface定義時は実装の共通化も検討
