# 実作業の入口

利用中製品のcommon配下で、該当する資料だけを行為前に読む。複合作業では組み合わせ、既読不変なら再読しない。変更前は必ず `change-control.md` の承認条件を確認する。

| 業務 | 参照先 |
| --- | --- |
| コード調査のみ | `investigation.md` |
| コード変更 | `code-change.md` |
| 文書・設定変更 | `document-config.md` |
| Web・UI/UXの企画・制作・批評 | `design.md` |
| テスト追加・変更・実行 | `tdd.md` |
| lint | `lint.md` |
| Git変更操作 | `git.md` |
| API・設定・CLIの仕様確認、Web参照 | `technical-reference.md` |
| 画面操作・ネットワークコマンド・作業領域外への書込み・中間保存・権限拒否 | `operations.md` |

必要本文・権限が不足したら該当行為を停止し、影響と必要な対応を返す。
