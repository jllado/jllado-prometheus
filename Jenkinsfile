pipeline {
    agent any
    environment {
        APP_NAME = "${env.JOB_NAME}"
    }
    stages {
        stage ('deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl patch svc ${APP_NAME} -p \'{"spec": {"type": "LoadBalancer", "externalIPs":["\'${KUBERNETES_SERVER}\'"]}}\''
                timeout(2) {
                    waitUntil {
                       script {
                         def podsDown = sh script: 'kubectl get pods -l app=${APP_NAME} | grep "0/1" | wc -l | head -c 1', returnStdout: true
                         return (podsDown == '0');
                       }
                    }
                }
            }
        }
        stage ('restart') {
            steps {
                sh "curl -sS -X POST http://${KUBERNETES_SERVER}:9090/-/reload"
            }
        }
    }
    post {
        always {
            script {
                sh "curl -sS -X POST -H \"Content-Type: application/json\" -d '{\"text\": \"${env.JOB_NAME} ${currentBuild.result}\"}' http://${KUBERNETES_SERVER}:50000/notification"
            }
        }
    }
}
