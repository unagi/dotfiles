# Python設計方針

- 最終確認日: 2026-03-02
- 前提バージョン: プロジェクト定義値（`pyproject.toml` / `.python-version`）を優先

## 設計
- DRY重視、共通処理は適切なモジュールに抽出する。
- クラス継承より合成を優先する。
- 型ヒントを必須とし、mypy/pyright で検証可能なコードにする。
- dataclass/Pydanticを活用し、素の `dict` の乱用を避ける。

## 品質
- Ruff/Black 準拠のフォーマットを維持する。
- テスト・lint は `uv run` で実行する（例: `uv run pytest`）。
