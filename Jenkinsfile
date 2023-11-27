@Library('shared-library') _
  pipeline {
  //      triggers {
  //   // pollSCM('* * * * *') // Enabling being build on Push
  // }
agent any
	environment {
		IMAGE_NAME = 'pratyusha2001/mvpjava'
		NEXUS_VERSION = "nexus3"
                NEXUS_PROTOCOL = "http"
                // NEXUS_URL = "34.42.7.89:8081"
                NEXUS_REPOSITORY = "mvpjava"
	        NEXUS_REPO_ID    = "mvpjava"
                NEXUS_CREDENTIAL_ID = "nexuslogin"
                ARTVERSION = "${env.BUILD_ID}"
	}
	stages{
        stage('BUILD'){
            steps {
		    script{
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
		 steps{  
			script{
				dependencycheck.owaspdependency()
			}
      }
   }
	    stage('UNIT TEST'){
            steps {
		script{
                   maven.unittest()	  
		    }
	    }
        }
 
	  stage('INTEGRATION TEST'){
            steps {
		  script{
                   maven.integrationtest()	  
		    }
	    }
        }
	    stage('CODE ANALYSIS with SONARQUBE') {
          		  environment {
             scannerHome = tool 'sonar-scanner'
          }

          steps {
		  script{
            withSonarQubeEnv('sonarqube') {
		    sonarqube.sonarscanner('Java','java')
	    }
            }
                 }
        }
	    stage("Publish to Nexus Repository Manager") { 
	     steps {
               script {
		       withCredentials([string(credentialsId: 'nexusurl', variable: 'NEXUS_URL')]) {
                       nexusrepo.nexus('NEXUS_URL')

                }
	       }
            }
        }
	    // stage('DOCKER BUILD & PUSH') {
     //        steps {
     //            script {
    
     //                // Assuming your Dockerfile is in the root directory of your project
     //                def dockerImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}")

                    
     //                docker.withRegistry('https://registry.hub.docker.com', 'dockercred') {
     //                    dockerImage.push()
     //                }
     //            }
        //     }
        // }
        }
    }

