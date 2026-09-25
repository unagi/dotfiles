# Codexエージェントの編成とモデル選択

## 正本と適用範囲

[設計コンセプト](codex-subagents.md)を全体方針の説明、`dot_codex/common/root-agent.md.tmpl`を起点の行動規範、`dot_codex/common/sub-agent.md.tmpl`を階層・権限・起動・記録境界の正本とする。parentの共通本文と専用本文は`.chezmoitemplates/agent/codex/`、モデルと表示名は`dot_codex/agents/*.toml.tmpl`が正本である。

現行方針の確認日は2026-09-26。sourceはサブエージェント19定義（parent 9、worker 7、advisor 2、assistant 1）を管理する。起点モデルを含む`config.toml`はchezmoi管理外である。起点の責務は自身のモデル・effortの認識に依存せず、実環境の設定・配布は別作業である。

## 現行編成

19ロールの設定由来の一覧を以下に示す。parentはSol/Astra、再委任しない末端担当にLunaを用いる。モデル値の正本は[各TOML](../dot_codex/agents/)、起動許可は[委任規約](../dot_codex/common/sub-agent.md.tmpl)である。

| 定義 | モデル / effort | 主な用途 |
| --- | --- | --- |
| `assistant-L` | GPT-6 Luna / low | 起点・parent専属の検索、限定読解、抽出、要約、差分整理 |
| `root-advisor` | GPT-6 Sol / medium | 否定された起点回答の限定再検討、成立条件・改善案、ルーティング補助 |
| `advisor` | GPT-6 Astra / medium | 明示された起点のparent兼務またはSol/Astra parentの専門難所の反証・再分析 |
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
| `implementation-worker-H` | GPT-6 Sol / high | 複雑な局所判断を含むImplementation成果単位、別担当としての必須レビュー（変更禁止） |
| `market-data-worker-L` | GPT-6 Luna / medium | 定義済み市場数値の取得・正規化・品質確認 |

L/M/Hは担当範囲の能力帯であり、モデル名やeffortの略ではない。GPT-6移行後はLとMが同じLuna/xhighを使う。Lは条件が明確な範囲、Mは探索・局所判断がより多い範囲として使い分ける。HはSolを使うが、接尾辞はhigh effortを意味しない。

## 行動規則の参照先

本書は編成比較と評価を扱う。対応順序や記録手順は次の正本を参照する。

| 論点 | 正本 |
| --- | --- |
| 通常対応、回答の再検討、parent兼務、原文の受け渡しと報告 | [起点規約](../dot_codex/common/root-agent.md.tmpl) |
| 起動権限、履歴許可、再利用、記録の配置・所有 | [委任規約](../dot_codex/common/sub-agent.md.tmpl) |
| 全ロールの条件付き成立を優先する姿勢 | [共通原則](../.chezmoitemplates/agent/codex/hypothesis.md) |
| 専門判断、検証、ドラフト・変更経緯・正式報告 | [parent本文](../.chezmoitemplates/agent/codex/parent.md) |
| 設計・実装完了の独立レビュー、通過条件と証跡 | [変更レビュー本文](../.chezmoitemplates/agent/codex/change-review.md) |
| childの選択とAstra相談後の検証・統合 | [parent委任規約](../.chezmoitemplates/agent/codex/parent-advanced.md) |
| Sol相談役の限定再検討とルーティング補助 | [root-advisor定義](../dot_codex/agents/root-advisor.toml.tmpl) |

## 評価計画

今回の変更は運用仮説であり、代表案件での小規模比較は未実施である。次の順序で評価する。

1. Sol/Astra parentとLuna末端担当の編成を代表案件で小規模比較する。起点モデルを取得できない場合は不明とし、推測しない。
2. 起点の履歴抽出、parentのドラフト品質、手戻り、コンパクション、チーム総消費、ユーザー介入、所要時間を取得できる範囲で記録する。
3. Sol/mediumの`root-advisor`を含む条件を確認した後、相談役のlow化を別条件として比較する。

設定変更だけで効率・品質改善を実証済みと扱わない。未取得の値、内部推論、キャッシュ効果は推測しない。

起点は比較指標の取得を理由に担当へ進捗照会しない。受信済み通知、完了報告、保存済み記録から取得できる値だけを使う。

## 検証の扱い

CIではsourceのTOMLを読み、parentが指定の9ロール・許可されたSol/Astraモデルであること、共通規約のinclude、廃止定義と専用規約への参照がないことを検査する。その後、既存のchezmoi描画とTOML構文検証を行う。ローカルではchezmoiを実行せず、sourceポリシー検査、include先・文書リンク・シナリオ照合、`git diff --check`を行う。

chezmoi実行、実環境への配布、起点の`config.toml`変更、実際の候補表示・起動、モデル適用、権限の実行時強制、性能比較は別作業である。sourceの静的検査結果をこれらの成功として扱わない。

