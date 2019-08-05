# sample-terraform-aws
sample terraform script for AWS


## how to use
各environment環境にて，以下を実行する：

```
$ terraform init -backend-config=backend.tfvars
$ terraform plan
$ terraform apply
```

検証が終わったら削除する

```
$ terraform destroy
```


## terraforming
必要に応じてterraformingで構築した環境からterraformスクリプトを生成する．
