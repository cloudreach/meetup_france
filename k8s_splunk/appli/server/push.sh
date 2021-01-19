set -ex
region="eu-west-1"
accountId=$(aws sts get-caller-identity --query "Account" --output text)
registry="${accountId}.dkr.ecr.${region}.amazonaws.com"
image="server"
set +e
aws ecr create-repository --repository-name ${image} 2> /dev/null
set -e
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${registry}
docker tag ${image} ${registry}/${image}
docker push ${registry}/${image}