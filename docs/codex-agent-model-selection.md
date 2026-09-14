# Codex エージェント編成とモデル選択

## 方針と正本

[設計コンセプトと管理方針](codex-subagents.md)を参照。起点の正本は `dot_codex/common/root-agent.md.tmpl`、階層・起動・権限は `dot_codex/common/sub-agent.md.tmpl`、parent/childの共通本文は `.chezmoitemplates/agent/codex/`、assistantの本文は専用TOMLに置く。本文をここへ重複掲載しない。

起点は全体の目的・依存関係・成果統合を保持し、重い実作業はparentへ渡す。明確な情報処理は起点直轄のassistantへ委任する。直接処理はchild利用の費用も含めてparentへの依頼・回収未満で終わる場合だけ。parentは局所的なユーザー確認を直接行い、原指示からの変更を応答書へ記録する。

## 全体ツリー

全19定義（parent 10・worker 7・advisor 1・assistant 1）。同一ロールの複数起動は実行時の条件・上限に従い、全枝の常時起動は要求しない。

```text
メイン（Terra/highを第一試行候補：全体調整・案件状態・成果統合）
├─ assistant-L（Luna low）：起点直轄の要約・検索・抽出・変換、再委譲なし
├─ 一般調査 parent
│  research-lead（1Lt / Terra high）/ research-lead-H（Maj / Sol high）
│  ├─ Research worker：主力。論点・候補・情報源群ごとに調査・分析
│  ├─ Implementation worker：補助。実現性確認、変更禁止
│  └─ advisor（Col / Astra medium）：難所の分析
├─ 高度調査・仮説立案 parent
│  advanced-research-lead（Col / Astra medium）
│  ├─ Research worker：主力。希少事例・反証・組織制約の検討
│  ├─ Implementation worker：補助。技術的実現性確認、変更禁止
│  └─ advisor（Col / Astra medium）：独立した反証
├─ 金融・市場分析 parent
│  finance-lead（Maj / Sol high）
│  ├─ market-data-worker-L（2Lt / Luna medium）：数値取得・品質確認
│  ├─ Research worker：決算・開示・企業・マクロ・政治・市場反応の分析
│  └─ advisor（Col / Astra medium）：難所の分析
├─ 設計 parent
│  architect（Maj / Sol high）
│  ├─ Implementation worker：コード構造・局所設計・反証、変更禁止
│  ├─ Research worker：外部仕様・制約の確認
│  └─ advisor（Col / Astra medium）：難所の分析
├─ 設計・実装 parent
│  implementation-lead（1Lt / Terra high）/ implementation-lead-H（Maj / Sol high）
│  ├─ Implementation worker：主力。独立した機能・ディレクトリの変更・検証
│  ├─ Research worker：補助。対象版の公式仕様・移行手順の確認
│  └─ advisor（Col / Astra medium）：難所の分析
├─ 案件救援・構造改善 parent
│  recovery-lead（Maj / Sol high）
│  ├─ Implementation worker：主力。現状調査・合意済み方針の改善・検証
│  ├─ Research worker：補助。外部仕様・既知の制約の確認
│  └─ advisor（Col / Astra medium）：難所の分析
└─ レビュー・コード原因調査 parent
   review-lead（1Lt / Terra high）/ review-lead-H（Maj / Sol high）
   ├─ Implementation worker：主力。独立した範囲の調査・レビュー、変更禁止
   ├─ Research worker：補助。判断根拠となる外部仕様の確認
   └─ advisor（Col / Astra medium）：難所の分析

上記で共有するworkerの能力帯（parentが担当範囲の難易度から選択）
Research worker
├─ research-worker-L（2Lt / Luna xhigh）
├─ research-worker-M（1Lt / Terra high）
└─ research-worker-H（Maj / Sol high）
Implementation worker
├─ implementation-worker-L（2Lt / Luna xhigh）
├─ implementation-worker-M（1Lt / Terra high）
└─ implementation-worker-H（Maj / Sol high）
```

