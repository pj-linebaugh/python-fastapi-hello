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
      defaultContainer "jnlp"
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins-build: app-build
    some-label: "build-app-${BUILD_NUMBER}"
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.5.1-debug
    imagePullPolicy: IfNotPresent
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
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
            container(name: 'kaniko', shell: '/busybox/sh') {
              withEnv(['PATH+EXTRA=/busybox']) {
                sh '''#!/busybox/sh -xe
                  /kaniko/executor \
                    --dockerfile Dockerfile \
                    --context `pwd`/ \
                    --verbosity debug \
                    --insecure \
                    --skip-tls-verify \
                    --destination $REGISTRY/$IMAGE:v0.1.0 \
                    --destination $REGISTRY/$IMAGE:latest
                '''
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
