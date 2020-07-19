pipeline {

  environment {
    registry = "$REGISTRY"
    registryCredential = "$REGISTRY_CREDENTIALS"
    kubeConfig = "$KUBECONFIG"
    image = "$IMAGE"
  }

  agent {
    kubernetes {
      cloud "$PYTHON_FASTAPI_HELLO_BUILD_CLOUD"
      label "$PYTHON_FASTAPI_HELLO_BUILD_CONTAINER"
      defaultContainer "$PYTHON_FASTAPI_HELLO_BUILD_CONTAINER"
    }
  }

  stages {

    stage('Checkout Source') {
      steps {
        checkout scm
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build image + ":$BUILD_NUMBER"
          // Check the /data volume mount.  Keep track of versions.
          sh 'ls -alh /data'
          sh 'echo "`date +%Y%m%d%H%M`-$BUILD_NUMBER" >> /data/versions.txt'
          sh 'cat /data/versions.txt'
        }
      }
    }

    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( registry, registryCredential ) {
            dockerImage.push()
            dockerImage.push("latest")
          }
        }
      }
    }

    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "hello.yaml", kubeconfigId: kubeConfig)
        }
      }
    }

  }
}
