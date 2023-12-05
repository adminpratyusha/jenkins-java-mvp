@Library('shared-library') _
pipeline {
  triggers {
    githubPush()
  }
  agent any
  environment {
    IMAGE_NAME = 'pratyusha2001/mvpjava'
    NEXUS_VERSION = "nexus3"
    NEXUS_PROTOCOL = "http"
    NEXUS_REPOSITORY = "mvp-java-develop"
    NEXUS_REPO_ID = "mvp-java-develop"
    NEXUS_CREDENTIAL_ID = "nexuslogin"
    DOCKER_CREDENTIALS_ID = 'dockercred' // Update this with your actual Jenkins credentials ID
    ARTVERSION = "${env.BUILD_ID}"
  }
  stages {
    stage('BUILD') {
      steps {
        script {
          maven.build()
        }
      }
      post {
        success {
          echo 'Now Archiving...'
          archiveArtifacts artifacts: '**/target/*.war'
        }
      }
    }
    stage('OWASP Dependency-Check Vulnerabilities') {
      steps {
        script {
          dependencycheck.owaspdependency()
        }
      }
    }
    stage('UNIT TEST') {
      steps {
        script {
          maven.unittest()
        }
      }
    }

    stage('INTEGRATION TEST') {
      steps {
        script {
          maven.integrationtest()
        }
      }
    }
    stage('CODE ANALYSIS with SONARQUBE') {
      environment {
        scannerHome = tool 'sonar-scanner'
      }

      steps {
        script {
          withSonarQubeEnv('sonarqube') {
            sonarqube.sonarscanner('Java', 'java')
          }
        }
      }
    }
    stage("Publish to Nexus Repository Manager") {
      steps {
        script {
          withCredentials([string(credentialsId: 'nexusurl', variable: 'NEXUS_URL')]) {
            nexusrepo.nexus(NEXUS_URL,env.BUILD_ID)

          }
        }
      }
    }
    stage('DOCKER BUILD & PUSH') {
      steps {
        script {

          dockertask.dockertask(env.IMAGE_NAME, env.BUILD_ID, env.DOCKER_CREDENTIALS_ID)
        }
      }
    }

  }
}
