def commit_id
pipeline {
    agent any
    stages {
        
        stage('preparation') {
            steps {
                checkout scm
                sh "git rev-parse --short HEAD > .git/commit-id"
                script {
                    commit_id = readFile('.git/commit-id').trim()
                }
            }
        }

        stage ('code quality') {
            steps {
                echo 'testing code quality'
               sh "mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=position-similator \
                    -Dsonar.host.url=http://localhost:9000 \
                    -Dsonar.login=7691bcacb359c83701f0d2c15a014a98c4c50369"
                echo 'code quality test complete'
            }
        }

        stage ('build') {
            steps {
                echo 'building maven workload'
                sh "mvn clean install"
                echo 'build complete'
            }
        }

        stage ("image build") {
            steps {
                echo 'building docker image'
                sh "docker build -t position-simulator:${commit_id} ."
                echo 'docker image built'
            }
        }

        stage ("Deploy") {
            steps {
                echo 'Deploying in k8s'
                sh "sed -i -r 's|richardchesterwood/k8s-fleetman-position-simulator:release2|position-simulator:${commit_id}|' workloads.yaml"
                sh "kubectl apply -f workloads.yaml"
                sh "kubectl apply -f services.yaml"
                sh "kubectl get all"
                echo 'Deployment complete'
            }
        }
    }
}