assistant/worker/advisorは末端で再委譲しない。parentは別parentを配下に置かない。起点直轄childは直接処理の条件を満たす例外のみ。

## モデルとeffort

| 担当 | 設定・試行方針 |
| --- | --- |
| 起点 | Terra/highを第一試行候補。判断不足が残ればxhigh、またはSolと比較。ロールファイルから起点のモデルは変更しない |
| assistant-L | Luna/low。条件が明確な情報処理に限定する試行値。汎用workerのxhighとは用途を区別 |
| 汎用worker-L | Luna/xhighを維持 |
| worker-M | Terra/highを維持 |
| worker-H | Sol/highを維持 |
| market-data-worker-L | Luna/mediumを維持 |
| parent / advisor | 下表・TOMLの既存設定を維持 |

起点highの根拠と限界は[コンセプト文書](codex-subagents.md#起点のモデル)を参照。モデル間・effort間の同等性や総消費削減は保証しない。案件全体の手戻りとユーザー介入を含めて評価する。

表示は `正式ロール--モデル略称--番号`。番号は個体識別用であり、モデル適用の証明ではない。階級表示は2Lt=Luna、1Lt=Terra、Maj=Sol、Col=Astraで、親子関係とは別。正式ロールと提示された起動仕様を使い、利用不可のロールをdefaultで代用しない。

## parent の選択

| 案件 | 基本候補と採用条件 | 判断が複雑な場合 | parent の責任 |
| --- | --- | --- | --- |
| 金融・市場分析 | `finance-lead`（Sol / high） | `advisor` に限定相談 | 数値取得条件を定め、決算・開示・市場反応と時点・仮説を統合する |
| 一般調査 | `research-lead`（Terra / high。問いと比較軸が明確で、探索・速度にTerraを採る理由がある場合） | `research-lead-H`（Sol / high） | 公式情報・利用者の観測を比較し、条件付きの結論と未確認事項を統合する |
| 高度調査・仮説立案 | `advanced-research-lead`（Astra / medium） | 同じ parent が `advisor` に独立反証を依頼 | 希少事例や組織制約下で、代替策、成立条件、残余リスク、見直し条件を示す |
| 設計のみ | `architect`（Sol / high） | `advisor` に限定相談 | 設計判断と実装単位・受入条件を定める。実装はメイン経由で引き継ぐ |
| 設計・実装 | `implementation-lead`（Terra / high。範囲内の探索・判断にTerraを採る理由がある場合） | `implementation-lead-H`（Sol / high） | 合意済み要件を具体化し、実装、結合、受入検証を統合する |
| 案件救援・構造改善 | `recovery-lead`（Sol / high） | `advisor` に限定相談 | 現状・問題・改善候補を整理し、ユーザーが決めた方針を実行・検証する |
| 技術レビュー・コード原因調査（報告のみ） | `review-lead`（Terra / high。探索・速度にTerraを採る理由がある場合） | `review-lead-H`（Sol / high） | 根拠、重大性、推奨対応を評価する |

高度調査parentはread-onlyで調査・仮説更新に専念する。プロトタイプは仮説と終了条件をメインへ返し、承認後にメイン直轄の実装parentへ引き継ぐ。結果は同じ高度調査parentへ戻す。

設定変更や文書作成は `implementation-lead` / `implementation-lead-H` が扱う。

`advanced-research-lead` と `advisor` の Astra / `medium` は試行値である。通常の案件救援は Sol を開始点とし、Astra を既定にしない。

## worker の役割と parent からの使い分け

worker は工程を分けるための小さな役ではない。parent は、十分な作業量があり、他の担当範囲と独立して進め、まとまった成果として検証できる単位だけを委譲する。依頼には対象範囲、目的、制約、完了条件、変更権限を含める。

| 系統 | エージェント | モデル / effort | 担当範囲 |
| --- | --- | --- | --- |
| Market Data | `market-data-worker-L` | Luna / medium | 定義済みの市場数値を取得・正規化・品質確認する。解釈はparentへ返す |
| Research | `research-worker-L` | Luna / xhigh | 方針、範囲、受入条件が明確な論点について、情報収集、照合・分析、根拠付き報告まで行う |
| Research | `research-worker-M` | Terra / high | 探索、判断、速度などTerraを採る理由が明確な論点を同じ範囲で完遂する |
| Research | `research-worker-H` | Sol / high | 高リスクまたは難解な論点で、反証、適用条件、不確実性まで分析する |
| Implementation | `implementation-worker-L` | Luna / xhigh | 方針、範囲、受入条件が明確な担当範囲で、コード調査、局所設計、実装、検証まで行う |
| Implementation | `implementation-worker-M` | Terra / high | 探索、判断、速度などTerraを採る理由が明確な変更・レビュー・原因調査を完遂する |
| Implementation | `implementation-worker-H` | Sol / high | 複雑な局所設計、構造改善、高リスクな変更またはレビューを担当する |

コードの原因調査とコードレビューは、書き込みを伴わなくても Implementation 系で扱う。調査のみ、レビューのみ、変更可のいずれにするかは、worker の種類ではなく依頼ごとの権限で限定する。

調査・仮説立案 parent は Research worker を主力として、論点、候補、情報源群などの独立した成果単位へ複数分担する。Implementation worker は実現性の確認や承認済みの最小試作に使い、通常は 1〜2 件を目安とする。この数は固定上限ではない。read-onlyの調査parentからは変更禁止の実現性確認までとし、試作は承認後にメイン経由の実装parentへ引き継ぐ。

設計・実装・案件救援 parent は Implementation worker を主力として、機能、責務、ディレクトリなどの独立した変更境界へ複数分担する。Research worker は、対象バージョンに対応した公式仕様、移行手順、既知の制約を確認するために必要時だけ使う。フォーラム等の二次情報は補助証拠とし、公式仕様と区別したうえでコードまたは再現結果で確認する。

ディレクトリで分ける場合も、相互依存が強い範囲は並列化しない。`dir_a` と `dir_b` のように、担当範囲ごとに調査から成果物・検証までを任せる。1 URL、単一ファイル、reader / writer などの工程だけを理由に worker を分けない。

50 件程度の Web 調査は総量であり、同時起動数ではない。実行時に利用可能な枠で段階的に処理し、各段階で parent が根拠・不足・矛盾を統合する。エスカレーション時は新規 worker の起動を止め、advisor 用の枠を確保する。書き込みは、所有範囲と受入条件が明確で相互依存しない変更境界だけ並列化する。

## 金融分析とデータ取得

金融parentは対象、市場、通貨、期間、時間足、調整、許容鮮度、必要ならEPS/PERの定義を決める。DataとResearchを独立したまとまりで並行させ、少量なら自分で取得する。金融知識を要する解釈と、条件確定後の数値取得を分けることでDataを軽量化する。量だけでモデルを上げない。

[市場データ取得台帳](../dot_codex/common/market-data-sources.md.tmpl)を `~/.codex/common/market-data-sources.md` に配布する。日米株OHLC、為替、原油・金先物、暗号資産、日米国債金利の取得経路、認証条件、品質確認、実測記録を保持し、毎回の取得先探索を避ける。契約が必要なJ-Quants/FREDは資料確認までと明示する。データとキャッシュは配布しない。

Data workerと金融parentはsandboxを固定せず実行環境の権限を継承する。許可された場所で取得結果・キャッシュを作れるが、プロジェクト本体やグローバル環境の変更は担当外とする。Research workerは既存のread-onlyを維持する。

## 管理範囲

`config.toml` はchezmoi管理外。起点のTerra/high設定、同時実行枠、深さはこの変更では適用しない。新assistantと共通規約はsourceに追加・更新したが、実環境への配布と実起動確認は別作業。Claude用本文は変更しない。

## 旧定義からの移行（本番適用時）

1. 適用先の `~/.codex/agents/` と各プロジェクトの `.codex/agents/` を確認し、下表の旧名を参照する指示・設定を新workerへ置き換える。プロジェクト固有定義を無条件に削除しない。
2. 新18定義とAGENTS・ガイドのchezmoi差分を確認して適用する。表示・起動を確認するまでは旧ファイルを復元可能な状態で保管する。
3. 下表に一致する配布済み旧ファイルだけを、ローカル変更の有無と移行完了を確認して明示的に除去する。ディレクトリ全体の削除やexact管理への変更は行わない。実環境の整理は別途明示的な指示で行う。

| 旧ファイル名（agents配下） | 移行先の目安 |
| --- | --- |
| `web-researcher.toml` | `research-worker-L` |
| `research-analyst.toml` | `research-worker-M` |
| `file-reader.toml` | コードはImplementation、外部資料はResearchから能力帯を選ぶ |
| `investigator.toml` | `implementation-worker-M`（調査のみ） |
| `implementer.toml` | `implementation-worker-M` |
| `implementer-sol.toml` | `implementation-worker-H` |
| `refactorer.toml` | `implementation-worker-H` |
| `security-reviewer.toml` | コードはImplementation、外部要件はResearchのSol帯（レビューのみ） |
| `doc-writer.toml` | `implementation-worker-M` |
| `doc-checker.toml` | `implementation-worker-L`（レビューのみ） |
| `lint-fixer.toml` | `implementation-worker-L` |
| `test-runner.toml` | `implementation-worker-L`（検証のみ） |

PR途中の `data-worker-luna.toml` を既に適用した場合も、`market-data-worker-L.toml` へ参照を更新し、旧ファイルを個別確認して整理する。

この表は旧依頼の移行用であり、今後も工程単位でworkerを起動する推奨ではない。小さな確認はparentで行い、まとまった担当成果の一部として必要な工程をworkerに含める。

## 今回の検証（2026-09-14）

chezmoiは実行せず、sourceで使用しているincludeとreplaceを静的に解決してPython 3.14のtomllibで全19定義を解析した。parent 10・worker 7・advisor 1・assistant 1、表示候補220個の文字種と重複なし、全parentへの応答書規約の組み込み、共通ガイドの参照、ローカル文書リンク、git diff --checkを確認した。初回の検査器は既存architectのreplace構文に未対応だったため、同構文を検査対象に加えて再確認した。

これはchezmoi自体の展開検証の代替保証ではない。標準CIによるchezmoi展開、配布先更新、実起動・直接対話・待機回収・消費量の検証は未実施。起点のモデル設定も変更していない。既存CIはglobで全定義を対象とするため、新assistantも対象に含まれる。

## 過去の検証記録と参照

委任識別規定の更新では、chezmoi v2.69.4で18定義の展開とTOML解析、216個の表示候補のロール・モデル一致と重複なし、全定義への位置確認規定の展開、AGENTSと委任ガイドの展開、`git diff --check` を確認した。更新した18ロールの実起動・候補表示は未検証であり、配置先への適用もこの検証には含めない。

chezmoi v2.70.3で18定義の展開・TOML解析、必須項目、階級とモデル、表示候補のASCII制約と重複、10 parent / 8 leafの分類と委譲先、AGENTSと2共通ガイドの展開、Claudeへの規約混入がないことを確認した。旧ロール名への実行用参照が残っていないことも展開結果で確認した。実アプリの起動・表示・消費量は未検証。

- [公式Subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [表示候補の検証処理](https://github.com/openai/codex/blob/main/codex-rs/agent-roles/src/agent_role_config.rs)

表示名候補は半角英数字・空白・ハイフン・アンダースコアに限定する。候補数は同時実行枠を設定しない。指示による階層と権限は実行環境の制約を上書きしない。

### 能力帯によるロール名の短縮

モデル名付きのロール接尾辞をLuna→L、Terra→M、Sol→Hに変更する。モデル設定と推論量は変更しない。表示例は `research-worker-L--luna--01`、task_nameは `research_worker_l__luna`。モデル名を含まないロールは維持する。

適用済み環境では旧名のエージェントTOMLが残る可能性があるため、名前変更の対応を確認して別途整理する。今回のsource変更では配布先の旧ファイルは削除しない。
