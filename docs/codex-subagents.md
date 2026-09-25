# Codexサブエージェントの全体像と設計コンセプト

## 位置づけ

この資料は、構成と設計意図を知りたい人向けのアウトラインです。エージェントへの行動指示ではありません。詳細な手順・権限・記録方法は、下記のリンク先にあるエージェント向け指示とテンプレートを正本とします。

モデル別の一覧や評価状況は[編成・モデル設定資料](codex-agent-model-selection.md)を参照してください。ここでは役割と情報の流れを説明します。

## まず全体像をつかむ

ユーザーが会話するメインのエージェントを「起点」、専門案件を一貫して担当するエージェントを「parent」、その中の独立した作業を担当するエージェントを「worker（child）」と呼ぶ。assistantは軽作業の補助、advisorは相談役である。

起点は会話の保持・原文の受け渡し・報告を、parentは専門判断を担います。軽微な求めは起点とassistant、回答への指摘はSol相談役、parentの難所はAstra相談役で扱います。起点がparentを兼ねるのはユーザーが明示した範囲だけです。

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
    R <-->|"回答の再検討・依頼先の相談"| RA
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
    participant RA as Sol相談役
    U->>R: 依頼と、それに至る会話
    opt 軽微な求め
        R->>R: 自身またはLuna assistantと早期回答
    end
    opt 回答への否定・不満・論理への指摘
        R->>RA: 必要原文と元回答を渡して限定再検討
        RA-->>R: 成立条件・改善案・未確認事項
        R-->>U: 要約と詳細リンク
    end
    opt 早期回答できない、または専門調査が必要
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

着手ドラフトは当初理解の記録であり、承認済みの設計案とは別です。変更経緯と正式報告を併存させ、起点が要約と詳細リンクを届けます。通知で回収し、進捗をポーリングしません。詳細な条件・例外は以下の正本にあります。

## 役割と、対応するエージェント向け指示

| 役割・論点 | 人向けの要点 | 指示・テンプレートの正本 |
| --- | --- | --- |
| 起点 | 全履歴保持・原文切り抜き・報告要約と詳細リンク・軽微な求めへの早期回答 | [起点規約](../dot_codex/common/root-agent.md.tmpl) |
| parent | 依頼を解釈し、専門案件と業務報告を一貫して担う | [共通本文](../.chezmoitemplates/agent/codex/parent.md)、[Sol/Astra用](../.chezmoitemplates/agent/codex/parent-advanced.md) |
| worker / child | 独立した成果単位を調査・実装・検証する | [末端担当の共通本文](../.chezmoitemplates/agent/codex/child.md)、[調査用](../.chezmoitemplates/agent/codex/research-worker.md)、[実装用](../.chezmoitemplates/agent/codex/implementation-worker.md) |
| assistant-L | 起点・parentそれぞれの検索、抽出、整理を補助する | [assistant定義](../dot_codex/agents/assistant-L.toml.tmpl) |
| root-advisor | ユーザーに否定された回答の限定再検討とルーティングを補助する | [起点専属相談役の定義](../dot_codex/agents/root-advisor.toml.tmpl) |
| advisor | parentの難所を分析し、parentが検証・統合する | [専門顧問の定義](../dot_codex/agents/advisor.toml.tmpl) |
| 起動・権限・記録 | 誰が誰を利用できるか、記録をどう保持するかを定める | [委任共通規約](../dot_codex/common/sub-agent.md.tmpl) |
| 共通の入口 | プロジェクトの指示と併せて適用する共通方針 | [Codex向けAGENTSテンプレート](../dot_codex/AGENTS.md.tmpl) |

リンク先は配布元のsourceです。設定と評価は[編成資料](codex-agent-model-selection.md)、編集時の責務・重複の基準は[保守ルール](instruction-maintenance.md)にあります。

## 共通の検討姿勢

全ロールに[仮説・提案の基本姿勢](../.chezmoitemplates/agent/codex/hypothesis.md)を適用する。現実的な条件付き成立を細かな否定より優先し、根幹を覆す論拠がなければ条件と改善案を示す。childの報告もこの姿勢で評価する。parentの難所はAstra相談役とparentが扱い、通常起点へ専門判断を戻さない。

## この構成で確かめたいこと

会話文脈の受け渡しを起点に、専門的な解釈と遂行をparentに置くことで、起点の解釈による制約とメインスレッドの負担を減らす狙いがあります。parentはSol/Astraに限定し、Lunaは再委任しないassistant・workerとして利用します。起点のモデルを固定せず、役割とユーザーの明示指示で責務を区別します。品質・消費量の改善は実証済みとは扱いません。

比較手順と未検証範囲は[評価計画](codex-agent-model-selection.md#評価計画)・[検証の扱い](codex-agent-model-selection.md#検証の扱い)を参照してください。sourceの変更と、実環境への適用は別の作業です。
