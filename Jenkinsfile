pipeline{
  agent any

  environment{
        DOCKER_USERNAME = credentials('DOCKER_USERNAME')
        DOCKER_PASSWORD = credentials('DOCKER_USERNAME')
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  stages {

    stage("Pull project from github") {
      steps {

        git branch: 'main', url:'https://github.com/Antwi-tech/MyPortfolio.git'

    }
       }
    stage("Docker login and create the container"){

      steps {
        sh '''
        docker login -u $DOCKER_USERNAME -p DOCKER_PASSWORD
        build -t $DOCKER_USERNAME/my_portfolio:v1  
        docker push $DOCKER_USERNAME/my_portfolio:v1

        '''
      }
    }

  stage("Deploy to S3-bucket using terraform")  {
    steps {

       sh '''
                set -e

                # 1. Pull the app container from Docker Hub
                docker pull $DOCKER_USERNAME/my_portfolio:v1

                # 2. Create a temp folder to extract app files
                rm -rf app_extract
                mkdir app_extract

                # 3. Copy files from container to host
                container_id=$(docker create $DOCKER_USERNAME/my_portfolio:v1)
                docker cp $container_id:/usr/share/nginx/html ./app_extract
                docker rm $container_id

                # 4. Run Terraform to create the S3 bucket
                cd terraform
                terraform init
                terraform plan -var="bucket_name=my-portfolio-bucket-12345"
                terraform apply -var="bucket_name=my-portfolio-bucket-12345" -auto-approve

                # 5. Upload extracted app files to the S3 bucket
                aws s3 sync ../app_extract/html s3://my-portfolio-bucket-12345/ --delete
                '''

    }
  }
  }
    
}

