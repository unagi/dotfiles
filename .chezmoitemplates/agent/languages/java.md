# Java設計方針

- 最終確認日: 2026-03-02
- 前提バージョン: プロジェクト定義値（`pom.xml` / `build.gradle` / toolchain設定）を優先

## 設計
- SOLID原則を遵守する。
- interface 定義時は共通ロジックを抽象クラスまたはデフォルトメソッドに抽出する。
- 個別実装は差分のみを持たせる。
- Lombok は既存プロジェクトの方針に従う。
- Null安全（Optional活用、`@Nullable` / `@NonNull` 明示）を徹底する。

## 品質
- 既存のビルドツール（Maven/Gradle）と CI に合わせたコマンドを優先する。
