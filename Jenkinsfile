
pipeline {
  agent {
          kubernetes {
            label 'dockerPod'
            yaml """
              apiVersion: v1
              kind: Pod
              spec:
                containers:
                - name: docker
                  image: docker
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                    - name: docker-sock
                      mountPath: '/var/run/docker.sock'
                - name: maven
                  image: maven:3.6.3-jdk-8-openj9
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                    - name: docker-sock
                      mountPath: '/var/run/docker.sock'
                - name: helm
                  image: dtzar/helm-kubectl
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                    - name: docker-sock
                      mountPath: '/var/run/docker.sock'
                volumes:
                  - name: docker-sock
                    hostPath:
                      path: '/var/run/docker.sock'
                      type: File
              """
            }
        }
  environment {
    scannerHome = tool 'SonarQubeRunner'
    time_tracker_Image = ''
  }
  tools {
    maven 'Maven 3.6.3'
  }
  
  stages {
    stage('Get_Sources') {
      steps {
        git(url: 'https://github.com/saharon27/chuck-norris-jokes-docker.git', branch: 'master', credentialsId: 'GitHub_Creds_HTTPS')
      }
    }

    stage('Build Maven') {
      steps {
        echo 'Building Maven...'
        sh 'mvn -Dmaven.test.failure.ignore=true package'
      }
    }
   stage('SonarQube Analysis') {
     steps {
       echo "Scanning with SonarQube..."
       withSonarQubeEnv(credentialsId: 'SonarQube_Token', installationName: 'SonarQube') {
       sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.6.0.1398:sonar'
      }
     }
    }
    stage('Publish war file to Nexus') {
      steps{
        echo "Publish war file to Nexus Maven-Releases repository..."
        nexusPublisher nexusInstanceId: 'nexus_server', nexusRepositoryId: 'maven-releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: 'war', filePath: '/home/jenkins/agent/workspace/Chuck_Norris/target/chuck-yanko.war']], mavenCoordinate: [artifactId: 'chuck-yanko', groupId: 'ChuckGroup', packaging: 'war', version: '0.1.0']]]      
      }
    }
    stage('Dockerize App') {
      steps{
        container('docker') {
          echo "Creating Docker image..."
          sh 'docker build -f DockerFile -t chuck-yanko:0.1.0 .'   
        }
      }
    }
    stage('Upload Docker to Nexus Repository') {
      steps{
        container('docker') {
          echo "Uploading Docker image to Nexus Repository..."
          withCredentials([usernamePassword(credentialsId: 'nexus_creds', usernameVariable: 'USER', passwordVariable: 'PASSWORD')]) {
            sh 'docker login -u $USER -p $PASSWORD nexus-docker.minikube'
            sh 'docker image tag chuck-yanko:0.1.0 nexus-docker.minikube/chuck-yanko:0.1.0'
            sh 'docker push nexus-docker.minikube/chuck-yanko:0.1.0'
            sh 'docker rmi -f $(docker images --filter=reference="nexus-docker.minikube/chuck-yanko*" -q)'
          }
        }   
      }
    }
    stage('Deploy App') {
      steps{
        container('helm') {
          https://github.com/saharon27/helm-charts.git
          echo "Deploying your app on cluster"
          sh 'helm repo add myhelmrepo https://saharon27.github.io/helm-charts/'
          sh 'helm repo update'
          sh 'helm install chucknorris myhelmrepo/chuckjokes'
         }
       }
     }
   }
 
/*  post {
      success {
          mail to: 'sharonisgizmo@yahoo.com',
                  subject: "passed Pipeline: ${currentBuild.fullDisplayName}",
                  body: "Build is OK with ${env.BUILD_URL}"
        }
      failure {
          // notify users when the Pipeline fails
          mail to: 'sharonisgizmo@yahoo.com',
                  subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                  body: "Something is wrong with ${env.BUILD_URL}"
        }
    }*/
}
