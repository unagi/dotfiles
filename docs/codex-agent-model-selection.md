# Codexモデル・effortの選択記録

## 現行設定（2026-09-26、暫定）

設定の正本は各TOML、呼出権限は [チーム運用](../dot_codex/common/sub-agent.md.tmpl)。以下は合意した運用仮説を実装した値であり、性能を実測して最適性を保証したものではない。実装後に公開ベンチマーク・定評で最終再確認する。

| ロール | モデル | effort | sandbox |
| --- | --- | --- | --- |
| [advisor-astra](../dot_codex/agents/advisor-astra.toml.tmpl) | gpt-6-astra | medium | read-only |
| [advisor-sol](../dot_codex/agents/advisor-sol.toml.tmpl) | gpt-6-sol | xhigh | read-only |
| [assistant-luna](../dot_codex/agents/assistant-luna.toml.tmpl) | gpt-6-luna | high | read-only |
| [parent-astra](../dot_codex/agents/parent-astra.toml.tmpl) | gpt-6-astra | low | workspace-write |
| [parent-sol](../dot_codex/agents/parent-sol.toml.tmpl) | gpt-6-sol | medium | workspace-write |
| [reviewer-astra](../dot_codex/agents/reviewer-astra.toml.tmpl) | gpt-6-astra | medium | read-only |
| [reviewer-sol](../dot_codex/agents/reviewer-sol.toml.tmpl) | gpt-6-sol | xhigh | read-only |
| [worker-luna-high](../dot_codex/agents/worker-luna-high.toml.tmpl) | gpt-6-luna | high | workspace-write |
| [worker-luna-low](../dot_codex/agents/worker-luna-low.toml.tmpl) | gpt-6-luna | low | workspace-write |
| [worker-sol-high](../dot_codex/agents/worker-sol-high.toml.tmpl) | gpt-6-sol | high | workspace-write |
| [worker-sol-low](../dot_codex/agents/worker-sol-low.toml.tmpl) | gpt-6-sol | low | workspace-write |

## 現段階の解釈

- **起点からLuna**：起点自身のモデル識別を前提にできず、低effortの失敗を救済できる保証もないためhigh固定。主な目的は履歴負担の分離。起点がParentを兼務してもこの条件を変えない。
- **Sol ParentからLuna**：明確な指示と容易な受入ならlow、照合や解釈で手戻りが懸念されるならhigh。利用者の観測ではlow/mediumとhigh/xhigh/maxの二群に速度・性能が分かれ、旧測定では待ち時間差が約1.5倍。これは比較条件未整理の利用者観測であり、全業務への保証ではない。各群の代表としてlow/highに絞る。
- **費用と手戻り**：LunaがSolより安いという前提で、高effortを単価だけで避けない。採用判断は指示・検査・再実行を含む総負担で行う。API価格の差をCodex利用枠の比率や実作業費用へ直接換算しない。
- **Sol Parent / medium**：簡単・大量の仕事で分割・的確な指示・受入・統合を担い、即応性を重視する。Sol workerを追加せずLunaを使う。
- **Astra Parent / low**：難しい・少量の案件の入口。Lunaへの細かな指示に高単価を費やさず、Sol workerを使う。Sol lowは局所実行、highは切り出された範囲にも難しい推論が残る場合。ノイジーな指示や量の多さはhigh採用の根拠にしない。
- **Reviewer / Advisor**：Sol xhigh、Astra medium。Parentより深い検討を担当する。Reviewerは全体の論理とユーザー意図、Advisorは方針の成立条件と改善を扱い、同じ個体で兼務しない。モデル・effort差だけでレビュー品質が保証されるわけではなく、入力と評価基準の分離を併用する。
- 定義上選べるeffortと実用上の採用価値は別であり、effortと能力の線形関係は仮定しない。今回採らなかったmedium/xhigh/max等を一律に無価値と結論しない。

## 根拠と再確認予定

今回の設定は利用者の観測とチーム設計上の判断に基づく。従来の調査があっても、ここでは最終再確認済みとは扱わない。次の見直しで下記を読み、確認日・モデル版・タスク・effort・測定条件・結論を追記する。

