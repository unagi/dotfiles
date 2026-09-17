# Codex エージェント編成とモデル選択

## 方針と正本

[設計コンセプトと管理方針](codex-subagents.md)を全体方針の正本とする。起点の正本は`dot_codex/common/root-agent.md.tmpl`、階層・起動・権限は`dot_codex/common/sub-agent.md.tmpl`、parentの共通本文と専用本文は`.chezmoitemplates/agent/codex/`、モデル・表示名は`dot_codex/agents/*.toml.tmpl`に置く。この文書は、現行19定義の構成、テンプレート適用関係、起点選択、workerの使い分けを説明する。

起点の現行運用はSol/lowである。起点は全体の目的、制約、担当選択、依存関係、全体調整、成果統合を保持する。背景の継続参照が必要なら起点が直接扱い、選別した背景を指示書へ含めて業務が成立するなら、規模が小さくてもparentを優先する。同じSol/lowでも文脈を分離する価値を評価する。`config.toml`はchezmoi管理外のため、このsourceから起点モデル、同時実行枠、深さは変更しない。

## 全体構造

現行sourceのサブエージェントは19定義（parent 10、worker 7、advisor 1、assistant 1）である。起点は定義数に含めない。parentはSol 6、Astra 3、Terra 1で構成し、Luna parentは定義しない。

```text
メイン（Sol/low：全体調整・案件状態・成果統合）
├─ assistant-L（Luna/low）：明確な要約・検索・抽出・変換、再委譲なし
├─ Sol parent
│  ├─ architect（Sol/medium）
│  ├─ finance-lead（Sol/high）
│  ├─ implementation-lead-H（Sol/low）
│  ├─ implementation-lead-complex（Sol/medium）
│  ├─ research-lead-H（Sol/low）
│  └─ research-lead-complex（Sol/medium）
├─ Astra parent
│  ├─ advanced-research-lead（Astra/medium）
│  ├─ recovery-lead（Astra/low）
│  └─ review-lead-astra（Astra/low）
└─ Terra parent
   └─ research-lead（Terra/high）：単純広域調査

共有worker
├─ Research：research-worker-L / research-worker-M / research-worker-H
├─ Implementation：implementation-worker-L / implementation-worker-M / implementation-worker-H
└─ Market Data：market-data-worker-L

advisor（Astra/medium）：起点、Sol parent、Astra parentから必要時だけ相談
```

`-H`はSol帯を示す名称であり、parentのeffortがhighであることを意味しない。今回の一般調査・実装では、通常業務を`research-lead-H` / `implementation-lead-H`（Sol/low）で扱い、high effortの同系統parentは不足確認後の候補とする。一般調査・実装用のhigh parentは今回増設しない。

## TOMLと共通・専用テンプレートの適用

10 parent TOMLはすべて`parent.md`を共通本文として読み込む。`parent-advanced.md`のファイル名は維持するが、本文見出しはSol/Astra parent共通へ変更し、高度業務専用を意味しない。Sol/lowやAstra/lowのparentにも適用する。`parent-survey.md`はTerraの`research-lead`だけが読み込む。`research.md`は`research-lead`、`research-lead-H`、`research-lead-complex`、`advanced-research-lead`、`finance.md`は`finance-lead`だけが読み込む。各TOMLが共通本文と専用本文を並列にincludeし、専用本文が別のparent本文を入れ子にincludeしない。

