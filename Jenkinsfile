pipeline {

  options {
    ansiColor('xterm')
  }

  environment {
    registry = "$REGISTRY"
    registryCredential = "$REGISTRY_CREDENTIALS"
    kubeConfig = "$KUBECONFIG"
    image = "$IMAGE"
  }

  agent {
    kubernetes {
      label "kaniko"
      defaultContainer "jnlp"
      yaml """

"""
    }
  }

  stages {

    stage('Checkout Source') {
      steps {
        checkout scm
      }
    }

    stage('Build Image and Push to Registry') {
          steps {
            container('kaniko') {
              script {
                sh '''
                  /kaniko/executor \
                    --dockerfile `pwd`/Dockerfile \
                    --context `pwd`/ \
                    --verbosity debug \
                    --destination $REGISTRY/$IMAGE:v0.1.0 \
                    --destination $REGISTRY/$IMAGE:latest
                '''
              }
            }
          }
        }

    stage('Deploy App') {
      steps {
       container('kubectl') {
         withCredentials([file(credentialsId: 'kubeconfig-string-pjl', variable: 'KUBECONFIG')]) {
           sh 'kubectl apply hello.yaml'
         }
      }
    }
  }
}
