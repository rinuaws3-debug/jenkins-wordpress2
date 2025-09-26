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
                    echo "Deploying WordPress with Docker Compose..."

                    # Stop existing containers but keep volumes (persistent data)
                    docker compose -f docker-compose.yml down || true

                    # Pull the latest image (ensures it’s up to date)
                    docker compose -f docker-compose.yml pull

                    # Start all services in detached mode
                    docker compose -f docker-compose.yml up -d
                '''
            }
        }
    }
}

