AWS_ACCOUNT=0123456789
-include .env

help: ## Show help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## build docker image
	docker build \
		-t ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-prepared \
		-t ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-localexec \
		app

login: ## login to ECR registry
	aws ecr get-login-password | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com

push: ## push docker image to ECR repository
	docker push ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-prepared:latest
	docker push ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-localexec:latest

lambda: ## update lambda functions
	aws lambda update-function-code --function-name sample-container-prepared  --image-uri ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-prepared:latest
	aws lambda update-function-code --function-name sample-container-localexec --image-uri ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/sample-localexec:latest
