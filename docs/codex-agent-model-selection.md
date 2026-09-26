# Codexモデル・effortの選択記録

## 現行設定（2026-09-26、弱い支持により維持）

設定の正本は各TOML、呼出権限は [チーム運用](../dot_codex/common/sub-agent.md.tmpl)。Artificial Analysisによる再確認と役割設計を合わせ、現設定の維持は弱く支持されたと判断する。最適性やチームとしての効果を実証したものではない。設定値は変更せず、満足度・使用感と新たな公開情報から必要時に見直す。

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

- **rootからLuna**：root自身のモデル識別を前提にできず、低effortの失敗を救済できる保証もないためhigh固定。主な目的は履歴負担の分離。rootがParentを兼務してもこの条件を変えない。
- **Sol ParentからLuna**：明確な指示と容易な受入ならlow、照合や解釈で手戻りが懸念されるならhigh。軽量側と手戻り予防側の差を明確にするためlow/highの2階級を維持する。AAではmediumがlowよりhighに近いため、mediumを軽量側に採る優先度は低い。「lowとmediumが同等だからlow」という従来の根拠は採らない。medium自体を無価値とは扱わない。
- **費用と手戻り**：LunaがSolより安いという前提で、高effortを単価だけで避けない。採用判断は指示・検査・再実行を含む総負担で行う。API価格の差をCodex利用枠の比率や実作業費用へ直接換算しない。
- **Sol Parent / medium**：簡単・大量の仕事で分割・的確な指示・受入・統合を担い、即応性を重視する。Sol workerを追加せずLunaを使う。
- **Astra Parent / low**：難しい・少量の案件の入口。Lunaへの細かな指示に高単価を費やさず、Sol workerを使う。Sol lowは局所実行、highは切り出された範囲にも難しい推論が残る場合。ノイジーな指示や量の多さはhigh採用の根拠にしない。
- **Reviewer / Advisor**：Sol xhigh、Astra medium。Parentより深い検討を担当する。Reviewerは全体の論理とユーザー意図、Advisorは方針の成立条件と改善を扱い、同じ個体で兼務しない。モデル・effort差だけでレビュー品質が保証されるわけではなく、入力と評価基準の分離を併用する。
- 定義上選べるeffortと実用上の採用価値は別であり、effortと能力の線形関係は仮定しない。今回採らなかったmedium/xhigh/max等を一律に無価値と結論しない。

## Artificial Analysisによる再確認（2026-09-26）

