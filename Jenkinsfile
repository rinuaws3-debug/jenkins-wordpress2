pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rinuaws/jenkins-wordpress" // your DockerHub repo
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
                sh 'docker build -t $DOCKER_IMAGE:$BUILD_NUMBER .'
            }
        }

        stage('Docker Push') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-cred', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:$BUILD_NUMBER'
                    sh 'docker tag $DOCKER_IMAGE:$BUILD_NUMBER $DOCKER_IMAGE:latest'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    # Stop existing containers but keep volumes (persistent data)
                    docker compose -f docker-compose.yml down || true
          
                    # Build (optional) and start all services in detached mode
                    docker compose -f docker-compose.yml up -d --build
                '''
            }
        }
    }
}

