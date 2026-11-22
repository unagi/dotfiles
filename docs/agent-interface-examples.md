# エージェント間通信の記入例

正本は[共通インターフェース](../.chezmoitemplates/agent/team/interface.md)。

### 記入例

以下は形式の説明であり、新たな権限や承認を与えない。

#### rootからParentへの方針検討

```text
Purpose and deliverable: Recommend a review format that helps users see what needs their decision.
Original request and context: User quote:「レビューが長くて、結局どこを見るべきか分からない。改善案を考えて」. Confirmed: proposal only. Root's interpretation: make decisions easy to find while keeping material risks visible. Working hypothesis: evidence and decision requests are currently mixed.
Scope and authorization: Read-only. Use review guidelines v1 and the two shared examples.
Decision latitude: Test the working hypothesis and identify other causes if supported. Choose which alternatives merit comparison. Recommend one direction with its tradeoffs. Changes require a separate instruction.
Acceptance and verification: A1: Identify the cause using the examples. A2: Recommend a format and show where a decision, a material risk, and detailed evidence would appear. The Parent verifies both against the guidelines and examples.
Inputs and handoff: Review guidelines v1 and examples A and B. Reply in this thread.
```

Parentは目的を引き継ぎ、決定事項が後ろに埋もれる仮説と、短い要約で重大リスクが落ちる仮説を比較する。照合を分担するときは次のように範囲を切り出す。

```text
Purpose and deliverable: Return a two-row evidence table for examples A and B.
Scope and authorization: Read-only. Inspect examples A and B and the material-risk rule in review guidelines v1.
Decision latitude: Identify where each example states the release decision and any blocking risk. Flag ambiguous wording to the Parent.
Acceptance and verification: For each row, give the decision location, the visible risk or a supported omission, and paragraph references. Recheck each reference.
```

Parentが候補の列挙だけで返した場合、rootは元のA2に照らして不足を具体的に伝える。

```text
Follow-up on A2 of the review format request: The options are clear. Recommend one based on both examples, and show where it puts the decision, blocking risks, and detailed evidence. Keep the read-only scope and explain any tradeoff that would change the recommendation.
```

Parentからrootへの結果例。

```text
Status: Complete.
Conclusion and deliverable: Lead with the decision and its material risks. Put the supporting evidence below. In example A, the release decision appeared after nine findings. In example B, a summary moved the decision up but omitted a blocking risk.
Acceptance: A1: Met, both examples show where the decision or risk was lost. A2: Met, the proposal gives each item a place and keeps the existing risk disclosure requirement.
Verification: Checked the order of both examples and the risk rule in review guidelines v1.
Open items and requests: No trial with live reviews. The proposal is ready for a direction decision.
```

#### Parentからworkerへの局所変更と検証

```text
Purpose and deliverable: Correct the documented timeout default.
Original request and context: User quote:「説明を30秒に直して」. Confirmed: the implementation default is 30 seconds.
Scope and authorization: Edit the timeout paragraph in docs/settings.md. Preserve other contributors' changes. Runtime changes are out of scope.
Decision latitude: Adjust surrounding wording for clarity. Raise any behavior discrepancy with the Parent.
Acceptance and verification: A1: The paragraph states 30 seconds. A2: Your diff is limited to that paragraph. Check both against reference v1 and the diff.
Inputs and handoff: Current workspace and reference v1. Return the diff location and checks in this thread.

Status: Complete.
Conclusion and deliverable: Corrected the timeout paragraph in docs/settings.md in the returned worktree.
Acceptance: A1: Met, the paragraph now gives 30 seconds. A2: Met, my diff touches only that paragraph.
Verification: Compared the paragraph with reference v1 and inspected the diff. Runtime testing was omitted for this documentation change.
Open items and requests: None.
```

#### 一部完了後の質問

上の依頼に、非公開資料v2との一致を確認するA3が加わった例。

```text
Status: Incomplete, awaiting requester action.
Conclusion and deliverable: A1 and A2 are complete. The edit is in the worktree.
Acceptance: A1 and A2: Met, see the diff and verification above. A3: Unverified.
Verification: Inspected the diff. Access to reference v2 was denied, so I could not compare its timeout paragraph.
Open items and requests: Can you share the timeout paragraph from v2? A3 depends on it. If v2 specifies a different default, I will report the discrepancy to you for a decision.
```

#### 同じ担当への訂正と再確認

```text
Correction to the timeout documentation request, targeting the worktree you returned: Use reference v2 for A3. User quote:「先ほどの資料は旧版です。最新版はv2です」. Reference v2 states: “The default timeout is 30 seconds.” Compare it with the existing edit and report the result. If it conflicts with the confirmed default, raise it with me. Keep the original edit scope and acceptance criteria A1 and A2.
```

回答はA3の結果と前回からの差分を示す。独立レビューが必要なら、Parentは原依頼・確定条件・解釈・修正後の対象版・成果・検証を独立Reviewerへ渡す。評価完了・要修正は有効な回答だが、成果の通過を意味しない。対象版や必要証拠が不足すれば、委任された評価が未完了なら対応待ちとし、判定不能の理由と不足を返す。

### 設計参考（2026-11-05）

[Superpowersの実装担当向け指示](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/implementer-prompt.md)と[レビュー指示](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/task-reviewer-prompt.md)から、依頼と回答の対応、状態・成果・検証・不足、原要求・自己申告・対象版の分離を参考にした。[oh-my-opencode-slimの統括指示](https://github.com/alvinunreal/oh-my-opencode-slim/blob/master/src/agents/orchestrator.ts)と[担当別回答](https://github.com/alvinunreal/oh-my-opencode-slim/blob/master/src/agents/role-prompts.ts)は、原文と解釈、範囲と検証責任、役割別回答の参考である。既存規約に合わせた独自構成であり、原文の移植や依存追加はしていない。自動昇格や承認・レビュー条件の変更は採用しない。モデル動作・費用・品質の改善は未実証。
