# Codex エージェント編成とモデル選択

## 目的

メインスレッドは対話、ヒアリング、案件状態の保持を担い、専門作業は案件責任者（parent）に委譲する。parent は案件全体の判断・統合・検証に責任を持ち、少量の作業は自ら完遂する。独立した有用な作業単位があり、parent 自身にも並走する有用な作業がある場合だけ worker を起動する。

この構成では、メインを軽量化しつつ、案件の難易度に応じて parent のモデルを選ぶ。worker は必要な前提知識、担当範囲の難易度と独立性で選び、advisor は技術的な難所で使う。

## 階層と責任

```text
メイン（対話・案件状態）
└─ parent（案件の判断・統合・検証）
   ├─ worker（独立した担当範囲を完遂）
   └─ advisor（難所の再分析・反証、必要時のみ）
```

- メイン直轄は parent のみとする。worker、advisor は parent が起動する。
- worker と advisor は再委譲しない。parent の配下に別の parent は置かない。
- parent は worker の結果を単に集計せず、証拠、適用条件、矛盾、結合結果を評価する。矛盾を解消できない場合は、条件と未確認事項を残す。
- parent が能力不足または技術的な難所に達した場合は、Astra の `advisor` に限定相談する。方針の採否、実装、統合、ユーザー承認の代替は advisor に委ねない。
- ユーザーの価値観、優先順位、リスク受容、承認はメインが仲介する。parent は、聞いてほしい質問、その理由、回答で変わる判断、必須度、未回答時の扱いを返す。メインは原文、確定条件、現時点の選好、検討中の発言、自身の解釈を区別して同じ parent に引き継ぐ。

## 階級とモデル

階級は親子関係ではなく、使用モデルの能力帯を表す。表示名の番号は個体識別用で、起動順や優先順位を示さない。

| 階級 | モデル | 主な用途 |
| --- | --- | --- |
| `2Lt` | `gpt-5.6-luna` / medium | 方針と完了条件が明確な担当範囲の調査または実装 |
| `1Lt` | `gpt-5.6-terra` / high | 日常的な調査・実装・レビューを担当範囲内で完遂 |
| `Maj` | `gpt-5.6-sol` / high | 複雑な判断、設計、構造改善、高リスクなレビュー |
| `Col` | `gpt-6-astra` / medium | 高度調査、難所の独立した再分析・反証 |

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

## worker の役割と parent からの使い分け

worker は工程を分けるための小さな役ではない。parent は、十分な作業量があり、他の担当範囲と独立して進め、まとまった成果として検証できる単位だけを委譲する。依頼には対象範囲、目的、制約、完了条件、変更権限を含める。

| 系統 | エージェント | モデル / effort | 担当範囲 |
| --- | --- | --- | --- |
| Research | `research-worker-luna` | Luna / medium | 明確な論点について、情報収集、照合・分析、根拠付き報告まで行う |
| Research | `research-worker-terra` | Terra / high | 複雑な仕様、版差、資料間の矛盾を含む論点を同じ範囲で完遂する |
| Research | `research-worker-sol` | Sol / high | 高リスクまたは難解な論点で、反証、適用条件、不確実性まで分析する |
| Implementation | `implementation-worker-luna` | Luna / medium | 方針と受入条件が明確な担当範囲で、コード調査、局所設計、実装、検証まで行う |
| Implementation | `implementation-worker-terra` | Terra / high | 通常の変更・レビュー・原因調査を担当範囲内で完遂する |
| Implementation | `implementation-worker-sol` | Sol / high | 複雑な局所設計、構造改善、高リスクな変更またはレビューを担当する |

コードの原因調査とコードレビューは、書き込みを伴わなくても Implementation 系で扱う。調査のみ、レビューのみ、変更可のいずれにするかは、worker の種類ではなく依頼ごとの権限で限定する。

調査・仮説立案 parent は Research worker を主力として、論点、候補、情報源群などの独立した成果単位へ複数分担する。Implementation worker は実現性の確認や承認済みの最小試作に使い、通常は 1〜2 件を目安とする。この数は固定上限ではない。read-onlyの調査parentからは変更禁止の実現性確認までとし、試作は承認後にメイン経由の実装parentへ引き継ぐ。

