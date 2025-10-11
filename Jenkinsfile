pipeline {
    agent any

    tools {
        maven "my_maven"
    }

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/rohinicbabu/star-agile-banking-finance.git'
                sh "mvn -Dmaven.test.failure.ignore=true clean package"

            }        
        }
       stage('Create Docker Image') {
           steps {
               sh 'docker build -t sanjayras/sanjayras/financeme:1.0 .'
                    }
                }
       stage('Docker-Login') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'docker_passvar', usernameVariable: 'docker_usrvar')]) { 
               sh 'docker login -u ${docker_usrvar} -p ${docker_passvar}'
                                   }
                        }
                }
       stage('Push-Image') {
           steps {
               sh 'docker push sanjayras/financeme:1.0'
                     }
                }
         stage('Deployment and Configuration') {
            steps {
                
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awslogin', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('Terraform_files') {
                    sh 'sudo chmod 600 bank.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
}
    }
}
}
}
}
