# AIエージェント 許可設定ポリシー

このドキュメントは、Claude Code などの AI エージェントに対する操作許可の考え方と設定方針を定めます。
`~/.claude/settings.local.json` は各端末で直接管理し、本ドキュメントを実装根拠として使用します。

---

## 基本方針

- **ワークスペース内の作業は信頼する**: 開発作業の主体となるワークスペース内での読み書きは原則自由。
- **共有状態・外部への影響は確認する**: リモートへの push、プロセス停止など、自分の手元を超える操作は承認を必要とする。
- **機密情報・システム設定は保護する**: 秘密鍵・認証情報・dotfiles へのサイレント変更は防ぐ。

---

## ファイル操作

| 対象 | 判定 | 理由 |
|------|------|------|
| `~/workspace/**` の Read/Edit/Write | **allow** | 開発作業の主体。制限不要 |
| `~/AppData/Local/Temp/**` の Write | **allow** | 一時ファイル生成を許容 |
| `~/.*`（dotfiles）の Read/Edit/Write | **ask** | サイレント変更を防ぐ |
| `secrets/`、`*credentials*`、`*secret*`、`*.key`、`*.pem` の Read | **deny** | 機密情報の漏洩防止 |

---

## コマンド実行

| 操作 | 判定 | 理由 |
|------|------|------|
| 非破壊的コマンド全般 | **allow** | 調査・ビルド・テスト等は開発作業の一部 |
| docker stop / start | **allow** | 開発環境の制御。破壊的でない |
| パッケージインストール（npm/pip/uv/apt/winget 等） | **ask** | 環境の変化を把握したい。local/global 問わず |
| git push / git push --force | **ask** | リモートへの影響を確認してから実行 |
| kill（プロセス停止） | **ask** | 意図しないプロセス終了を防ぐ |
| sudo / 権限昇格 | **deny** | システム全体への影響リスクが高い |

**「非破壊的」の定義**: 実行を取り消せる、または影響範囲がワークスペース内に閉じているコマンド。
`rm` はワークスペース内であれば許容するが、`git reset --hard` や `git clean` は取り消しが難しいため ask とする。

---

## ネットワーク

| 操作 | 判定 | 理由 |
|------|------|------|
| WebSearch | **allow** | 調査・情報収集は開発作業の一部 |
| WebFetch（URL指定の取得） | **allow** | ドキュメント参照等で常用する |
| その他のネットワーク接続（API呼び出し等） | **ask** | 意図しない外部送信を防ぐ |

---

## 機密情報

以下のパターンにマッチするファイルは Read を deny とする。
書き込みについてもワークスペース外であれば ask。

- `secrets/` 配下
- `*credentials*`
- `*secret*`
- `*.key`
- `*.pem`

---

## settings.local.json への対応

上記ポリシーを `~/.claude/settings.local.json` に実装する場合の対応関係：

```
allow  → permissions.allow
ask    → permissions.ask
deny   → permissions.deny
```

`settings.local.json` は OS、ホームディレクトリ、パッケージマネージャー、ローカルの許可方針に依存するため、chezmoi では配布しない。
各端末でこのポリシーに沿って設定し、端末固有の差分はリポジトリへ取り込まない。
