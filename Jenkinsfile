pipeline {
    agent any

    tools {
        maven "my_maven"
    }

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/sanjayras/banking-project.git'
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }        
        }
        
        stage('Create Docker Image') {
            steps {
                sh 'docker build -t sanjayras/financeme:1.0 .'
            }
        }
        
        stage('Docker-Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'docker_passvar', usernameVariable: 'docker_usrvar')]) { 
                    sh '''
                        echo $docker_passvar | docker login -u $docker_usrvar --password-stdin
                    '''
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
                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        credentialsId: 'awslogin', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ),
                    file(credentialsId: 'bank_pem', variable: 'PEM_KEY')
                ]) {
                    dir('Terraform_files') {
                        sh '''
                            cp $PEM_KEY bank.pem
                            chmod 600 bank.pem
                            terraform init
                            terraform validate
                            terraform apply --auto-approve
                        '''
                    }
                }
            }
        }
    }
}
