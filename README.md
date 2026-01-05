# dotfiles

個人用dotfiles管理リポジトリ（[chezmoi](https://www.chezmoi.io/)使用）

## 概要

このリポジトリは、主に以下の設定ファイルを管理しています：

- **Claude Code設定** - AIコーディングアシスタントの個人設定
  - グローバル指示（CLAUDE.md）
  - 言語別設計方針（Python, Node.js, Java）
  - カスタムエージェント・コマンド
  - パーミッション設定

## セットアップ

### 前提条件

- [chezmoi](https://www.chezmoi.io/install/) がインストール済みであること

### 新規環境でのセットアップ

```bash
# リポジトリのクローン
git clone <your-repo-url> ~/dotfiles

# age秘密鍵を配置（別の端末から安全にコピー）
mkdir -p ~/.config/chezmoi
# ~/.config/chezmoi/key.txt に秘密鍵をコピー

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
├── .chezmoi.toml.tmpl              # chezmoi設定（暗号化設定含む）
├── .chezmoiignore                  # chezmoi管理対象外ファイル
├── .gitignore                      # Git追跡対象外ファイル
├── .editorconfig                   # エディタ設定
├── .gitattributes                  # Git属性
├── LICENSE                         # MITライセンス
├── README.md                       # このファイル
└── private_dot_claude/             # ~/.claude/ にデプロイされる
    ├── CLAUDE.md                   # グローバル指示
    ├── encrypted_settings.json.age # パーミッション・環境変数（暗号化）
    ├── agents/                     # カスタムエージェント
    ├── commands/                   # カスタムコマンド
    └── languages/                  # 言語別設計方針
```

## セキュリティ

### 完全除外（リポジトリに含まれない）

以下のファイルは**リポジトリに含まれません**（機密情報保護）：

- `.credentials.json` - API認証情報
- `history.jsonl` - コマンド実行履歴
- `projects/`, `session-env/`, `file-history/` など - 一時ファイル・キャッシュ

除外設定は `.chezmoiignore` および `.gitignore` で二重管理されています。

### 暗号化されたファイル

以下のファイルは**age暗号化**されてリポジトリに含まれます：

- `settings.json` - パーミッション設定・環境変数（公開したくないが端末間で同期したい）

**仕組み：**
- リポジトリには暗号化済みファイル（`encrypted_*.age`）をコミット
- age秘密鍵（`~/.config/chezmoi/key.txt`）は各端末で個別管理
- `chezmoi apply` 時に自動的に復号して配置

**秘密鍵の管理：**
```bash
# 秘密鍵の確認（初回セットアップ時）
cat ~/.config/chezmoi/key.txt

# 別端末への移動：USBメモリ、パスワードマネージャー、安全なファイル転送等を使用
# ⚠️ この鍵を失うと暗号化ファイルを復号できなくなります
```

**暗号化ファイルの追加：**
```bash
# 新しいファイルを暗号化して追加
chezmoi add --encrypt ~/.claude/new-sensitive-file.json
```

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
