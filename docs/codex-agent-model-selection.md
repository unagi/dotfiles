# Codex サブエージェント モデル選択方針

## 目的

Codex のサブエージェントごとに、役割の重さに応じたモデルと reasoning effort を選ぶ。
モデル名だけで性能階層を表現せず、松竹梅の役割分類と reasoning effort をセットで管理する。

## 基本階層

| 階層 | 用途 | モデル | reasoning effort |
| --- | --- | --- | --- |
| 松 | 設計判断、高リスクレビュー、構造改善 | `gpt-5.6-sol` | `high` |
| 竹 | 実装、深い調査、ドキュメント再構成 | `gpt-5.6-terra` | `medium` / `high` |
| 梅 | 単一ファイル処理、lint、テスト、単一URL調査 | `gpt-5.6-luna` | `low` / `medium` |

## ロール対応

| agent | 階層 | model | reasoning effort | 理由 |
| --- | --- | --- | --- | --- |
| `architect` | 松 | `gpt-5.6-sol` | `high` | 設計判断の失敗が後続実装全体に波及するため |
| `refactorer` | 松 | `gpt-5.6-sol` | `high` | 技術的負債の構造改善では誤った抽象化のコストが高いため |
| `security-reviewer` | 松 | `gpt-5.6-sol` | `high` | 脆弱性の見落としコストが高いため |
| `implementer` | 竹 | `gpt-5.6-terra` | `medium` | 仕様に沿った実装とテスト確認を安定して行うため |
| `investigator` | 竹 | `gpt-5.6-terra` | `high` | 複数ファイル調査と根本原因分析を行うため |
| `doc-writer` | 竹 | `gpt-5.6-terra` | `medium` | ドキュメント構造の再整理を行うため |
| `file-reader` | 梅 | `gpt-5.6-luna` | `low` | 単一ファイル読解に限定するため |
| `lint-fixer` | 梅 | `gpt-5.6-luna` | `medium` | 単一ファイルの機械的修正を確実に行うため |
| `test-runner` | 梅 | `gpt-5.6-luna` | `low` | テスト実行と結果整理が中心のため |
| `doc-checker` | 梅 | `gpt-5.6-luna` | `medium` | 実装とドキュメントの対応関係を読むため |
| `web-researcher` | 梅 | `gpt-5.6-luna` | `medium` | 単一URLでも要約・信頼度判断が必要なため |

## 運用ルール

- GPT-5.6 系を標準にする。Sol は複雑で高リスクな判断、Terra は日常的な実装・調査、Luna は明確で反復的な処理に使う。
- 引退予定または非推奨の `gpt-5.4`、`gpt-5.4-mini`、`gpt-5.3-codex` は既定で使わない。
- reasoning effort は、親セッションからの継承で意図が曖昧になる agent では明示する。
