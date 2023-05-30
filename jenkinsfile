pipeline {
    agent any
    tools {
        maven 'maven_3_9_2'
    }
    environment {
        def imageName = "jhonattan25/app-microservicios-eureka-server"
        def date = new Date().format('yyyyMMdd')
        def release = "${env.BUILD_NUMBER}"
        def releaseId = "${env.BUILD_ID}"

        PROJECT_ID = 'grupor3microservicios'
        CLUSTER_NAME = 'apps-microservicios-cluster-1'
        LOCATION = 'us-central1-c'
        CREDENTIALS_ID = 'kubernetesGKE'
    }
    stages {
        stage('Build Maven') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Jhonattan25/eurekaserver.git']])
                sh 'mvn clean install'
            }
        }
        stage ('Build docker image') {
            environment {
                def imageTag = "${imageName}:${releaseId}-${date}-r${release}"
            }
            steps {
                script {
                    sh "docker build -t ${imageTag} ."
                }
            }
        }
        stage('Push image to DockerHub') {
            environment {
                def imageTag = "${imageName}:${releaseId}-${date}-r${release}"
            }
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhubpwd', variable: 'dockerhubpwd')]) {
                        sh 'docker login -u jhonattan25 -p ${dockerhubpwd}'
                        sh "docker push ${imageTag}"
                    }
                }
            }
        }
        stage('Deploy to K8s') {
            environment {
                def tag = "${releaseId}-${date}-r${release}"
            }
            steps{
                echo "Deployment started ..."
                sh 'ls -ltr'
                sh 'pwd'
                sh "sed -i 's/tagversion/${tag}/g' deployment/eureka-server.yaml"
                step([$class: 'KubernetesEngineBuilder', \
                  projectId: env.PROJECT_ID, \
                  clusterName: env.CLUSTER_NAME, \
                  location: env.LOCATION, \
                  manifestPattern: 'deployment/eureka-server.yaml', \
                  credentialsId: env.CREDENTIALS_ID, \
                  verifyDeployments: true])
            }
        }
    }
    
    post {
        always {
            deleteDir() // Eliminar el directorio de trabajo después de finalizar el pipeline
        }
        success {
            echo 'El pipeline se ha ejecutado exitosamente' // Notificar que el pipeline fue exitoso
        }
        failure {
            echo 'El pipeline ha fallado' // Notificar que el pipeline ha fallado
        }
    }
}
