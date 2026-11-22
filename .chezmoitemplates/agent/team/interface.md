# エージェント間の共通インターフェース

エージェント間で使う英語の形式。原文・訂正・資料は必要な箇所を元の言語で引用し、確定条件や解釈と分ける。人への質問・回答は共通原則に従う。

## 委任指示

送り手が、受け手の判断と着手に必要な情報を選ぶ。短い依頼では各項目を1行で示す。

```text
Purpose and deliverable: Goal and expected result.
Original request and context: Relevant quotes, confirmed facts, and interpretation.
Scope and authorization: Target, ownership, exclusions, approved actions.
Decision latitude: Settled direction, local decisions, escalation.
Acceptance and verification: Criteria, evidence, who checks it.
Inputs and handoff: References, version, return destination if needed.
```

- 目的・対象・裁量・受入条件は必須。変更なしは `Read-only`。参照は読める場所・箇所と必要な版を示す。複数の受入条件はA1、A2等で回答と対応させる。
- 追加指示・訂正は元の依頼と対象版、変更点、必要な対応を示す。その他の条件は継続する。新担当には必要な条件を渡す。
- 質問は範囲内の確認後に、必要な情報・決定、影響、提示できる案、先に進める範囲を伝える。軽微な書式差では止めない。

## 結果回答

```text
Status: Complete or incomplete (in progress or awaiting requester action).
Conclusion and deliverable: Result, location, version.
Acceptance: Each criterion, status (met, unmet, unverified), evidence.
Verification: Checks, results, omissions and reasons.
Open items and requests: Outstanding work, blockers, action needed.
```

- 完了は受領した仕事の自己申告で、受入・レビュー判定とは別。必須条件の未充足・未確認は未完了。進行中は作業継続時に使う。
- 長い成果は要約と参照を返す。参照のみの担当は本文で返し、必要なら保存を依頼する。
- 検証には対象・方法・結果を示し、コマンドには終了状態と必要な出力・参照を添える。未実施・失敗を区別し、現版に有効な証拠を使う。
- 対応待ちは済んだ成果を保持し、不足・影響・試したこと・依頼元に求める対応を示す。
