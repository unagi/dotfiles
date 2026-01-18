## 言語
- 返答は常に日本語（簡潔・丁寧）。
- コマンド/設定例はコピペ可能な形で提示。

## 進め方（基本）
- まず現状把握：`git status` / 差分確認 / 関連ファイル検索。
- プロジェクト言語の特定：`pyproject.toml` / `package.json` / `Makefile` 等を確認
  → 言語別指示に従って実行（`cat ~/.codex/languages/java.md` / `cat ~/.codex/languages/node.md` / `cat ~/.codex/languages/python.md`）。
- 変更後は必ず：lint/test（プロジェクト標準）→差分要約→コミット案。

## Git運用（commit〜PR）
- mainへのpushはinitial commit以外では原則禁止
- ブランチ作成 → 変更 → テスト → commit → push → PR作成までを一通り実施できる前提で動く。
- コミットメッセージは「変更理由 + 影響範囲 + 破壊的変更の有無」を含める（Conventional Commits推奨）。

## 安全
- トークン/秘密情報は出力しない。ログに残る操作（push/PR作成/権限付与）は実行前に要点を確認してから。

## ドキュメント参照（Context7）
- 手順：プロジェクト実バージョン確認 → Context7でその版を確認 → 版前提を明示。
- 実装に関わる提案（API/設定/CLIオプション/推奨構成）は、学習済み知識だけで断定せず **Context7で一次情報を確認**してから提示する。
- 特に「古いバージョンの手順が混ざりやすい」話題（メジャーアップデート、非推奨、破壊的変更）は **必ずContext7**。

## 高速化（最小）
- 検索は `rg` を最優先（無ければ `grep -R`）。
- ファイル探索は `fdfind`（無ければ `find`）。
- ファイル閲覧は `batcat`（無ければ `cat`）。
- 差分確認は `git status -sb` → `git diff`（`delta` 無ければ素のまま）。
- 迷ったら `fzf` を挟む（`rg ... | fzf` / `fdfind ... | fzf`）。

## 進め方（TDD / カバレッジ厳格プロジェクト）
- 原則: 1サイクルを小さく回す（Red → Green → Refactor）。大きい変更は縦スライスで分割する。
- 手順:
  1) 企画:
     - Given/When/Then で期待仕様を1〜3個に分解して箇条書きにする
     - 未カバーになりやすい分岐を明記（例外 / 早期return / flag/env分岐 / 空/null / I/O失敗）
  2) テスト実装（Red）:
     - 先に失敗するテストを追加し、失敗を確認してから実装へ進む
     - 可能なら「対象ファイル/対象ケースに絞ったテスト」で最速にRed→Green確認する
  3) 処理実装（Green）:
     - テストが通る最小実装
  4) レビュー（Refactor）:
     - 重複排除・命名・責務分離・境界整理
     - 分岐補強テストはGreen後に追加（Red→Greenの粒度を壊さない）
  5) ユーザー回答:
     - 差分要約（テスト→仕様→実装の順）+ 影響範囲 + 破壊的変更の有無
- ゲート（必須）:
  - 実装に入る前に必ず Red を確認
  - まず関連テストだけでGreenにする → その後にプロジェクト標準の lint/test/coverage を実行
  - カバレッジ閾値に関わる分岐は「企画」時点でテスト対象として明記する


## Web参照（curl連発防止：この環境は lynx/w3m あり）
- まずローカル一次情報（`--help` / `man` / repo内README/Docs）を優先。
- Webを読む必要がある場合は `lynx -dump` を第一選択（次点 `w3m -dump`）。
- `curl` / `wget` は最終手段。取得は原則「1URLにつき1回」まで（同URLの連発禁止、出力を再利用）。

## Codex notes
- gh pr create: use --body-file (or -F) to preserve newlines; avoid --body with escaped \n.
