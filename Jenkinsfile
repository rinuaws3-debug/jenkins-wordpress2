pipeline {
    agent any

    environment {
        // Change this to your Docker Hub repo
        DOCKER_IMAGE = "rinuaws/jenkins-wordpress"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rinuaws3-debug/jenkins-wordpress2.git',
                    credentialsId: 'github-cred'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "Building WordPress Docker image..."
                    docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-cred', url: '']) {
                    sh '''
                        echo "Pushing Docker image to Docker Hub..."
                        docker push $DOCKER_IMAGE:$BUILD_NUMBER
                        docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest
                        docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                // If deploying to a remote EC2 instance, wrap in sshagent()
                // sshagent(['ec2-ssh']) { ... }

                sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@13.232.101.128 '
                  cd /home/ubuntu/wordpress   # folder on EC2 where docker-compose.yml lives
                  docker compose down || true
                  docker compose pull
                  docker compose up -d
                '
                '''
            }
        }
    }
}