## 受入ケース

以下は指示の静的な照合ケースであり、モデルの実応答試験ではない。

| 入力・状況 | 期待する対応 |
| --- | --- |
| 指定関数・指定入力で例外となる条件の列挙 | 外から問い・範囲・完了条件が与えられた限定調査として自処理できる |
| 指定箇所と期待結果がある修正 | 枠内で設計を具体化し、設計レビュー通過後に変更、完了レビュー通過後に引き渡す |
| 「原因を調べて修正」／最初の検索はすぐ終わる | 原因調査を先行せず、依頼全体のparentへの委任を確認する |
| 起点が案件を小さく分割すれば対応できそう | 自分で作った作業枠を自処理の許可に使わない |
| 枠内の調査で範囲拡大・全体方針の判断が必要になった | 判明事項と不足を返して止める。調査済みを続行の根拠にしない |
| 明示されたparent兼務 | 指定範囲で検討・判断し、終了後は通常対応に戻る。自己モデルの把握は不要 |
| 原文が失われた | 残存記録と明記し、復元しない。判断に影響する欠落は確認する |
| 報告の詳細にリンクできない | 許可された記録担当が安全な作業領域に保存する。リンクの捏造はしない |
| 小さな例外はあるが現実的な条件で成立する仮説 | 例外だけで否定せず、条件付き成立と補完案を示す |
| 成立に奇跡的な確率や極端な負担が必要 | 根幹を覆す因果と根拠を示し、否定または根本修正を提案する |
| childが局所的な懸念を見つけ、影響を判断できない | 証拠と未確認事項を返す。parentが影響・補完可能性を評価する |
| 通常起点の回答をユーザーが否定 | Sol `root-advisor` で限定再検討し、起点は要約と詳細リンクを伝える |
| 再検討に専門調査が必要 | 起点がparentへの委任をユーザーに確認する |
| parentが専門的な難所に直面 | Astra `advisor` に相談し、parentが検証・統合する。通常起点へ判断を戻さない |
| ユーザーが外部意見を引用 | ユーザー由来の検討入力として狙いを保ち、詳細を検証する。全項目の承認や否定探索へ読み替えない |
| 通常起点が変更を直接担当 | 自処理条件を満たすことに加え、変更禁止のimplementation-worker-Hへ両レビューを依頼する。実装委任や兼務へ広げない |
| parentが自処理／workerに実装を委任 | どちらも実装前の設計レビューと完了レビューが必要。workerは依頼元から通過通知を受けて実装する |
| typo修正・短い文書修正 | 資料を短くし、2段階を省略しない |
| lint/test成功／ユーザーが設計を承認 | 独立レビューの代替にしない |
| レビュー対象に未追跡の新規ファイルがある | 全変更の対象版に新規ファイルも含める |
| 判定が要修正・判定不能／レビュー担当を起動できない | 未通過として停止し、修正確認または不足解消を求める。自己レビューで迂回しない |
| 通過後に設計・差分が変更された | 設計変更は設計段階から、差分変更は完了段階を再レビューする |
| parentが結合時に対象を編集 | そのparentは対象の完了レビューを担当せず、別担当へ全成果を渡す |
| parentの完了報告にレビュー証跡がない | 起点はparentへ返す。起点が専門レビューを代行して完了扱いにしない |

## 過去の検討

- 2026-09-18以前はGPT-5.6 Sol/Terra/LunaをL/M/H能力帯へ対応させ、起点はSol/low、parentの委任入力は起点作成の指示書を中心にしていた。
- 2026-09-23にGPT-6へ移行し、旧Terra担当をLuna/xhighへ変更した。L/M名は互換性のため残し、モデル名から担当範囲の能力帯へ意味を整理した。
- 同日に起点をLuna/xhigh主体へ戻す方針（現在は廃止）、Sol/mediumの`root-advisor`、parent所有の不変な着手ドラフト・変更経緯・正式版の併存、起点の進捗照会廃止を導入した。
- 2026-09-24にLuna parentを廃止し、単純広域調査をSolへ統合した。起点をモデルに依存しないルーティング役とし、ユーザーの明示によるparent兼務と報告の必須詳細リンクを定めた。

- 2026-09-25に条件付き成立を優先する共通原則とSol相談役の限定再検討を追加し、保守ルールに沿って規則の正本を集約した。
- 2026-09-26に通常起点の実作業を外部指定の範囲に限定し、自己分割・先行調査による権限拡張を禁止した。起点・parent・実装workerに2段階の独立レビューを導入し、通常起点からの変更禁止レビュー依頼経路を追加した。モデル設定は変更していない。

モデル間・effort間の同等性や品質・価格の優劣は、この文書から保証しない。表示名の番号は個体識別用で、モデル適用や回答品質の証明ではない。
