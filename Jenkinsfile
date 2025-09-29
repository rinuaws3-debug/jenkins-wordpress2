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
                // Wrap the SSH command in sshagent so Jenkins uses your EC2 private key
                sshagent(['ec2-ssh']) {
                    sh '''
                         # Copy the docker-compose.yml from Jenkins workspace to EC2
                         scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@65.0.3.57:/home/ubuntu/wordpress/docker-compose.yml

                         # Run Docker Compose on EC2
                         ssh -o StrictHostKeyChecking=no ubuntu@65.0.3.57 '
                           cd /home/ubuntu/wordpress &&
                           docker compose down || true &&
                           docker compose pull &&
                           docker compose up -d
                        '
                    '''
                }
            }
        }
    }
}

