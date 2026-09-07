# Codex エージェント編成とモデル選択

## 目的

メインスレッドは対話、ヒアリング、案件状態の保持を担い、専門作業は案件責任者（parent）に委譲する。parent は案件全体の判断・統合・検証に責任を持ち、少量の作業は自ら完遂する。独立した有用な作業単位があり、parent 自身にも並走する有用な作業がある場合だけ child を起動する。

この構成では、メインを軽量化しつつ、案件の難易度に応じて parent のモデルを選ぶ。child は作業の量と独立性、advisor は技術的な難所によって使い分ける。

## 階層と責任

```text
メイン（対話・案件状態）
└─ parent（案件の判断・統合・検証）
   ├─ child（限定された調査・実装・検証）
   └─ advisor（難所の再分析・反証、必要時のみ）
```

- メイン直轄は parent のみとする。child、advisor は parent が起動する。
- child と advisor は再委譲しない。parent の配下に別の parent は置かない。
- parent は child の結果を単に集計せず、証拠、適用条件、矛盾、結合結果を評価する。矛盾を解消できない場合は、条件と未確認事項を残す。
- parent が能力不足または技術的な難所に達した場合は、Astra の `advisor` に限定相談する。方針の採否、実装、統合、ユーザー承認の代替は advisor に委ねない。
- ユーザーの価値観、優先順位、リスク受容、承認はメインが仲介する。parent は、聞いてほしい質問、その理由、回答で変わる判断、必須度、未回答時の扱いを返す。メインは原文、確定条件、現時点の選好、検討中の発言、自身の解釈を区別して同じ parent に引き継ぐ。

## 階級とモデル

階級は親子関係ではなく、使用モデルの能力帯を表す。表示名の番号は個体識別用で、起動順や優先順位を示さない。

| 階級 | モデル | 主な用途 |
| --- | --- | --- |
| `2Lt` | `gpt-5.6-luna` | 明確で反復的な情報抽出、単一ファイル処理、テスト |
| `1Lt` | `gpt-5.6-terra` | 日常的な調査・実装・レビュー、複雑な資料照合 |
| `Maj` | `gpt-5.6-sol` | 複雑な判断、設計、構造改善、高リスクなレビュー |
| `Col` | `gpt-6-astra` | 高度調査、難所の独立した再分析・反証 |

`Lead` は parent、`Advisor` は顧問を表す。`nickname_candidates` による階級表示はテンプレートへ設定済みだが、実アプリでの表示反映は未検証である。

## parent の選択

| 案件 | 通常 | 判断が複雑な場合 | parent の責任 |
| --- | --- | --- | --- |
| 一般調査 | `research-lead`（Terra / high） | `research-lead-sol`（Sol / high） | 公式情報・利用者の観測を比較し、条件付きの結論と未確認事項を統合する |
| 高度調査・仮説立案 | `advanced-research-lead`（Astra / medium） | 同じ parent が `advisor` に独立反証を依頼 | 希少事例や組織制約下で、代替策、成立条件、残余リスク、見直し条件を示す |
| 設計のみ | `architect`（Sol / high） | `advisor` に限定相談 | 設計判断と実装単位・受入条件を定める。実装はメイン経由で引き継ぐ |
| 設計・実装 | `implementation-lead`（Terra / high） | `implementation-lead-sol`（Sol / high） | 合意済み要件を具体化し、実装、結合、受入検証を統合する |
| 案件救援・構造改善 | `recovery-lead`（Sol / high） | `advisor` に限定相談 | 現状・問題・改善候補を整理し、ユーザーが決めた方針を実行・検証する |
| 技術レビュー・コード原因調査（報告のみ） | `review-lead`（Terra / high） | `review-lead-sol`（Sol / high） | 根拠、重大性、推奨対応を評価する |

高度調査parentはread-onlyで調査・仮説更新に専念する。プロトタイプは仮説と終了条件をメインへ返し、承認後にメイン直轄の実装parentへ引き継ぐ。結果は同じ高度調査parentへ戻す。

設定変更や文書作成は `implementation-lead` / `implementation-lead-sol` が扱う。

`advanced-research-lead` と `advisor` の Astra / `medium` は試行値である。通常の案件救援は Sol を開始点とし、Astra を既定にしない。

## child の役割

| 区分 | エージェント | モデル / effort | 役割 |
| --- | --- | --- | --- |
| 情報収集 | `web-researcher` | Luna / medium | 単一 URL の取得、根拠の抽出、構造化要約 |
| 資料・コード調査 | `file-reader` | Luna / low | 単一ファイルの要点抽出 |
| 複雑な照合 | `research-analyst`、`investigator` | Terra / high | 仕様・版差・複数資料、または複数ファイルの因果関係を分析 |
| 実装 | `implementer`、`implementer-sol` | Terra / medium、Sol / high | 合意した変更境界の実装と検証 |
| 構造改善 | `refactorer` | Sol / high | 合意した範囲の設計レベルのリファクタリング |
| 品質確認 | `test-runner`、`lint-fixer`、`doc-checker` | Luna / low〜medium | テスト実行、単一ファイルの lint 修正、実装と文書の乖離確認 |
| 専門確認 | `security-reviewer`、`doc-writer` | Sol / high、Terra / medium | セキュリティ分析、ドキュメント全体の再構成 |

調査では媒体ではなく解釈の難易度で child を選ぶ。明確な情報抽出は Luna、複雑な仕様・版差・資料間の照合は Terra を使う。根拠不足や矛盾が返れば parent が追加調査または再配分する。

50 件程度の Web 調査は総量であり、同時起動数ではない。実行時に利用可能な枠で段階的に処理し、各段階で parent が根拠・不足・矛盾を統合する。エスカレーション時は新規 child の起動を止め、advisor 用の枠を確保する。書き込みは、所有範囲と受入条件が明確で相互依存しない変更境界だけ並列化する。

## 運用上の変更と管理範囲

- 既存の `implementer`、`investigator`、`refactorer` は child である。新規約ではメインから直接起動せず、該当する parent を経由する。これは従来の直接起動からの動作変更である。
- 既存の 11 ロールは維持し、parent 9 定義と child / advisor を含む 13 定義で、合計 22 定義とする。
- Codex 固有の規約の正本は `.chezmoitemplates/agent/codex/` に置く。共有する Claude 本文は変更せず、Codex のみで親子・顧問の振る舞いを追加する。
- `config.toml` は chezmoi 管理外である。このリポジトリの変更だけでは、メインの Luna 化、`max_depth`、同時実行枠は適用されない。設定する場合は手元の `~/.codex/config.toml` で別途検証する。

## 検証と参照

chezmoi v2.70.3で22定義の展開・TOML解析、必須項目、階級とモデル、表示候補のASCII制約と重複、9 parent / 13 leafの分類と委譲先、2ガイドの展開、Claudeへの規約混入がないことを確認した。実アプリの起動・表示・消費量は未検証。

- [公式Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [表示候補の検証処理](https://github.com/openai/codex/blob/main/codex-rs/agent-roles/src/agent_role_config.rs)

表示名候補は半角英数字・空白・ハイフン・アンダースコアに限定する。候補数は同時実行枠を設定しない。指示による階層と権限は実行環境の制約を上書きしない。
