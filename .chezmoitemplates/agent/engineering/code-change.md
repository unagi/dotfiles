# コード変更

- `common/change-control.md` の承認条件を守る。`common/development.md` と対象言語の `languages/java.md`・`python.md`・`node.md` を読む。既読不変なら再読不要。
- 依頼側の仕様・受入条件・検証対象に沿って実装し、判断を変える不足は依頼元へ戻す。
- 変更前に `common/investigation.md` で関連コード・履歴・類似箇所を調査する。
- 同じ箇所の2回目修正では設計上の原因を見直す。局所workerは方針を独断で変えず、根拠と改善案を依頼元へ返す。
- テスト・lintの前は `common/tdd.md`・`common/lint.md` を読む。Git変更操作の前は `common/git.md` を読む。既存仕様の検証を理由にテスト変更を承認不要にしない。