[Artificial Analysis](https://artificialanalysis.ai/)のIntelligence Index v4.3.2と課題あたりの加重平均API費用を確認した。以下は各モデルページの丸め表示で、各セルは「Index / USD」。

| effort | Luna | Sol | Astra |
| --- | --- | --- | --- |
| low | [21 / 0.0045](https://artificialanalysis.ai/models/gpt-6-luna-low) | [34 / 0.13](https://artificialanalysis.ai/models/gpt-6-sol-low) | [46 / 0.82](https://artificialanalysis.ai/models/gpt-6-astra-low) |
| medium | [29 / 0.02](https://artificialanalysis.ai/models/gpt-6-luna-medium) | [40 / 0.25](https://artificialanalysis.ai/models/gpt-6-sol-medium) | [50 / 1.54](https://artificialanalysis.ai/models/gpt-6-astra-medium) |
| high | [32 / 0.03](https://artificialanalysis.ai/models/gpt-6-luna-high) | [43 / 0.37](https://artificialanalysis.ai/models/gpt-6-sol-high) | [51 / 1.73](https://artificialanalysis.ai/models/gpt-6-astra-high) |
| xhigh | [34 / 0.04](https://artificialanalysis.ai/models/gpt-6-luna-xhigh) | [44 / 0.53](https://artificialanalysis.ai/models/gpt-6-sol-xhigh) | [52 / 2.31](https://artificialanalysis.ai/models/gpt-6-astra-xhigh) |
| max | [37 / 0.07](https://artificialanalysis.ai/models/gpt-6-luna) | [48 / 1.06](https://artificialanalysis.ai/models/gpt-6-sol) | [53 / 3.26](https://artificialanalysis.ai/models/gpt-6-astra) |

[評価方法](https://artificialanalysis.ai/methodology/intelligence-benchmarking)は主に英語・テキストの10評価を統合したもの。総合点は成功率ではなく、Parentの指示能力やReviewerの見落とし率を直接測っていない。小さな点差から役割上の優位を確定しない。API費用をCodex利用枠やチーム総費用へ換算しない。tokens/secは生成中の速度で、Time per TaskもTTFTとoverheadを除くため、実運用の待ち時間とは異なる。

### 維持判断とその強さ

- **全体**：階級間の差と費用配分は役割設計と概ね整合する。現設定を直ちに変更する材料はなく、設定維持への弱い支持と位置付ける。公開ベンチマークが編成の有効性を実証したとは扱わない。
- **Luna low/high**：low→mediumは21→29、medium→highは29→32。2階級に絞るならlow/highの方が差を明確にできる。旧二群仮説による同等性から、編成を単純に保ちつつ階級差を確保する根拠へ改める。
- **Lunaの費用**：highでもSol lowの約4.3分の1であり、高effortを単価だけで避けない考え方と整合する。一方Luna low→highは約6.7倍。旧観測の待ち時間差約1.5倍は一般的な設計定数にしない。
- **Sol Parent / Worker**：Parentのmediumはlowより6点高く、Worker low/highにも9点差がある。現在の役割分担と矛盾しない。highを指示不足の補償に使わない原則は維持する。
- **Sol Reviewer / Advisor**：xhighはmediumのParentより深い検討へ配分する方針を満たす。highとの点差は1、費用増は約43%で、xhighの最適性を強く支持する結果ではない。それでもhighで十分と判断する役割固有の根拠、maxやAstraの追加費用を受け入れる必要性が乏しいため、積極的に選べる対案がない消極的選択としてxhighを維持する。設定上の代案が存在しないという意味ではない。
- **Astra Parent / Reviewer・Advisor**：low→mediumは46→50、費用約1.88倍。入口をlow、深い検討をmediumに置く設計と矛盾しない。high以上への一律変更は行わない。

### 今後の見直し方法

同一条件での誤り率・手戻り時間などの統計的比較は、取得の難しさと案件ごとの再現性の乏しさから、この運用の前提にしない。先に提案したeffort別の比較実験計画は撤回する。比較を完了することを設定維持・見直しの条件にしない。

日常のフィードバックから、ユーザーの満足度、指摘の納得感、意図の理解、手戻り感、待ち時間・費用の負担感を弱い指標として扱う。採点表や全案件の記録を義務化せず、見直しに関係する具体例と変更理由を必要な範囲で残す。指示・役割分担・モデルなどの影響を分離できないため、使用感をモデル単独の性能差や因果関係の証明にしない。

公開ベンチマークは選択肢を絞る補助材料、運用での満足度は維持・見直しの判断材料とする。問題が顕在化した際や有用な公開情報が得られた際に再検討し、情報不足だけを理由に設定を変更し続けない。

## 先行調査の引継ぎ（2026-09-26）

同日の実装前調査で参照した資料と解釈を以下に残す。この節は先行調査の記録であり、今回の実装作業で再取得・追試したものではない。

- **公式**：[Sol/Luna発表](https://openai.com/index/introducing-gpt-6-sol-and-luna/)では高effortの評価例とモデル間比較があり、高effortの実用候補を残す根拠になった。ただし同一モデルの全effort比較ではなく、各workerの最適値は確定できない。[Astra発表](https://openai.com/index/gpt-6-astra/)の評価談はeffortによって反復・検証量も変わり得ることを示唆し、純粋な推論能力だけの差と解釈しなかった。
- **Lunaの外部観測**：[Communityの本人測定](https://community.openai.com/t/announcing-gpt-6-sol-and-gpt-6-luna-in-the-api-codex-and-chatgpt/1399925/6)は限定された課題でLuna/highの費用・品質を支持。一方、[Redditの利用経路比較](https://www.reddit.com/r/codex/comments/1wptlvk/gpt6_luna_in_codex_does_zero_reasoning_high/)はAPI gatewayとCodexの計測差や失敗例を報告していた。経路・反復条件が異なり、群間差や成功率の確定には使わなかった。
- **Solの経験談**：[high等を評価する報告](https://www.reddit.com/r/codex/comments/1wpasz8/anybody_not_having_a_bad_time_with_gpt_6_sol/)と[xhighでも回帰を報告する投稿](https://www.reddit.com/r/codex/comments/1wp5x1a/gpt6_sol_is_not_good/)が併存。高effortは候補だが信頼性の保証ではなく、worker全員high固定の根拠にはしなかった。
- **Astraの経験談**：[高effortで完遂した報告](https://www.reddit.com/r/codex/comments/1wc8y79/astra_observation_it_seems_tuned_to_xhighultra/)は履歴蓄積との交絡があり、[effort選好の比較投稿](https://www.reddit.com/r/codex/comments/1wmcbcu/astra_high_vs_xhigh_vs_max_vs_ultra/)でも評価が割れていた。Advisorのmedium/high/xhighの最適値は未確定とした。

この先行調査時点では、3モデルの全effortを同一の実務課題・受入条件で十分に反復した公開比較は確認できていなかった。その後のAAによる確認と運用上の採否は上記に記録した。世代・利用経路・課題の違いを区別する姿勢は維持するが、独自の統計試験を要求する根拠にはしない。

## 変更経緯

初期のLuna選択は、利用者の「low/mediumとhigh/xhigh/maxの二群で速度・性能が分かれ、旧測定の待ち時間差は約1.5倍」という観測を出発点にしていた。比較条件が未整理の観測であり、今回のAA結果には同等な二群という整理が合わないため、現在の採用根拠にはしない。

| 時点 | 変更・判断 | 理由・残課題 |
| --- | --- | --- |
| 今回の再編前 | 職能別Parent 9種、Luna worker L/Mともxhigh、Sol worker Hはhigh、root補助はLuna low | 職能と難度が混在し、L/Mの設定差がなく、品質基準と呼出元の違いが不明瞭だった |
| 2026-09-26 合意・実装 | 職能を廃止してParent 2種、worker 4種、Advisor 2種、Reviewer 2種、root補助1種へ | 指示・受入の明確さと手戻りリスクで使い分ける。Reviewerを独立した規範にする |
| 同日 適用範囲の具体化 | root兼務でもLuna high、root相談はadvisor-solを共用 | rootの自己識別に依存しない。相談用ロールを重複させない |
| 同日 AAによる再確認 | 設定維持を弱く支持。Luna low/highの選択理由を更新 | low/medium同等という二群仮説ではなく、2階級の差と運用の単純さを根拠とする。旧約1.5倍の待ち時間観測は一般化しない |
| 同日 利用者との判断確定 | Sol xhighを消極的選択として維持。独自比較実験の提案を撤回 | 統計取得と再現性の制約を踏まえ、満足度・使用感などの弱い指標で見直す。最適性の実証とは区別する |

職能と旧一律二段階レビューを撤去したが、秘密情報保護・権限・実環境への反映境界は維持する。情報共有方式の詳細再編は保留TODO。

## 受入ケース

| ケース | 期待する動作 |
| --- | --- |
| rootの限定的な参照補助 | assistant-luna/high。Parentを起動しない |
| 簡単・大量、指示・検査が明確 | parent-sol → worker-luna-low → reviewer-sol |
| 同系統で手戻り懸念 | 指示を補いworker-luna-highを選ぶ |
| rootが簡単系Parentを明示兼務 | worker-luna-high。worker-luna-lowは使わない |
| 難しい・少量、局所実行は明確 | parent-astra → worker-sol-low → reviewer-astra |
| 境界内に難しい局所推論が残る | worker-sol-high。上位方針の不足はParentへ戻す |
| 難しい・大量 | 計画をレビュー・ユーザー承認後、実作業へ進む。第三の系統を作らない |
| childが指示不足で失敗 | Parentが指示・受入条件を補う。自動的にモデル昇格しない |
| Parentによるchild受入 | 委任指示への適合を評価。ユーザー意図を再定義しない |
| Reviewerが成果を評価 | 原依頼・解釈・成果の整合を見る。軽微な指摘数で評価しない |
| Advisorに相談済み | 別個体のReviewerを使い、助言会話を渡さない |
| 見解相違が未解決 | Parentがユーザーへ争点を質問する |
| rootの限定作業・childの中間報告 | 一律の二段階レビューを追加しない |

静的照合は設定・指示の整合までを検証する。実モデルでの速度・費用・手戻り率、chezmoiによる実展開はローカル検証に含めない。
