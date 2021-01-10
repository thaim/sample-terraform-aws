ALB targetgroup/listener
==============================

ALBのターゲットグループがリスナー登録されていると
更新が面倒な問題を解決する検証リソース．

## リソースの構築
### terraformによるインフラの構築
terraform.tfvarsに変数を登録し， `terraform init && terraform apply` でインフラを構築する．

### ecspressoによるコンテナのデプロイ
タスク定義の登録 -> サービスの作成・更新の手順で操作する．

タスク定義の登録

$ ecspresso register --config config.yaml

サービスの作成

$ ecspresso create --config config.yaml

サービスの更新(サービス作成後設定変更する場合)

$ ecspresso deploy --config config.yaml

サービスの削除 (事前にdesiredCount: 0とする必要あり)

$ ecspresso delete --config config.yaml

タスク定義の削除は ecspressoではできない．
