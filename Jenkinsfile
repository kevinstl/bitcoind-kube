pipeline {

  agent {
    label "jenkins-go"
  }
  environment {
    ORG               = 'kevinstl'
    APP_NAME          = 'lightning-kube-bitcoind'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    DEPLOY_PVC        = 'false'
    DEPLOY_SIMNET     = 'false'
    DEPLOY_REGTEST    = 'true'
    DEPLOY_TESTNET    = 'false'
    DEPLOY_MAINNET    = 'false'
  }
  stages {

    stage('Determine Environment') {
      steps {
        script {
          kubeEnv = sh(returnStdout: true, script: 'echo "${KUBE_ENV}"')
        }
        echo "kubeEnv: ${kubeEnv}"
      }
    }

    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
        PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
        HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
      }
      steps {
        container('go') {
//          sh "mvn versions:set -DnewVersion=$PREVIEW_VERSION"
          //sh "mvn install"
          //sh "./build.sh container prod verify"
//          sh "./build.sh container prod package"

          sh "make build"

          sh 'export VERSION=$PREVIEW_VERSION && skaffold build -f skaffold.yaml'

          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:$PREVIEW_VERSION"
        }

        dir ('./charts/preview') {
          container('go') {
            sh "make preview"
            sh "jx preview --app $APP_NAME --dir ../.."
          }
        }
      }
    }


    stage('Build Release Feature') {
      when {
        branch 'feature-*'
      }
      steps {
        script {
          release(null)
        }
      }
    }

    stage('Build Release Master') {
      when {
        branch 'master'
      }
      steps {
        script {
          release('master')
        }
      }
    }

    stage('Promote to Environments Feature') {
      when {
        branch 'feature-*'
      }
      steps {
        script {
          if (kubeEnv?.trim() != 'local') {
            promote()
          }
        }
      }
    }

    stage('Promote to Environments Master') {
      when {
        branch 'master'
      }
      steps {
        script {
          if (kubeEnv?.trim() != 'local') {
            promote()
          }
        }
      }
    }

    stage('Deploy Local') {
      steps {
        script {
          if (kubeEnv?.trim() == 'local') {
            sh 'echo  DEPLOY_PVC: ${DEPLOY_PVC}'
            sh 'echo  DEPLOY_SIMNET: ${DEPLOY_SIMNET}'
            sh 'echo  DEPLOY_REGTEST: ${DEPLOY_REGTEST}'
            sh 'echo  DEPLOY_TESTNET: ${DEPLOY_TESTNET}'
            sh 'echo  DEPLOY_MAINNET: ${DEPLOY_MAINNET}'

            if (DEPLOY_SIMNET == 'true') {
              container('go') {
                sh './undeploy-helm.sh "" lightning-kube simnet ${DEPLOY_PVC} || true'
                sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) lightning-kube-bitcoind-local LoadBalancer 30080 simnet ${DEPLOY_PVC}'
              }
            }
            if (DEPLOY_REGTEST == 'true') {
              container('go') {
                sh './undeploy-helm.sh "" lightning-kube simnet ${DEPLOY_PVC} || true'
                sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) lightning-kube-bitcoind-local LoadBalancer 30080 regtest ${DEPLOY_PVC}'
              }
            }
            if (DEPLOY_TESTNET == 'true') {
              container('go') {
                sh './undeploy-helm.sh "" lightning-kube testnet ${DEPLOY_PVC} || true'
                sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) lightning-kube-bitcoind-local LoadBalancer 30080 testnet ${DEPLOY_PVC}'
              }
            }
            if (DEPLOY_MAINNET == 'true') {
              container('go') {
                sh './undeploy-helm.sh "" lightning-kube mainnet ${DEPLOY_PVC} || true'
                sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) lightning-kube-bitcoind-local LoadBalancer 30080 mainnet ${DEPLOY_PVC}'
              }
            }
          }
        }
      }
    }

    stage('Push Local') {
      steps {
        script {
          if (kubeEnv?.trim() == 'local') {
            container('go') {
              sh "echo branch: ${env.BRANCH_NAME}"
              sh "./push.sh ${env.BRANCH_NAME}"
            }
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    failure {
      input """Pipeline failed.
We will keep the build pod around to help you diagnose any failures.

Select Proceed or Abort to terminate the build pod"""
    }
  }
}

def release(branch) {

  container('go') {
    // ensure we're not on a detached head
    //sh "git checkout master"

    if (branch?.trim()) {
      sh "git checkout $branch"
    }

    sh "git config --global credential.helper store"
    sh "jx step git credentials"

    // so we can retrieve the version in later steps
    sh "echo \$(jx-release-version) > VERSION"
//    sh "mvn versions:set -DnewVersion=\$(cat VERSION)"
  }

  dir ('./charts/lightning-kube-bitcoind') {
    if (kubeEnv?.trim() != 'local') {
      container('go') {
        sh "make tag"
      }
    }
  }

  container('go') {
    //sh 'mvn clean deploy'
    //sh "./build.sh container prod verify -DskipTests"

    sh "ls -al"

    //sh "./build.sh container prod package -DskipTests"

//    sh "./build.sh container prod package"

    sh "make build"

    sh 'export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml'

//    sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"

    postBuild()
  }



}

def promote() {

  dir ('./charts/lightning-kube-bitcoind') {
    container('go') {
      sh 'jx step changelog --version v\$(cat ../../VERSION)'

      // release the helm chart
      sh 'jx step helm release'

      // promote through all 'Auto' promotion Environments
      sh 'jx promote --verbose -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
    }
  }

}

def postBuild() {
  script {
    if (kubeEnv?.trim() != 'local') {
      sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
    }
  }
}


