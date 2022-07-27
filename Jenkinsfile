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
      yamlFile 'builder.yaml'
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
            container(name: 'kaniko', shell: '/busybox/sh') {
                sh '''#!/busybox/sh
                  /kaniko/executor \
                    --dockerfile `pwd`/Dockerfile \
                    --context `pwd`/ \
                    --verbosity debug \
                    --destination $REGISTRY$IMAGE:v0.1.0 \
                    --destination $REGISTRY$IMAGE:latest
                '''
            }
          }
        }

    stage('Deploy App') {
      steps {
        container('kubectl') {
          withCredentials([file(credentialsId: $KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
           sh 'kubectl apply -f hello.yaml'
          }
        }
      }
    }

  }
}
