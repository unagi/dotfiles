# 開発共通ガイド

- 最終確認日: 2026-03-02
- ツール前提:
  - devcontainer CLI 0.82.0
  - Volta 2.0.2
  - uv 0.9.18
  - SDKMAN!（Java）

## 優先順位
1. プロジェクトに devcontainer 設定（`.devcontainer/devcontainer.json` または `devcontainer.json`）がある場合は、devcontainer を最優先で使用する。
2. JavaScript/TypeScript は Volta 管理を優先する（`volta run ...`）。
3. Python は uv 管理を優先する（`uv run ...`、activate不要）。
4. Java は SDKMAN! 管理を優先する（`sdk env` / `sdk use java <version>`）。
5. 上記よりもプロジェクト固有ルール（README/Makefile/CI設定）を優先する。

## 実行例
```bash
# JS/TS
volta run npm test

# Python
uv run pytest
```

## 実行前チェック
- 今の判断・実行に必要な最小限の確認で進める。既存手順・プロジェクト定義と有効な確認結果を再利用し、可能な限り CI と同じ標準コマンドを使う。単発の調査は目的に応じて確認範囲を絞る。
- ビルド・デプロイ等で繰り返す確認は、対象プロジェクトで保守する標準コマンド・ジョブへ組み込み、高速に自動実行できる形を優先する。必要な仕組みが不足している場合は、承認範囲内で実装し、範囲外なら対象・変更を依頼元へ返す。
- 必要なコマンドラインツールが不足している場合は、代替実装で進めず導入を依頼する。
