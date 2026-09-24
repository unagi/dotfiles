# Codexエージェントの編成とモデル選択

## 正本と適用範囲

[設計コンセプト](codex-subagents.md)を全体方針の説明、`dot_codex/common/root-agent.md.tmpl`を起点の行動規範、`dot_codex/common/sub-agent.md.tmpl`を階層・権限・起動・記録境界の正本とする。parentの共通本文と専用本文は`.chezmoitemplates/agent/codex/`、モデルと表示名は`dot_codex/agents/*.toml.tmpl`が正本である。

現行方針の確認日は2026-09-24。sourceはサブエージェント19定義（parent 9、worker 7、advisor 2、assistant 1）を管理する。起点モデルを含む`config.toml`はchezmoi管理外である。起点の責務は自身のモデル・effortの認識に依存せず、実環境の設定・配布は別作業である。

## 現行編成

```text
起点（ルーティング。モデル・effortの自己認識は不要）
├─ assistant-L（GPT-6 Luna/low）
├─ root-advisor（GPT-6 Sol/medium、起点専属）
├─ parent 9
│  ├─ Sol 6: architect, finance-lead, implementation-lead-H,
│  │         implementation-lead-complex, research-lead-H,
│  │         research-lead-complex
│  └─ Astra 3: advanced-research-lead, recovery-lead,
│             review-lead-astra
├─ worker 7
│  ├─ Luna/xhigh 4: Research/ImplementationのL・M
│  ├─ Luna/medium 1: market-data-worker-L
│  └─ Sol/high 2: Research/ImplementationのH
└─ advisor（GPT-6 Astra/medium、専門難所の反証・再分析）
```

parentはSol/Astraに限定し、Lunaは再委任しないassistant・workerとして使う。単純広域調査は `research-lead-H` に統合する。廃止した `research-lead` が実行時に残っていても起動しない。

| 定義 | モデル / effort | 主な用途 |
| --- | --- | --- |
| `assistant-L` | GPT-6 Luna / low | 起点・parent専属の検索、限定読解、抽出、要約、差分整理 |
| `root-advisor` | GPT-6 Sol / medium | 起点の依頼先選択、履歴抽出、不足・過剰制約の点検 |
| `advisor` | GPT-6 Astra / medium | 起点またはSol/Astra parentの専門難所の反証・再分析 |
| `architect` | GPT-6 Sol / medium | 設計判断。実装しない |
| `finance-lead` | GPT-6 Sol / high | 市場数値、開示、仮説の統合 |
| `implementation-lead-H` | GPT-6 Sol / low | 通常実装、設定変更、文書作成、結合検証 |
| `implementation-lead-complex` | GPT-6 Sol / medium | 設計変更や強い依存関係を伴う実装 |
| `research-lead-H` | GPT-6 Sol / low | 単純広域調査と、比較・解釈・局所判断を含む通常調査 |
| `research-lead-complex` | GPT-6 Sol / medium | 曖昧な前提、競合仮説、矛盾を含む調査 |
| `advanced-research-lead` | GPT-6 Astra / medium | 希少事例や組織制約下の高度調査 |
| `recovery-lead` | GPT-6 Astra / low | 案件救援と合意済み改善 |
| `review-lead-astra` | GPT-6 Astra / low | 高リスクレビューと難しい原因分析 |
| `research-worker-L` | GPT-6 Luna / xhigh | 条件が明確なResearch成果単位 |
| `research-worker-M` | GPT-6 Luna / xhigh | Lより探索・局所判断を多く要するResearch成果単位 |
| `research-worker-H` | GPT-6 Sol / high | 複雑な局所判断を含むResearch成果単位 |
| `implementation-worker-L` | GPT-6 Luna / xhigh | 条件が明確なImplementation成果単位 |
| `implementation-worker-M` | GPT-6 Luna / xhigh | Lより探索・局所判断を多く要するImplementation成果単位 |
| `implementation-worker-H` | GPT-6 Sol / high | 複雑な局所判断を含むImplementation成果単位 |
| `market-data-worker-L` | GPT-6 Luna / medium | 定義済み市場数値の取得・正規化・品質確認 |

L/M/Hは担当範囲の能力帯であり、モデル名やeffortの略ではない。GPT-6移行後はLとMが同じLuna/xhighを使う。Lは条件が明確な範囲、Mは探索・局所判断がより多い範囲として使い分ける。HはSolを使うが、接尾辞はhigh effortを意味しない。

## 起点の通常責務と例外

通常の起点は、全履歴の保持と必要な原文の切り抜き、parent報告の要約と必須の詳細リンク、軽微な求めへの早期回答を担う。切り抜き判断は起点に認める。自身またはLunaアシスタントで早期回答できない、または満足を得られなければ、parentへの委任をユーザーに確認し、委任または取りやめに従う。既に明示承認された委任は再確認しない。

ユーザーが起点自身にparent相当の対応を明示した範囲では、起点が検討・判断・統合を担い、細かな作業をLunaアシスタントへ渡せる。この例外は自己判断で開始せず、以後の依頼へ恒常化しない。起点のモデル・effortを推測・確認することは通常責務にも例外にも不要である。

## 起点の相談先

`root-advisor`は起点専属であり、承認された委任のルーティングを補助する。相談は委任承認の代わりにはならない。起点が依頼先、履歴から渡す原文抜粋、ユーザー確認の要否を自信を持って決められない場合や、起点の解釈がゴールを狭めるおそれがある場合に、失敗前から相談する。原文の要約・言い換え・目的解釈は作らず、専門案件の代行、実装、承認、追加委任は行わない。