| 種別 | 確認先・扱い |
| --- | --- |
| 公式仕様 | [Luna](https://developers.openai.com/api/docs/models/gpt-6-luna)、[Sol](https://developers.openai.com/api/docs/models/gpt-6-sol)、[Astra](https://developers.openai.com/api/docs/models/gpt-6-astra)：対応effortと提供形態を確認する候補。今回再取得していない |
| 公式選択・費用 | [Model selection](https://developers.openai.com/api/docs/guides/model-selection)、[Pricing](https://developers.openai.com/api/docs/pricing)：APIとCodexの適用範囲を区別して確認予定 |
| 公開ベンチマーク | 同一課題のeffort比較、初回品質、再作業込みの時間・費用を優先。具体的な採用資料と比較条件は最終調査で記録する |
| Reddit等のフォーラム | 利用条件が明記された体験を補助証拠とする。単発の評判や異なるモデル版を性能保証にしない。採用投稿のURL・日付は最終調査で記録する |
| 利用者観測 | Luna二群・約1.5倍の待ち時間差・低effortで手戻り増加傾向。未統制の観測として設計の出発点に用いる |

## 先行調査の引継ぎ（2026-09-26）

同日の実装前調査で参照した資料と解釈を以下に残す。この節は先行調査の記録であり、今回の実装作業で再取得・追試したものではない。

- **公式**：[Sol/Luna発表](https://openai.com/index/introducing-gpt-6-sol-and-luna/)では高effortの評価例とモデル間比較があり、高effortの実用候補を残す根拠になった。ただし同一モデルの全effort比較ではなく、各workerの最適値は確定できない。[Astra発表](https://openai.com/index/gpt-6-astra/)の評価談はeffortによって反復・検証量も変わり得ることを示唆し、純粋な推論能力だけの差と解釈しなかった。
- **Lunaの外部観測**：[Communityの本人測定](https://community.openai.com/t/announcing-gpt-6-sol-and-gpt-6-luna-in-the-api-codex-and-chatgpt/1399925/6)は限定された課題でLuna/highの費用・品質を支持。一方、[Redditの利用経路比較](https://www.reddit.com/r/codex/comments/1wptlvk/gpt6_luna_in_codex_does_zero_reasoning_high/)はAPI gatewayとCodexの計測差や失敗例を報告していた。経路・反復条件が異なり、群間差や成功率の確定には使わなかった。
- **Solの経験談**：[high等を評価する報告](https://www.reddit.com/r/codex/comments/1wpasz8/anybody_not_having_a_bad_time_with_gpt_6_sol/)と[xhighでも回帰を報告する投稿](https://www.reddit.com/r/codex/comments/1wp5x1a/gpt6_sol_is_not_good/)が併存。高effortは候補だが信頼性の保証ではなく、worker全員high固定の根拠にはしなかった。
- **Astraの経験談**：[高effortで完遂した報告](https://www.reddit.com/r/codex/comments/1wc8y79/astra_observation_it_seems_tuned_to_xhighultra/)は履歴蓄積との交絡があり、[effort選好の比較投稿](https://www.reddit.com/r/codex/comments/1wmcbcu/astra_high_vs_xhigh_vs_max_vs_ultra/)でも評価が割れていた。Advisorのmedium/high/xhighの最適値は未確定とした。

共通の限界は、3モデルの全effortを同一の実務課題・受入条件で十分に反復した公開比較が得られていないこと。次回は世代、公開日、利用経路、ツール有無、課題と受入条件を確認してから、この暫定設定への支持・反証を評価する。

## 変更経緯

| 時点 | 変更・判断 | 理由・残課題 |
| --- | --- | --- |
| 今回の再編前 | 職能別Parent 9種、Luna worker L/Mともxhigh、Sol worker Hはhigh、Root補助はLuna low | 職能と難度が混在し、L/Mの設定差がなく、品質基準と呼出元の違いが不明瞭だった |
| 2026-09-26 合意・実装 | 職能を廃止してParent 2種、worker 4種、Advisor 2種、Reviewer 2種、Root補助1種へ | 指示・受入の明確さと手戻りリスクで使い分ける。Reviewerを独立した規範にする |
| 同日 適用範囲の具体化 | Root兼務でもLuna high、Root相談はadvisor-solを共用 | 起点の自己識別に依存しない。相談用ロールを重複させない |
| 次の見直し | 公開根拠に基づく設定再確認 | 現設定を暫定値として保持し、根拠と変更理由を追記する |

職能と旧一律二段階レビューを撤去したが、秘密情報保護・権限・実環境への反映境界は維持する。情報共有方式の詳細再編は保留TODO。

## 受入ケース

| ケース | 期待する動作 |
| --- | --- |
| Rootの限定的な参照補助 | assistant-luna/high。Parentを起動しない |
| 簡単・大量、指示・検査が明確 | parent-sol → worker-luna-low → reviewer-sol |
| 同系統で手戻り懸念 | 指示を補いworker-luna-highを選ぶ |
| Rootが簡単系Parentを明示兼務 | worker-luna-high。worker-luna-lowは使わない |
| 難しい・少量、局所実行は明確 | parent-astra → worker-sol-low → reviewer-astra |
| 境界内に難しい局所推論が残る | worker-sol-high。上位方針の不足はParentへ戻す |
| 難しい・大量 | 計画をレビュー・ユーザー承認後、実作業へ進む。第三の系統を作らない |
| childが指示不足で失敗 | Parentが指示・受入条件を補う。自動的にモデル昇格しない |
| Parentによるchild受入 | 委任指示への適合を評価。ユーザー意図を再定義しない |
| Reviewerが成果を評価 | 原依頼・解釈・成果の整合を見る。軽微な指摘数で評価しない |
| Advisorに相談済み | 別個体のReviewerを使い、助言会話を渡さない |
| 見解相違が未解決 | Parentがユーザーへ争点を質問する |
| Rootの限定作業・childの中間報告 | 一律の二段階レビューを追加しない |

静的照合は設定・指示の整合までを検証する。実モデルでの速度・費用・手戻り率、chezmoiによる実展開はローカル検証に含めない。