| TOML | model / effort | 共通本文 | 専用本文 | 役割 |
| --- | --- | --- | --- | --- |
| `architect` | Sol / medium | `parent.md` | `parent-advanced.md` | 設計判断。実装は行わない |
| `finance-lead` | Sol / high | `parent.md` | `parent-advanced.md` + `finance.md` | 市場数値とResearch成果の統合 |
| `implementation-lead-H` | Sol / low | `parent.md` | `parent-advanced.md` | 通常の設計・実装・検証 |
| `implementation-lead-complex` | Sol / medium | `parent.md` | `parent-advanced.md` | 曖昧前提・矛盾・難しい設計の実装統合 |
| `research-lead-H` | Sol / low | `parent.md` | `parent-advanced.md` + `research.md` | 通常調査：比較・解釈・局所判断 |
| `research-lead-complex` | Sol / medium | `parent.md` | `parent-advanced.md` + `research.md` | 曖昧前提・矛盾を含む一般調査 |
| `advanced-research-lead` | Astra / medium | `parent.md` | `parent-advanced.md` + `research.md` | 高度調査・仮説立案 |
| `recovery-lead` | Astra / low | `parent.md` | `parent-advanced.md` | 案件救援・構造改善 |
| `review-lead-astra` | Astra / low | `parent.md` | `parent-advanced.md` | 高リスクレビュー・難しい原因分析 |
| `research-lead` | Terra / high | `parent.md` | `parent-survey.md` + `research.md` | 単純広域調査。Luna childのみ |

専用TOMLの`model`と`model_reasoning_effort`が実際の設定を決める。本文中のモデル自己認識でparentやworkerの起動先・権限・effortを切り替えない。起点の選択規則は`root-agent.md.tmpl`を正本とし、parent本文から再定義しない。

## 起動権限

| 起動者 | 起動できる担当 | 運用条件 |
| --- | --- | --- |
| 起点（Sol/low） | 上記10 parent、7 worker、`advisor`、`assistant-L` | 背景と全体判断を起点に残す。直接childを使う場合もSol/Astra parentと同じL優先・理由付きM・H例外の基準を使う |
| Sol parent | 7 worker、`advisor` | Lを中心に複数の独立範囲へ分担する。Mは採用理由が明確な場合に使う。H childが1件だけなら原則自処理と比較し、具体的な効果がある場合だけ例外として使う |
| Astra parent | 7 worker、`advisor` | 難所を自身で保持し、L中心で分担する。advisorは独立反証や限定分析に限る |
| `research-lead`（Terra） | `research-worker-L`、`implementation-worker-L`（変更禁止の調査）、`market-data-worker-L` | 単純広域調査を複数Lunaへ分担する。M、H、`advisor`、他のparent、assistantは起動しない |
| assistant、worker、advisor | なし | 再委譲しない |

parentは別のparentを配下に置かない。H childが複数必要な場合を一律に禁止しないが、各担当の独立性、具体的な効果、parent自身の並走作業を依頼に残す。解消できない矛盾、方針変更が必要な難所、重要な未確認事項は根拠と試行結果を添えて起点へ返し、独立して続けられる調査は継続する。

## 規模・難度・背景による選択

### 第1段階：背景と文脈分離

| 背景の確認 | 方針 |
| --- | --- |
| 後続判断まで背景を継続参照する必要がある | 起点が直接扱う |
| 背景を選別した指示書だけで業務が成立する | 小規模でもparentを優先し、文脈分離の価値を取る |
| ごく短く、背景の継続参照も不要 | 起点またはparent自身で処理し、委任準備と比較する |

### 第2段階：難度と規模

規模と難度は別軸で起動前に評価し、下見や調査結果に応じて見直す。媒体名や件数だけで能力帯を決めず、調査対象、予測される読解量、探索の広がり、比較数、返却量、前提の曖昧さ、矛盾の有無を合わせて判断する。

| 難度 \\ 規模 | 小 | 中 | 大 |
| --- | --- | --- | --- |
| 単純調査 | Sol/low parent、または限定child | Sol/low parent＋必要なLuna。分担管理が主ならTerra/high | Terra/high parent＋複数Luna |
| 通常調査・実装 | `research-lead-H` / `implementation-lead-H`が比較・解釈・局所判断を担う | 同parentがL中心で独立範囲を分担 | 同parentがL中心で複数範囲を統合 |
| 難解 | `research-lead-complex` / `implementation-lead-complex` / `architect`が難所を保持 | 同complex parentがL中心、採用理由を明記したMを必要時に使用 | 同complex parentがL中心で分担し、判断を統合 |
| 高リスクレビュー・原因分析・案件救援 | `recovery-lead` / `review-lead-astra`が自処理 | Astra parentがL中心で分担し、必要時にadvisorへ相談 | Astra parentがL中心で分担し、独立反証やadvisorを必要時に使う |

