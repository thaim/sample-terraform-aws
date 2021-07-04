lambda by container
==============================

AWS Lambda関数をコンテナイメージでデプロイするterraformコード。
特に対象のコンテナイメージをterraformの管理から外したい場合における
初期構築方法についての検証。

## lambda関数によるイメージ指定
Lambda関数を `package_type = Image` で作成する場合、
コンテナイメージを指定する必要があり、ECRだけでは作成できない。

```hcl
resource "aws_lambda_function" "sample" {
  function_name = "sample-container"
  role          = aws_iam_role.lambda.arn

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.sample_prepared.repository_url}:latest"
}
```


```
aws_lambda_function.sample_prepared: Creating...
╷
│ Error: error creating Lambda Function (1): InvalidParameterValueException: Source image xxxxxxxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sample-prepared:latest does not exist. Provide a valid source image.
│ {
│   RespMetadata: {
│     StatusCode: 400,
│     RequestID: "4c6a36d1-1ed8-4c2a-959a-50f8b066d21d"
│   },
│   Message_: "Source image xxxxxxxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sample-prepared:latest does not exist. Provide a valid source image.",
│   Type: "User"
│ }
│
│   with aws_lambda_function.sample_prepared,
│   on external_registry.tf line 3, in resource "aws_lambda_function" "sample_prepared":
│    3: resource "aws_lambda_function" "sample_prepared" {
│
```

このため、有効なコンテナイメージを準備しておきLambda関数を構築可能とする必要がある。
このコンテナイメージにはAWSが提供してくれるイメージなどは利用できず、
対象のAWSアカウントに自分で準備する必要がある。

https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-create.html

> Lambda 関数の作成は、Amazon ECR のコンテナレジストリと同じアカウントから実行する必要があることにご注意ください

以上から、対策方針としては以下の3つがある。

* ダミーECRリポジトリおよびコンテナイメージを準備しておく
* local-exec でECRレジストリ作成と同時にイメージを作成する
* docker providerでイメージまで作成する

### 外部のダミーECRレジストリおよびコンテナイメージを準備しておく
一番シンプルなのは事前に専用の[ダミーコンテナイメージを準備しておく方法](external_registry.tf)。
ダミーメージをデプロイ時に合わせて構築することは難しく、
lambdaの仕様上AWS公式のイメージ等を利用することはできない。
このため自分で事前にイメージを構築しておく。

手作業でECRレジストリを作成し、適当なイメージをlatestタグでプッシュしておく。
初回構築時のみLambda関数がこのコンテナイメージをロードするが、
以降はlifecycleで指定している通り無視されるので、
別のイメージタグを指定しようが異なるリポジトリのイメージを指定しようが無視される。

この方法はシンプルで手軽に対応可能な一方で、
手動でECRリポジトリの作成とイメージのpushが必要であること、
初回構築のためだけに別のECRリポジトリへの依存を明記する必要があるといった気持ち悪さがある。
実際に利用しているECRリポジトリが指定されていないことは誤解を生じやすいのでできれば避けたい。

### local-exec でECRレジストリ作成と同時にイメージを作成する
初回構築のためだけに別ECRリポジトリを準備・利用するのは気持ち悪いので
初回構築時に同一ECRリポトリにダミーイメージを格納する。
こういった操作には[local-execが便利なのでこれで実現](local_exec.tf)する

この方法を利用することで lambda関数のイメージ指定先として実際に利用するECRリポジトリを指定できる。
事前の操作も不要であり構築も容易である。

課題として、動作環境にawscliおよびdocker cliが必要なことが挙げられる。
通常の開発環境であれば存在を仮定しても問題なさそうだが、これが問題になるのがTerraformCloud環境である。
TerraformCloud への追加ソフトウェアインストールについては[ドキュメント](https://www.terraform.io/docs/cloud/run/install-software.html
)にまとめられているが、
基本的に非推奨でありさまざまな制約も存在する。
やはり[AWS CLIが欲しいという意見](https://discuss.hashicorp.com/t/how-to-run-an-aws-cli-command-with-local-exec-in-terraform-cloud/7426/3
)は挙がっているようだが、
TerraformCloud環境でaws cli や docker cli を利用する方針は避けた方がよさそう。

### docker providerでイメージまで作成する
local-execを利用すればLambda関数の構築に必要なダミーdockerイメージを生成・格納できるが
Terraformの実行環境に追加ソフトウェアの依存が生まれてしまう。
これを解決する方法として、terraformでdockerイメージを制御する [terraform-provider-docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs) を利用する。
[docker providerを利用](docker_provider.tf)することで、追加でのawscliやdocker cliなしにdockerイメージのpushが可能になる。

ここで一番実現したいことは、DockerHub上のalpineイメージを対象のECRリポジトリにコピーすること。
しかし、docker providerではこのような機能は[議論されているが実装さていない](https://github.com/kreuzwerker/terraform-provider-docker/issues/137)。
このため、ダミーのDockerfileにてコンテナイメージビルドした上で、そのイメージをECRリポジトリにpushすることで実現する。

この方法であれば追加でaws cliや docker cliは不要でdocker providerを追加すれば解決できる。
ただし、hashicorp管理ではない別のproviderへ依存することになるのでこれを許容できるかが鍵となる。

## 参考
* [Using container images with Lambda](https://docs.aws.amazon.com/lambda/latest/dg/lambda-images.html)
* [Installing Software in the Run Environment](https://www.terraform.io/docs/cloud/run/install-software.html)
* [2020-12-04][AWS Lambda の新機能  コンテナイメージのサポート](https://aws.amazon.com/jp/blogs/news/new-for-aws-lambda-container-image-support/)
* [2019-12-11][TerraformでAWS ECRのリポジトリを作成してpushする](https://qiita.com/hayaosato/items/d6049cf68c84a26845d2)
* [2020-12-25][AWS Lambda をコンテナイメージで動かすときの Terraform の書き方](https://goropikari.hatenablog.com/entry/aws_lambda_container)
* [2020-04-07][How to run an AWS CLI command with local-exec in Terraform cloud?](https://discuss.hashicorp.com/t/how-to-run-an-aws-cli-command-with-local-exec-in-terraform-cloud/7426)
