# Codex サブエージェント モデル選択方針

## 目的

Codex のサブエージェントごとに、役割の重さに応じたモデルと reasoning effort を選ぶ。
モデル名だけで性能階層を表現せず、松竹梅の役割分類と reasoning effort をセットで管理する。

## 基本階層

| 階層 | 用途 | モデル | reasoning effort |
| --- | --- | --- | --- |
| 松 | 設計判断、高リスクレビュー、構造改善 | `gpt-5.5` | `high` / `xhigh` |
| 竹 | 実装、深い調査、ドキュメント再構成 | `gpt-5.4` | `medium` |
| 梅 | 単一ファイル処理、lint、テスト、単一URL調査 | `gpt-5.4-mini` | `low` / `medium` |

## ロール対応

| agent | 階層 | model | reasoning effort | 理由 |
| --- | --- | --- | --- | --- |
| `architect` | 松 | `gpt-5.5` | `xhigh` | 設計判断の失敗が後続実装全体に波及するため |
| `refactorer` | 松 | `gpt-5.5` | `xhigh` | 技術的負債の構造改善では誤った抽象化のコストが高いため |
| `security-reviewer` | 松 | `gpt-5.5` | `high` | 脆弱性の見落としコストが高いため |
| `implementer` | 竹 | `gpt-5.4` | `medium` | 仕様に沿った実装とテスト確認を安定して行うため |
| `investigator` | 竹 | `gpt-5.4` | `medium` | 複数ファイル調査と根本原因分析を行うため |
| `doc-writer` | 竹 | `gpt-5.4` | `medium` | ドキュメント構造の再整理を行うため |
| `file-reader` | 梅 | `gpt-5.4-mini` | `low` | 単一ファイル読解に限定するため |
| `lint-fixer` | 梅 | `gpt-5.4-mini` | `low` | 単一ファイルの機械的修正が中心のため |
| `test-runner` | 梅 | `gpt-5.4-mini` | `low` | テスト実行と結果整理が中心のため |
| `doc-checker` | 梅 | `gpt-5.4-mini` | `medium` | 実装とドキュメントの対応関係を読むため |
| `web-researcher` | 梅 | `gpt-5.4-mini` | `medium` | 単一URLでも要約・信頼度判断が必要なため |

## 運用ルール

- `gpt-5.5` が使える環境では、松は `gpt-5.5` を標準にする。
- `gpt-5.5` が使えない環境だけ、松を `gpt-5.4` と同じ reasoning effort に落とす。
- `gpt-5.3-codex` は既定では使わない。明示的な検証・互換性確認・特殊事情がある場合のみ採用する。
- reasoning effort は、親セッションからの継承で意図が曖昧になる agent では明示する。