小量でも第1段階で切り出せると判断した業務はparentを優先する。起点が起動前の判断難度に応じてlowまたはmediumの固定ロールを選び、lowでの失敗をmedium採用の前提にしない。Sol/high effortはmediumで不足する難所の比較候補であり、今回一般調査・実装用ロールは増設しない。childのHはSolというモデル帯を表し、effortと区別する。M/H childは局所範囲の必要能力で選び、量だけで引き上げない。H child単独の丸投げは原則避け、独立反証や別の難所の並行処理など具体的な効果がある場合に例外として扱う。

## 起点からの選択

| 起点で確認する条件 | 最初の選択 |
| --- | --- |
| 背景を後続判断まで継続参照する必要がある | 起点が直接扱う |
| 背景を選別した指示書だけで業務が成立する | 規模が小さくても該当parentを優先する |
| ごく短く、背景の継続参照も不要 | 起点またはparent自身。委任準備と比較する |
| 大量かつ条件が明確 | `research-lead`の複数Luna、またはSol/Astra parentのL中心分担 |
| 曖昧前提、矛盾、難しい設計がある | `research-lead-complex`、`implementation-lead-complex`、`architect`など該当parent |

parentのモデル・effortは起点が起動前に固定ロールから選ぶ。parentは調査対象、予測読解量、探索の広がり、比較数、返却量、必要な判断から、許可されたworkerロールと担当範囲を選ぶ。自身やworkerの固定effortは上書きしない。未知の範囲は限定的に下見し、解消不能な矛盾、方針変更、重要な未確認事項だけ起点へ返す。

## parentの選択

| 案件 | parent | 選択条件と責任 |
| --- | --- | --- |
| 単純広域調査 | `research-lead`（Terra/high） | 起点が問い、範囲、比較軸、終了条件を定め、複数Lunaでファイル群・Web情報源群を調査する価値がある場合 |
| 通常調査：比較・解釈・局所判断 | `research-lead-H`（Sol/low） | 仕様・事例を比較し、通常の矛盾と局所判断をparent自身が統合する |
| 曖昧前提・矛盾を含む一般調査 | `research-lead-complex`（Sol/medium） | 限定的な下見と比較軸を整え、難所の判断を保持する |
| 希少事例・組織制約下の高度調査 | `advanced-research-lead`（Astra/medium） | 仮説、代替策、成立条件、残余リスクを示し、必要時にadvisorへ独立反証を依頼する |
| 設計のみ | `architect`（Sol/medium） | 設計判断、実装単位、受入条件を定める。実装は別途引き継ぐ |
| 通常の設計・実装・設定変更・文書作成 | `implementation-lead-H`（Sol/low） | 合意済み要件を実装し、結合と受入検証を統合する |
| 曖昧前提・矛盾・難しい設計の実装 | `implementation-lead-complex`（Sol/medium） | 方針と共有境界を整理し、設計・実装・検証を統合する |
| 金融・市場分析 | `finance-lead`（Sol/high） | 数値取得条件、決算・開示・市場反応、時点、仮説を統合する |
| 案件救援・構造改善 | `recovery-lead`（Astra/low） | 現状、問題、合意済み方針、改善、検証を統合する |
| 高リスクレビュー・難しい原因分析（報告） | `review-lead-astra`（Astra/low） | 根拠、重大性、推奨対応を評価する。変更権限は別途付与しない |