設計・実装・案件救援 parent は Implementation worker を主力として、機能、責務、ディレクトリなどの独立した変更境界へ複数分担する。Research worker は、対象バージョンに対応した公式仕様、移行手順、既知の制約を確認するために必要時だけ使う。フォーラム等の二次情報は補助証拠とし、公式仕様と区別したうえでコードまたは再現結果で確認する。

ディレクトリで分ける場合も、相互依存が強い範囲は並列化しない。`dir_a` と `dir_b` のように、担当範囲ごとに調査から成果物・検証までを任せる。1 URL、単一ファイル、reader / writer などの工程だけを理由に worker を分けない。

50 件程度の Web 調査は総量であり、同時起動数ではない。実行時に利用可能な枠で段階的に処理し、各段階で parent が根拠・不足・矛盾を統合する。エスカレーション時は新規 worker の起動を止め、advisor 用の枠を確保する。書き込みは、所有範囲と受入条件が明確で相互依存しない変更境界だけ並列化する。

## 運用上の変更と管理範囲

- worker は Research / Implementation の2系統と、Luna / Terra / Sol の3能力帯で構成する。旧12種類の細分化した child 定義は互換性を維持せず削除し、parent 9 定義、worker 6 定義、advisor 1 定義の合計16定義とする。
- Codex 固有の規約の正本は `.chezmoitemplates/agent/codex/` に置く。共有する Claude 本文は変更せず、Codex のみで親子・顧問の振る舞いを追加する。
- `config.toml` は chezmoi 管理外である。このリポジトリの変更だけでは、メインの Luna 化、`max_depth`、同時実行枠は適用されない。設定する場合は手元の `~/.codex/config.toml` で別途検証する。chezmoi source から旧定義を削除しても、既存の適用先ファイルが自動削除されるとは限らないため、本番適用時に対象を明示して別途確認する。

## 旧定義からの移行（本番適用時）

1. 適用先の `~/.codex/agents/` と各プロジェクトの `.codex/agents/` を確認し、下表の旧名を参照する指示・設定を新workerへ置き換える。プロジェクト固有定義を無条件に削除しない。
2. 新16定義とAGENTS・ガイドのchezmoi差分を確認して適用する。表示・起動を確認するまでは旧ファイルを復元可能な状態で保管する。
3. 下表に一致する配布済み旧ファイルだけを、ローカル変更の有無と移行完了を確認して明示的に除去する。ディレクトリ全体の削除やexact管理への変更は行わない。このPRでは実行しない。

| 旧ファイル名（agents配下） | 移行先の目安 |
| --- | --- |
| `web-researcher.toml` | `research-worker-luna` |
| `research-analyst.toml` | `research-worker-terra` |
| `file-reader.toml` | コードはImplementation、外部資料はResearchから能力帯を選ぶ |
| `investigator.toml` | `implementation-worker-terra`（調査のみ） |
| `implementer.toml` | `implementation-worker-terra` |
| `implementer-sol.toml` | `implementation-worker-sol` |
| `refactorer.toml` | `implementation-worker-sol` |
| `security-reviewer.toml` | コードはImplementation、外部要件はResearchのSol帯（レビューのみ） |
| `doc-writer.toml` | `implementation-worker-terra` |
| `doc-checker.toml` | `implementation-worker-luna`（レビューのみ） |
| `lint-fixer.toml` | `implementation-worker-luna` |
| `test-runner.toml` | `implementation-worker-luna`（検証のみ） |

この表は旧依頼の移行用であり、今後も工程単位でworkerを起動する推奨ではない。小さな確認はparentで行い、まとまった担当成果の一部として必要な工程をworkerに含める。

## 検証と参照

chezmoi v2.70.3で16定義の展開・TOML解析、必須項目、階級とモデル、表示候補のASCII制約と重複、9 parent / 7 leafの分類と委譲先、2ガイドの展開、Claudeへの規約混入がないことを確認した。旧ロール名への実行用参照が残っていないことも展開結果で確認した。実アプリの起動・表示・消費量は未検証。

- [公式Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [表示候補の検証処理](https://github.com/openai/codex/blob/main/codex-rs/agent-roles/src/agent_role_config.rs)

表示名候補は半角英数字・空白・ハイフン・アンダースコアに限定する。候補数は同時実行枠を設定しない。指示による階層と権限は実行環境の制約を上書きしない。
