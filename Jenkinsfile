pipeline{
    agent any
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages{
        stage("Build"){
            steps{
                echo "Build Docker Image with Dockerfile..."
                sh 'docker build -t naveenv/ecommerce-app:${BUILD_NUMBER} .'
            }
        }
        stage("Test"){
            steps{
                echo "Pushing Docker Image to Docker Hub Repo..."
                withCredentials([usernamePassword(credentialsId: 'Docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                sh "echo $PASS | docker login -u $USER --password-stdin"
                sh 'docker tag naveenv/ecommerce-app:${BUILD_NUMBER} naveenv3112/ecommerce-app:${BUILD_NUMBER}'
                sh 'docker push naveenv3112/ecommerce-app:${BUILD_NUMBER}'
                }
            }
        }
        stage("Deploy"){
            steps{
                echo "Deploying the application to EC2..."
                withCredentials([file(credentialsId: 'ec2-pem-file', variable: 'PEM_FILE')]) {
                    sh '''
                        ssh -i $PEM_FILE -o StrictHostKeyChecking=no ubuntu@43.205.36.232 << 'EOF'
                        docker pull naveenv3112/ecommerce-app:${BUILD_NUMBER}
                        docker stop ecommerce-app || true
                        docker rm ecommerce-app || true
                        docker run -d --name ecommerce-app -p 80:8000 naveenv3112/ecommerce-app:${BUILD_NUMBER}
                        EOF
                    '''
                }
            }
        }
    }
}
