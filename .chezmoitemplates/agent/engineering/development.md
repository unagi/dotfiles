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
- まず `README.md` / `Makefile` / `package.json` / `pyproject.toml` で公式手順を確認する。
- 可能な限り CI と同じコマンドを使う。
- 必要なコマンドラインツールが不足している場合は、代替実装で進めず導入を依頼する。
