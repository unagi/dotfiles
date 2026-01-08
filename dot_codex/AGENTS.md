## 言語
- 返答は常に日本語（簡潔・丁寧）。
- コマンド/設定例はコピペ可能な形で提示。

## 進め方（基本）
- まず現状把握：`git status` / 差分確認 / 関連ファイル検索。
- 変更後は必ず：lint/test（プロジェクト標準）→差分要約→コミット案。

## Git運用（commit〜PR）
- ブランチ作成 → 変更 → テスト → commit → push → PR作成までを一通り実施できる前提で動く。
- コミットメッセージは「変更理由 + 影響範囲 + 破壊的変更の有無」を含める（Conventional Commits推奨）。

## 安全
- トークン/秘密情報は出力しない。ログに残る操作（push/PR作成/権限付与）は実行前に要点を確認してから。

## ドキュメント参照（Context7）
- 実装に関わる提案（API/設定/CLIオプション/推奨構成）は、学習済み知識だけで断定せず **Context7で一次情報を確認**してから提示する。
- 特に「古いバージョンの手順が混ざりやすい」話題（メジャーアップデート、非推奨、破壊的変更）は **必ずContext7**。
- 参照した内容は「どのバージョン前提か」を短く明示してから提案する（例：vX.Y 前提）。
- 可能なら、プロジェクト側の実バージョン（package.json / lockfile / `--version`）を先に確認する。

## 高速化（最小）
- 検索は `rg` を最優先（`grep -R` / `find` は原則使わない）。
- ファイル探索は `fdfind`（`fd` は無い前提）。
- ファイル閲覧は `batcat`（`bat` は無い前提）。
- 差分確認は `git status -sb` → `git diff`（表示は `delta` 前提でOK）。
- 迷ったら `fzf` を挟む（`rg ... | fzf` / `fdfind ... | fzf`）。

## Web参照（curl連発防止：この環境は lynx/w3m あり）
- まずローカル一次情報（`--help` / `man` / repo内README/Docs）を優先。
- Webを読む必要がある場合は `lynx -dump` を第一選択（次点 `w3m -dump`）。
- `curl` / `wget` は最終手段。取得は原則「1URLにつき1回」まで（同URLの連発禁止、出力を再利用）。

## Codex notes
- gh pr create: use --body-file (or -F) to preserve newlines; avoid --body with escaped \n.
