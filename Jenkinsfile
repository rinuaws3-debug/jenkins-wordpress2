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
                  docker rm -f wp || true
                  docker rm -f wpdb || true

                  # Run MySQL (if not using external DB)
                  docker run -d \
                    --name wpdb \
                    -e MYSQL_DATABASE=wpdb \
                    -e MYSQL_USER=wpuser \
                    -e MYSQL_PASSWORD=wppass \
                    -e MYSQL_ROOT_PASSWORD=rootpass \
                    mysql:8.0

                  # Run WordPress container
                  docker run -d \
                    -p 8082:80 \
                    --name wp \
                    --link wpdb:mysql \
                    -e WORDPRESS_DB_HOST=wpdb:3306 \
                    -e WORDPRESS_DB_USER=wpuser \
                    -e WORDPRESS_DB_PASSWORD=wppass \
                    -e WORDPRESS_DB_NAME=wpdb \
                    $DOCKER_IMAGE:$BUILD_NUMBER
                '''
            }
        }
    }
}

