# Codexサブエージェントの全体像と設計コンセプト

## 位置づけ

この資料は、構成と設計意図を知りたい人向けのアウトラインです。エージェントへの行動指示ではありません。詳細な手順・権限・記録方法は、下記のリンク先にあるエージェント向け指示とテンプレートを正本とします。

モデル別の一覧や評価状況は[編成・モデル設定資料](codex-agent-model-selection.md)を参照してください。ここでは役割と情報の流れを説明します。

## まず全体像をつかむ

ユーザーが会話するメインのエージェントを「起点」、専門案件を一貫して担当するエージェントを「parent」、その中の独立した作業を担当するエージェントを「worker（child）」と呼ぶ。assistantは軽作業の補助、advisorは相談役である。

通常の起点はルーティングを担う。全履歴を保持し、必要な部分を原文で切り抜いてparentへ依頼する。報告は要約し、詳細リンクを必ず添える。軽微な求めには自身またはLunaアシスタントと早期回答し、早期回答できない、または満足を得られなければ、parentへの委任をユーザーに確認する。専門的な目的の体系化・判断・統合はparentが担う。

ユーザーが起点自身にparentとしての対応を明示した場合だけ、その範囲で起点が検討・判断・統合を担う。自身のモデル・effortの認識を条件にせず、兼務終了後は通常のルーティングへ戻る。

```mermaid
flowchart TB
    U["ユーザー"]
    R["起点：全履歴保持・原文切り抜き・報告要約<br/>自身のモデル・effortに依存しない"]
    RA["起点専属の相談役：root-advisor<br/>GPT-6 Sol / medium"]
    A0["起点専属のassistant-L<br/>GPT-6 Luna / low"]
    P["parent：Sol / Astraの専門担当<br/>調査・設計・実装・検証・報告"]
    A1["parent専属のassistant-L<br/>GPT-6 Luna / low"]
    W["worker / child<br/>独立した成果単位を担当"]
    AD["専門難所のadvisor<br/>GPT-6 Astra / medium"]
    U <-->|"依頼・訂正・報告"| R
    R <-->|"依頼先・文脈の相談"| RA
    R <-->|"検索・抽出等の補助"| A0
    R -->|"承認された委任・会話原文と経緯"| P
    P -->|"着手ドラフト・質問・正式報告"| R
    P <-->|"必要な確認・承認"| U
    P <-->|"検索・抽出等の補助"| A1
    P <-->|"限定作業の依頼・成果"| W
    P <-->|"Sol / Astra parentからの相談"| AD
    R -.->|"明示されたparent兼務時のみ"| W
    R -.->|"明示されたparent兼務時のみ"| AD
```

矢印は情報の受け渡しを示します。全員を一斉に起動する構成ではなく、案件に必要な担当を利用します。起動できる相手の詳細は[委任共通規約](../dot_codex/common/sub-agent.md.tmpl)にあります。

## 依頼から完了までの流れ

```mermaid
sequenceDiagram
    actor U as ユーザー
    participant R as 起点
    participant P as parent
    U->>R: 依頼と、それに至る会話
    opt 軽微な求め
        R->>R: 自身またはLuna assistantと早期回答
    end
    opt 早期回答できない、または満足を得られない
        R-->>U: parentへの委任を確認
        U->>R: 委任または取りやめ
    end
    Note over R,P: 以下は委任が承認された場合
    R->>P: 最新の依頼と経緯を広めに原文抜粋で渡す
    P->>P: 依頼を体系化し、着手ドラフトを保存
    P-->>R: 着手ドラフトを通知
    R-->>U: 担当の理解と方針の要約＋詳細リンク
    opt ユーザーから訂正・追加情報がある
        U->>R: 訂正・追加発言
        R->>P: 原文で転送
        P->>P: 変更経緯を追記
    end
    P->>P: 調査・成果の具体化
    opt 調査して設計し、承認後に実装する案件
        P-->>U: 調査に基づく設計ドラフトを提示
        U->>P: 設計の承認・訂正
        P->>P: 承認内容を記録し、実装・検証
    end
    P->>P: 着手ドラフトを残して正式報告を追加
    P-->>R: 成果・検証・限界を通知
    R-->>U: 完了報告の要約＋詳細リンク
```

起点は会話の原文を渡し、parentはそれを解釈して業務を進めます。起点がユーザーへ要約するのは、parentから届いた報告です。詳細リンクを必ず添え、メッセージにリンクできない場合は許可された記録担当が作業領域に報告を保存します。着手ドラフトと変更経緯、完了時の正式報告を残すことで、会話が圧縮されても当初の理解と結論までの経緯をたどれます。

着手ドラフトは当初理解の記録であり、調査後にユーザーが承認する設計案とは別です。ユーザーへの直接確認ができない環境では起点が仲介します。起点は担当からの通知を受け取り、進捗をポーリングしません。

詳細は[起点の行動規範](../dot_codex/common/root-agent.md.tmpl)と[parentの共通規約](../.chezmoitemplates/agent/codex/parent.md)を参照してください。

## 役割と、対応するエージェント向け指示

| 役割・論点 | 人向けの要点 | 指示・テンプレートの正本 |
| --- | --- | --- |
| 起点 | 全履歴保持・原文切り抜き・報告要約と詳細リンク・軽微な求めへの早期回答 | [起点規約](../dot_codex/common/root-agent.md.tmpl) |
| parent | 依頼を解釈し、専門案件と業務報告を一貫して担う | [共通本文](../.chezmoitemplates/agent/codex/parent.md)、[Sol/Astra用](../.chezmoitemplates/agent/codex/parent-advanced.md) |
| worker / child | 独立した成果単位を調査・実装・検証する | [末端担当の共通本文](../.chezmoitemplates/agent/codex/child.md)、[調査用](../.chezmoitemplates/agent/codex/research-worker.md)、[実装用](../.chezmoitemplates/agent/codex/implementation-worker.md) |
| assistant-L | 起点・parentそれぞれの検索、抽出、整理を補助する | [assistant定義](../dot_codex/agents/assistant-L.toml.tmpl) |
| root-advisor | 起点の依頼先選択や、渡す文脈について相談を受ける | [起点専属相談役の定義](../dot_codex/agents/root-advisor.toml.tmpl) |
| advisor | 専門的な難所の反証・再分析を担う | [専門顧問の定義](../dot_codex/agents/advisor.toml.tmpl) |
| 起動・権限・記録 | 誰が誰を利用できるか、記録をどう保持するかを定める | [委任共通規約](../dot_codex/common/sub-agent.md.tmpl) |
| 共通の入口 | プロジェクトの指示と併せて適用する共通方針 | [Codex向けAGENTSテンプレート](../dot_codex/AGENTS.md.tmpl) |

リンク先は配布元のsourceです。各ロールのモデル・推論強度と本文の組み合わせは[agent定義一覧](../dot_codex/agents/)で確認できます。人向けの[編成・モデル設定資料](codex-agent-model-selection.md)は、その一覧を比較しやすくまとめたものです。

## この構成で確かめたいこと

会話文脈の受け渡しを起点に、専門的な解釈と遂行をparentに置くことで、起点の解釈による制約とメインスレッドの負担を減らす狙いがあります。parentはSol/Astraに限定し、Lunaは再委任しないassistant・workerとして利用します。起点のモデルを固定せず、役割とユーザーの明示指示で責務を区別します。品質・消費量の改善は実証済みとは扱いません。

比較手順と未検証範囲は[評価計画](codex-agent-model-selection.md#評価計画)・[検証の扱い](codex-agent-model-selection.md#検証の扱い)を参照してください。sourceの変更と、実環境への適用は別の作業です。
