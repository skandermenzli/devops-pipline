pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven-3.9.2"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/skandermenzli/devops-pipline']])

                // Run Maven on a Unix agent.
                //sh "mvn -Dmaven.test.failure.ignore=true clean package"

                // To run Maven on a Windows agent, use
                 bat "mvn clean install"
            }

        }
        stage('Build docker image') {
            steps {
                bat "docker build -t skandermenzli/my-maven-app ."
            }
        }
        stage('Push image to hub'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) {
                        bat 'docker login -u skandermenzli -p password'}
                    bat 'docker push skandermenzli/my-maven-app'
                }
            }
        }
        stage('Deploy WordPress') {
            steps {
                script {
                    // Authenticate with Kubernetes cluster
                    sh 'kubectl config set-cluster YOUR_CLUSTER_NAME'
                    sh 'kubectl config set-credentials YOUR_CLUSTER_CREDS'
                    sh 'kubectl config set-context YOUR_CLUSTER_CONTEXT'
                    sh 'kubectl config use-context YOUR_CLUSTER_CONTEXT'
                    
                    // Apply Kubernetes manifests for WordPress deployment
                    sh 'kubectl apply -f tp3/configmap.yaml'
                    sh 'kubectl apply -f tp3/secret.yaml'
                    sh 'kubectl apply -f tp3/mysql-pv.yaml'
                    sh 'kubectl apply -f tp3/mysql-deployment.yaml'
                    sh 'kubectl apply -f tp3/wp-pv.yaml'
                    sh 'kubectl apply -f tp3/wp-deployment.yaml'
                    
                    // Other steps like waiting for deployment to complete, etc.
                }
            }
        }
    }
}
