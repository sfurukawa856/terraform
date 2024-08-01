resource "aws_iam_user" "user" {
  name          = var.user_name
  force_destroy = true
}

# gpgキー取得手順
# 1. 「gpg --gen-key」でIDとメールアドレスを登録。※パスワードは不要
# 2. 「gpg --list-keys」で確認
# 3. 「gpg -o furukawa_dev.public.gpg --export furukawa_dev」で公開鍵を取得（バイナリデータ）
# 4. filebase64メソッドでbase64に変換して読み込む
# 5. パスワードを確認するためにoutputし、結果をtxtファイルにペーストしておく
# 6. 「cat password.txt | base64 -d | gpg -r furukawa_dev --decrypt」を実行して復号
# 7. 復号に失敗した場合：秘密鍵のエクスポートするため「gpg --export-secret-keys -a furukawa_dev > secret_key.asc」を実行
# 8. 「gpg --import secret_key.asc」で秘密鍵をインポート
# 9. 「gpg --edit-key furukawa_dev」を実行してパスフレーズを設定
# 10. 「gpgconf --kill gpg-agent」「gpg-agent --daemon」でGPGエージェントを再起動
# 11. 再び「cat password.txt | base64 -d | gpg -r furukawa_dev --decrypt」を実行する。

resource "aws_iam_user_login_profile" "login_profile" {
  user                    = aws_iam_user.user.name
  pgp_key                 = filebase64("./modules/iam_user/cert/furukawa_dev.public.gpg")
  password_length         = 20
  password_reset_required = true
}

resource "aws_iam_user_group_membership" "admin_membership" {
  user = aws_iam_user.user.name
  groups = [
    aws_iam_group.admin_group.name
  ]
}
