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
│       │   ├── parent.md
│       │   ├── child.md            # worker / advisor 共通の末端規約
│       │   ├── finance.md
│       │   ├── data-worker.md
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
│   ├── agents/                     # Codex custom agents（TOMLテンプレート）
│   ├── common/
│   │   ├── development.md.tmpl
│   │   └── project-instructions-guideline.md.tmpl
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

## エージェント定義の管理方針

- ロール本文の正本は `.chezmoitemplates/agent/roles/` に置く
- Claude 用エージェントは `private_dot_claude/agents/*.md.tmpl` で frontmatter の差分だけを持つ
- Codex 用エージェントは `dot_codex/agents/*.toml.tmpl` で TOML、モデル、表示名とCodex固有の職能定義を持つ
- Codex 専用の parent / worker / advisor 規約の正本は `.chezmoitemplates/agent/codex/` に置く。共有する Claude のロール本文は変更しない
- Codex の 18 定義は、メイン→parent→worker/advisor の深さ2を基本にする。parent が判断・統合・検証に責任を持ち、worker は担当範囲を調査または実装から検証まで完遂し、advisor は必要時の Astra 顧問として扱う
- 金融分析はSolのparent、数値取得はLunaのData worker、決算・開示等の分析はResearch workerに分担する。[市場データ取得台帳](dot_codex/common/market-data-sources.md.tmpl)をCodexの共通ガイドとして配布する
- モデル、推論量、階級表示、parent の選択は [Codexエージェント編成とモデル選択](docs/codex-agent-model-selection.md) を参照する
- `config.toml` は chezmoi 管理外であるため、メインモデル、深さ、同時実行枠はこのリポジトリからは変更しない。source から削除した旧エージェント定義が適用先から自動削除されるとは限らないため、整理時は適用先を明示して確認する

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