通常調査・実装は、起動前に難度を判定してSol/lowまたはSol/mediumを選ぶ。lowの結果を待ってからmediumへ切り替える運用にはしない。highは不足確認後の比較候補とし、今回のsourceでは一般調査・実装のhigh effort parentを増設しない。親はeffortを勝手に変更せず、解消できない難所は起点へ返す。

## workerの選択

| 系統 | worker | 基本用途 | `research-lead`からの起動 |
| --- | --- | --- | --- |
| Research | `research-worker-L`（Luna/xhigh） | 条件が明確な論点の収集、照合、分析、報告 | 可。複数起動可 |
| Research | `research-worker-M`（Terra/high） | 探索・判断・速度など明確な採用理由がある論点 | 不可 |
| Research | `research-worker-H`（Sol/high） | 高リスク・難解な論点、独立反証 | 不可 |
| Implementation | `implementation-worker-L`（Luna/xhigh） | コードの明確な担当範囲。起点・Sol/Astra parentでは権限に応じて実装可、Terra parentでは調査のみ | 可。ただし変更禁止 |
| Implementation | `implementation-worker-M`（Terra/high） | 探索・判断を含む変更、レビュー、原因調査 | 不可 |
| Implementation | `implementation-worker-H`（Sol/high） | 複雑な局所設計、構造改善、高リスクな変更・レビュー | 不可 |
| Market Data | `market-data-worker-L`（Luna/medium） | 条件確定済みの市場数値取得・正規化・品質確認 | 可 |

Sol/Astra parentと起点の直接childでは、workerが担当範囲を調査または実装から検証まで完遂する。ResearchとImplementationは工程でなく、前提知識と成果の種類で選ぶ。parentはworkerの結論、根拠箇所、重要原文、適用条件、矛盾、未確認事項を受け取り、全資料の再読を前提にしない。`advisor`は儀礼的レビューに使わず、助言の採否と検証は起点またはparentが担う。

## 適用と廃止ロールの移行

現行sourceは19定義へ整理した。前回の`implementation-lead`と`review-lead`、および旧`review-lead-H`は現行起動で使用しない。廃止ロールが適用先で実行候補に残っていても、対応する現行ロールを使う。sourceから削除したファイルは、適用済みの`~/.codex/agents/`やプロジェクト固有のagents配下から自動削除されないため、参照とローカル変更を確認し、対象を明示した別作業で個別整理する。

| 旧ファイル名（agents配下） | 移行先・扱い |
| --- | --- |
| `implementation-lead.toml` | `implementation-lead-H`（Sol/low）または`implementation-lead-complex`（Sol/medium） |
| `review-lead.toml` | `review-lead-astra`（Astra/low） |
| `review-lead-H.toml` | `review-lead-astra`（Astra/low） |
| `research-lead-sol.toml` | `research-lead-H`（Sol/low）または`research-lead-complex`（Sol/medium） |
| `implementation-lead-sol.toml` | `implementation-lead-H`（Sol/low）または`implementation-lead-complex`（Sol/medium） |
| `review-lead-sol.toml` | `review-lead-astra`（Astra/low） |
| `research-worker-luna.toml`、`research-worker-terra.toml`、`research-worker-sol.toml` | `research-worker-L`、`research-worker-M`、`research-worker-H` |
| `implementation-worker-luna.toml`、`implementation-worker-terra.toml`、`implementation-worker-sol.toml` | `implementation-worker-L`、`implementation-worker-M`、`implementation-worker-H` |
| `market-data-worker-luna.toml`、`data-worker-luna.toml` | `market-data-worker-L` |
| `web-researcher.toml` | `research-worker-L` |
| `research-analyst.toml` | `research-worker-M` |
| `file-reader.toml` | コードはImplementation、外部資料はResearchから能力帯を選ぶ |
| `investigator.toml` | `implementation-worker-M`（調査のみ） |
| `implementer.toml` | `implementation-worker-M` |
| `implementer-sol.toml`、`refactorer.toml` | `implementation-worker-H` |
| `security-reviewer.toml` | コードはImplementation、外部要件はResearchのSol帯（レビューのみ） |
| `doc-writer.toml` | `implementation-worker-M` |
| `doc-checker.toml`、`lint-fixer.toml`、`test-runner.toml` | `implementation-worker-L`（必要な権限に限定） |

