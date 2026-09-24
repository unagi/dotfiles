# dotfiles

個人用dotfiles管理リポジトリ（[chezmoi](https://www.chezmoi.io/)使用）

## 概要

このリポジトリは、主に以下の設定ファイルを管理しています：

- **Claude Code設定** - AIコーディングアシスタントの個人設定
  - グローバル指示（CLAUDE.md）
  - 開発共通ガイド（common/development.md）
  - プロジェクト用指示ファイル整備ガイド（common/project-instructions-guideline.md）
  - 言語別設計方針（Python, Node.js, Java）
  - カスタムエージェント・コマンド
  - パーミッション設定
- **Codex設定**
  - グローバル指示（AGENTS.md）
  - 開発共通ガイド（common/development.md）
  - プロジェクト用指示ファイル整備ガイド（common/project-instructions-guideline.md）
  - 言語別設計方針（Python, Node.js, Java）
- **source-onlyテンプレート**
  - `.chezmoitemplates/` に共通ガイド本文を配置し、Claude/Codex双方に展開

## スコープ

- このリポジトリの主目的は、`~/.codex/` と `~/.claude/` のユーザーグローバル設定を管理・配布することです。
- プロジェクトローカルの指示ファイル（`AGENTS.md` など）は各プロジェクト側が正本であり、本リポジトリでは整備ガイドを提供します。

## セットアップ

### 前提条件

- [chezmoi](https://www.chezmoi.io/install/) がインストール済みであること

### 新規環境でのセットアップ

```bash
# リポジトリのクローン
git clone <your-repo-url> ~/dotfiles

# chezmoiで設定を適用
chezmoi init --apply --source ~/dotfiles
```

### 既存環境での初期化

```bash
# chezmoiのインストール
curl -fsLS get.chezmoi.io | sh

# dotfilesを使用してchezmoiを初期化
chezmoi init --source ~/dotfiles

# 設定の適用
chezmoi apply
```

## 使い方

### 設定ファイルの変更を反映

```bash
# 変更したファイルをchezmoiに追加
chezmoi add ~/.claude/CLAUDE.md

# 差分確認
chezmoi diff

# 変更をdotfilesにコミット
cd ~/dotfiles
git add .
git commit -m "update: ..."
git push
```

### 他の環境に変更を同期

```bash
# dotfilesを更新
cd ~/dotfiles
git pull

# 設定を適用
chezmoi apply
```

### 管理対象ファイルの確認

```bash
# chezmoi管理下のファイル一覧
chezmoi managed

# 特定のファイルの状態確認
chezmoi status
```

## ディレクトリ構造

```
~/dotfiles/
├── .chezmoitemplates/              # source-onlyテンプレート（デプロイ対象外）
│   └── agent/
│       ├── common/
│       │   ├── development.md
│       │   └── project-instructions-guideline.md
│       ├── codex/                 # Codex専用のparent / worker / advisor規約
│       │   ├── parent.md           # parent共通の責務・記録・検証
│       │   ├── parent-advanced.md  # Sol / Astra parentの委任規範
│       │   ├── child.md            # worker / advisor 共通の末端規約
│       │   ├── finance.md
│       │   ├── market-data-worker.md
│       │   ├── research-worker.md
│       │   ├── implementation-worker.md
│       │   └── research.md
│       ├── roles/
│       │   ├── architect.md
│       │   ├── implementer.md
│       │   └── ...
│       └── languages/
│           ├── java.md
│           ├── node.md
│           └── python.md
├── .chezmoi.toml.tmpl              # chezmoi設定（暗号化設定含む）
├── .chezmoiignore                  # chezmoi管理対象外ファイル
├── .gitignore                      # Git追跡対象外ファイル
├── .editorconfig                   # エディタ設定
├── .gitattributes                  # Git属性
├── LICENSE                         # MITライセンス
├── README.md                       # このファイル
├── dot_codex/                      # ~/.codex/ にデプロイされる
│   ├── AGENTS.md.tmpl              # グローバル指示テンプレート
│   ├── agents/                     # Codex custom agents（GPT-6、root-advisorを含む）
│   ├── common/
│   │   ├── development.md.tmpl
│   │   ├── project-instructions-guideline.md.tmpl
│   │   ├── root-agent.md.tmpl       # 起点専用の案件管理・parent選択
│   │   └── sub-agent.md.tmpl        # 起動者共通の階層・起動・照合
│   └── languages/
│       ├── java.md.tmpl
│       ├── node.md.tmpl
│       └── python.md.tmpl
└── private_dot_claude/             # ~/.claude/ にデプロイされる
    ├── CLAUDE.md                   # グローバル指示
    ├── agents/                     # Claude custom agents（共通本文をinclude）
    ├── common/
    │   ├── development.md.tmpl
    │   └── project-instructions-guideline.md.tmpl
    ├── commands/                   # カスタムコマンド
    └── languages/                  # 言語別設計方針（source-onlyテンプレートから展開）
```

## エージェント関連ドキュメント

以下は人向けの資料です。全体像をアウトラインと概念図で説明し、詳細は対応するエージェント向け指示・テンプレートへリンクしています。

- [Codexサブエージェントの全体像と設計コンセプト](docs/codex-subagents.md)：役割の関係図、依頼から完了までの流れ、原文引継ぎと業務報告書の考え方
- [現行のエージェント編成・モデル設定](docs/codex-agent-model-selection.md)：実装済みロール、選択表、移行記録

## セキュリティ

### 完全除外（リポジトリに含まれない）

以下のファイルは**リポジトリに含まれません**（機密情報保護）：

- `.credentials.json` - API認証情報
- `settings.local.json` - 端末固有のClaude Code権限設定
- `history.jsonl` - コマンド実行履歴
- `projects/`, `session-env/`, `file-history/` など - 一時ファイル・キャッシュ

除外設定は `.chezmoiignore` および `.gitignore` で二重管理されています。

### 端末固有の設定

`~/.claude/settings.local.json` は、OS、ホームディレクトリ、パッケージマネージャー、ローカルの許可方針に依存するため chezmoi では管理しません。各端末で直接管理します。

## トラブルシューティング

### chezmoiが古いディレクトリを参照している

```bash
# ソースディレクトリの確認
chezmoi source-path

# 正しいディレクトリで再初期化
chezmoi init --source ~/dotfiles
```

### 設定ファイルが適用されない

```bash
# dry-runで確認
chezmoi apply --dry-run --verbose

# 強制適用
chezmoi apply --force
```

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照
