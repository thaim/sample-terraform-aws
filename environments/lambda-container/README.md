lambda by container
==============================

AWS Lambda関数をコンテナイメージでデプロイするterraformコード．

## Lambda関数概要
CloudWatch Eventsから定期的にLambda関数を呼び出す．
Lambda関数はメッセージをログ出力する．

## lambda関数によるイメージ指定

Lambda関数を `package_type = Image` を作成する場合，
コンテナイメージを指定する必要があり，ECRだけでは作成できない．


```
│ Error: Error describing ECR images: ImageNotFoundException: The image with imageId {imageDigest:'null', imageTag:'latest'} does not exist within the repository with name 'sample-lambda-container' in the registry with id 'XXXXX'
│
│   with data.aws_ecr_image.sample_latest,
│   on ecr.tf line 14, in data "aws_ecr_image" "sample_latest":
│   14: data "aws_ecr_image" "sample_latest" {
│```

Lambda関数のコンテナイメージの指定は自前で準備する必要がある．

https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-create.html

> Lambda 関数の作成は、Amazon ECR のコンテナレジストリと同じアカウントから実行する必要があることにご注意ください

このため，方針としては以下の3つがある．

* local-exec でECRレジストリ作成と同時にイメージを作成する
* docker providerでイメージまで作成する
* ダミーECRレジストリおよびコンテナイメージを準備しておく

### 外部のダミーECRレジストリおよびコンテナイメージを準備しておく
一番シンプルなのは事前に専用のダミーコンテナイメージを準備しておく方法．
ダミーメージをデプロイ時に合わせて構築することは難しく，
lambdaの仕様上AWS公式のイメージ等を利用することはできない．
このため自分で事前にイメージを構築しておく．



### local-exec でECRレジストリ作成と同時にイメージを作成する

TerraformCloudでは利用できない

https://www.terraform.io/docs/cloud/run/install-software.html
https://discuss.hashicorp.com/t/how-to-run-an-aws-cli-command-with-local-exec-in-terraform-cloud/7426/3

### docker providerでイメージまで作成する


## 参考
* [Using container images with Lambda](https://docs.aws.amazon.com/lambda/latest/dg/lambda-images.html)
* [2020-12-04][AWS Lambda の新機能  コンテナイメージのサポート](https://aws.amazon.com/jp/blogs/news/new-for-aws-lambda-container-image-support/)
* [2019-12-11][TerraformでAWS ECRのリポジトリを作成してpushする](https://qiita.com/hayaosato/items/d6049cf68c84a26845d2)
* [2020-12-25][AWS Lambda をコンテナイメージで動かすときの Terraform の書き方](https://goropikari.hatenablog.com/entry/aws_lambda_container)
