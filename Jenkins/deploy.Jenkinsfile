pipeline {
    agent any

    options {
        timestamps()
    }
    stages {
        stage('Repo clone') {
            steps {
                git branch: 'main', credentialsId: 'yegorovev-gh', poll: false, url: 'https://github.com/yegorovev/DevTestSecOps.git'
            }
        }
        stage('TF init') {
            steps {
                script {
                    if(!fileExists("$WORKSPACE/.ssh/ec2-key.pub"))
                    {
                        sh 'mkdir $WORKSPACE/.ssh; cp /tmp/*ec2-key.pub $WORKSPACE/.ssh/ec2-key.pub'
                    }
                }
                dir('TF') {
                    sh 'terraform init'
                }
            }
        }
        stage('TF execute') {
            steps {
                dir('TF') {
                    sh "terraform $TFexecute -auto-approve -var ext_ip=$ext_ip -var first_name=$first_name -var last_name=$last_name"
                }
            }
        }
     }
}
