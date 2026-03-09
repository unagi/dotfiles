# dotfiles AGENTS

## 目的
- このリポジトリは `chezmoi` の source として、ユーザーグローバル設定を管理する。
- リポジトリ保守用ファイルは配布対象ではなく、`chezmoi` 管理外にする。

## 復元先
- `dot_codex/` → `~/.codex/`
- `private_dot_claude/` → `~/.claude/`

## Codex 管理方針
- `~/.codex` は「明示的に管理する固定資産」と「Codex エコシステムが内部管理する状態ファイル」が混在する。
- `chezmoi` で管理するのは、移植性があり、意図的に配布したいファイルだけに限定する。
- `common/` と `languages/` のような共通ガイドは、`dot_codex/` 配下で明示管理する。
- built-in / stateful な領域は `chezmoi` に取り込まない。部分同期すると整合性が崩れやすいため。

## Codex で除外するもの
- `config.toml`
- 認証情報、履歴、ログ、キャッシュ、DB、テンポラリ、セッション
- `skills/` 配下全体
- Codex が内部的に生成・更新するファイル

## 運用ルール
- `~/.codex` 配下の新規ファイルを取り込む前に、「ユーザーが保守する静的資産」か「Codex が管理する状態」かを先に判定する。
- 判定に迷うものは、先に `AGENTS.md` と `.chezmoiignore` の方針を更新してから取り込む。
- ルート直下の `AGENTS.md`、`README.md`、`LICENSE` などのリポジトリ保守用ファイルは、`.chezmoiignore` に明示する。