既存の`advisor`はAstra/mediumを維持する。専門的な前提の誤り、代替仮説、反証、検証方法を扱い、起点専用のルーティング相談とは分ける。Sol/Astra parentは`advisor`を使えるが、`root-advisor`は使えない。

## parentへの入力と業務報告書

起点は、きっかけとなったユーザーの最終発言と、それに至る経緯、訂正、承認、却下理由、未決事項を全履歴から広めに選び、原文抜粋のままparentへ渡す。要約・言い換え・起点独自の目的解釈は付加しない。会話由来の禁止事項・承認範囲も原文抜粋で渡し、担当ロール、権限、依存関係、資料の所在だけを別のメタデータとして添える。

コンパクション等で原文が残っていない場合は、保存済みの状態・報告・会話要約を「原文ではない残存記録」と明示する。原文らしく復元・補完せず、欠落が判断を変える場合は確認へ戻す。

目的の専門的な解釈、非機能要件、設計方針、受入条件、検証方法はparentがロール規範、プロジェクトの`AGENTS.md`、既存成果を基に具体化する。起点は一般規範を独自の細則として重複転記せず、専門判断をマイクロ指示で固定しない。

parentは着手時に業務報告書ドラフトを作る。ドラフトは依頼の理解、会話由来の確定条件、仮説、方針、共有境界、想定成果、検証方法、未決事項を含む。起点はその要点と詳細リンクをユーザーへ共有する。調査から設計案が生まれ、選択で成果が変わる場合は、このドラフトを承認対象にしてから実装へ進む。

着手ドラフトは作成時点の言語化として不変に保存する。訂正・追加決定・承認は変更経緯へ追記し、完了時はドラフトを置換せず正式版を追加する。正式版には最終仕様、原依頼からの変更、成果、根拠、検証、条件と限界、未解決事項、成果物の所在を残す。保存が必要な場合はparent所有の`report.md`にドラフト・変更経緯・正式版を併存させ、`state.md`と分ける。childの限定委任に必要な`instruction.md`、`response.md`、`state.md`は別境界として維持する。

## 起動権限

- 通常の起点: `assistant-L`、承認された委任のparent 9、ルーティング補助の `root-advisor`
- 明示されたparent兼務中の起点: worker 7、`assistant-L`、`advisor`。別parentへの移管はユーザーに確認
- Sol/Astra parent: worker 7、`assistant-L`、`advisor`
- child、assistant、advisor: 再委譲なし

起点からparentへの履歴継承はユーザーがその起動について明示的に許可した場合だけ行う。非継承時は、起点が必要な原文と経緯を渡す。完全な会話全文の転載で履歴継承制限を迂回しない。

起点は進捗把握を目的とした状態照会やポーリングを行わない。受動的な完了・要確認通知の受信とイベント待機は進捗照会と区別する。ユーザーが明示的に状況確認を依頼した場合だけ、その回答に必要な状態確認を行う。圧縮後は保存済み記録と受信済み通知から再開し、担当へ状態を問い合わせない。

## 評価計画

今回の変更は運用仮説であり、代表案件での小規模比較は未実施である。次の順序で評価する。

1. Sol/Astra parentとLuna末端担当の編成を代表案件で小規模比較する。起点モデルを取得できない場合は不明とし、推測しない。
2. 起点の履歴抽出、parentのドラフト品質、手戻り、コンパクション、チーム総消費、ユーザー介入、所要時間を取得できる範囲で記録する。
3. Sol/mediumの`root-advisor`を含む条件を確認した後、相談役のlow化を別条件として比較する。

設定変更だけで効率・品質改善を実証済みと扱わない。未取得の値、内部推論、キャッシュ効果は推測しない。

起点は比較指標の取得を理由に担当へ進捗照会しない。受信済み通知、完了報告、保存済み記録から取得できる値だけを使う。

## 検証の扱い

CIではsourceのTOMLを読み、parentが指定の9ロール・許可されたSol/Astraモデルであること、共通規約のinclude、廃止定義と専用規約への参照がないことを検査する。その後、既存のchezmoi描画とTOML構文検証を行う。ローカルではchezmoiを実行せず、sourceポリシー検査、include先・文書リンク・シナリオ照合、`git diff --check`を行う。

受入ケースは、軽微な依頼への自身／assistantの早期回答、早期回答困難時の委任確認、不満時の委任確認、明示されたparent兼務と終了後の復帰、自己モデル不明でも同じ責務、報告の要約と詳細リンクである。静的な照合は実際のエージェント動作の保証ではない。

chezmoi実行、実環境への配布、起点の`config.toml`変更、実際の候補表示・起動、モデル適用、権限の実行時強制、性能比較は別作業である。sourceの静的検査結果をこれらの成功として扱わない。

## 過去の検討

- 2026-09-18以前はGPT-5.6 Sol/Terra/LunaをL/M/H能力帯へ対応させ、起点はSol/low、parentの委任入力は起点作成の指示書を中心にしていた。
- 2026-09-23にGPT-6へ移行し、旧Terra担当をLuna/xhighへ変更した。L/M名は互換性のため残し、モデル名から担当範囲の能力帯へ意味を整理した。
- 同日に起点をLuna/xhigh主体へ戻す方針（現在は廃止）、Sol/mediumの`root-advisor`、parent所有の不変な着手ドラフト・変更経緯・正式版の併存、起点の進捗照会廃止を導入した。

- 2026-09-24にLuna parentを廃止し、単純広域調査をSolへ統合した。起点をモデルに依存しないルーティング役とし、ユーザーの明示によるparent兼務と報告の必須詳細リンクを定めた。

モデル間・effort間の同等性や品質・価格の優劣は、この文書から保証しない。表示名の番号は個体識別用で、モデル適用や回答品質の証明ではない。
