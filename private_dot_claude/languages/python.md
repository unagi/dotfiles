# Python設計方針
- DRY重視、共通処理は適切なモジュールに抽出
- クラス継承より合成を優先
- 型ヒント必須（mypy/pyright準拠）
- Ruff/Black準拠のフォーマット
- dataclass/Pydantic活用、素のdictを避ける
- `uv run` コマンドでプロジェクトの.venvが自動的に使用される
- 明示的な activate は不要