この表は既存参照の移行用であり、工程ごとのworker起動を推奨するものではない。廃止ロールの配布先削除、旧参照の変更、実環境への適用は別途明示的な指示に従う。

## 検証の扱い

今回の19定義への更新では、sourceを静的に展開してPython 3.14の`tomllib`で19 TOMLを解析し、parent 10（Sol 6 / Astra 3 / Terra 1）、worker 7、advisor 1、assistant 1、表示候補220個の文字種・モデル表記・重複なし、指定されたmodel/effort、read-only条件、廃止ロール参照の不在、各TOMLのinclude適用、worker・advisor・assistantの既存model/effort維持、Claude/CI側の未変更を確認した。これはsourceの静的検査に限る。chezmoi、CI、実起動、表示候補の実環境適用、禁止された起動の実行時強制、直接対話、待機回収、消費評価は成功として記載しない。前回17定義の検証は過去記録として扱い、今回の19定義へ流用しない。

検証時は、次を分けて確認する。

1. 静的検査：19 TOMLの展開・構文、必須項目、model/effort、nickname候補の文字種と重複、parent 10・worker 7・advisor 1・assistant 1の分類、TOMLと専用本文の適用、parentごとの起動権限、廃止ロール参照の不在、Claudeへの規約混入。
2. 実行時検査：実際の候補表示とモデル適用、起動可能・禁止ロール、parent配下のparent禁止、child・assistant・advisorの再委譲禁止、モデル自己認識による切替えがないこと、直接対話、待機・回収、権限境界。
3. 運用評価：Sol/low起点で同等案件を比較し、背景の継続参照、指示書の文脈分離、parent・child全体の総消費、手戻り、ユーザー介入、完了時間、H child 1件委任の発生と具体的効果を記録する。未取得の数値やキャッシュ効果は推測しない。

## 過去の検討と検証記録

以下は現行19定義を検証した記録ではない。

- `2e8553b`（2026-05-01）は、設計・高リスクレビュー・構造改善をSol、実装・深い調査をTerra、単一ファイル・lint・テストをLunaへ割り当てる松竹梅方針を追加した。`4885467`（2026-08-30）はこれをGPT-5.6のSol/Terra/Lunaへ対応付けた。
- `ca16ea2`（2026-09-07）は、起点→parent→child/advisorの階層と案件難度に応じたparent選択を追加した。`febdee4`は工程別childをResearch/Implementationの能力帯workerへ整理し、独立した成果単位を委任条件にした。
- `974a8f4`（2026-09-10）は、汎用Luna workerのxhighを未実測・可逆な運用仮説として導入し、Terraは採用理由がある場合に限定した。`abffaf7`（2026-09-13）はモデル・effortを変えず、ロール接尾辞をL/M/Hへ短縮した。
- `86388ef`（2026-09-14）の静的記録は旧19定義（parent 10、worker 7、advisor 1、assistant 1）を対象に、include/replaceの静的解決、Python `tomllib`、表示候補220個、分類、リンク、`git diff --check`を確認したものだった。実起動、配布先更新、直接対話、待機回収、消費量は未検証であり、現行19定義へ引き継がれない。
- 前回17定義の静的検証は前回作業の記録として扱う。今回追加したcomplex parent、effort変更、`review-lead-astra`、新しい起動権限を含まないため、現行19定義の検証結果にはしない。

モデル間・effort間の同等性や品質・価格の優劣は、この文書から保証しない。表示名の番号は個体識別用で、モデル適用や回答品質の証明ではない。
