pipeline {
  agent any

  environment {
    DOCKER_USERNAME = credentials('DOCKER_USERNAME')
    DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }

  stages {
    stage("Pull project from GitHub") {
      steps {
        git branch: 'main', url:'https://github.com/Antwi-tech/MyPortfolio.git'
      }
    }

    stage("Docker login and create the container") {
      steps {
        sh '''
          docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
          docker build -t $DOCKER_USERNAME/my_portfolio:v1 .
          docker push $DOCKER_USERNAME/my_portfolio:v1
        '''
      }
    }

    stage("Deploy to S3-bucket using Terraform") {
      steps {
        sh '''
          set -e
          docker pull $DOCKER_USERNAME/my_portfolio:v1
          rm -rf app_extract
          mkdir app_extract
          container_id=$(docker create $DOCKER_USERNAME/my_portfolio:v1)
          docker cp $container_id:/usr/share/nginx/html ./app_extract
          docker rm $container_id
          cd terraform
          terraform init
          terraform plan -var="bucket_name=my-portfolio-bucket-12345"
          terraform apply -var="bucket_name=my-portfolio-bucket-12345" -auto-approve
          aws s3 sync ../app_extract/html s3://my-portfolio-bucket-12345/ --delete
        '''
      }
    }
  }
}
