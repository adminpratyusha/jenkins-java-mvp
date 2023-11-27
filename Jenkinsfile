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
	    // stage('CODE ANALYSIS with SONARQUBE') {
     //      		  environment {
     //         scannerHome = tool 'sonar-scanner'
     //      }

     //      steps {
     //        withSonarQubeEnv('sonarqube') {
     //           sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
     //               -Dsonar.projectName=java \
     //               -Dsonar.projectVersion=1.0 \
     //               -Dsonar.sources=src/ \
     //               -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
     //               -Dsonar.junit.reportsPath=target/surefire-reports/ \
     //               -Dsonar.jacoco.reportsPath=target/jacoco.exec \
     //               -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
     //        }

           
     //      }
     //    }
	    // stage("Publish to Nexus Repository Manager") { 
	    //  steps {
     //           script {
		   //     withCredentials([string(credentialsId: 'nexusurl', variable: 'NEXUS_URL')]) {

     //                pom = readMavenPom file: "pom.xml";
     //                filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
     //                echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
     //                artifactPath = filesByGlob[0].path;
     //                artifactExists = fileExists artifactPath;
     //                if(artifactExists) {
     //                    echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
     //                    nexusArtifactUploader(
     //                        nexusVersion: NEXUS_VERSION,
     //                        protocol: NEXUS_PROTOCOL,
     //                        nexusUrl: NEXUS_URL,
     //                        groupId: pom.groupId,
     //                        version: pom.version,
     //                        repository: NEXUS_REPOSITORY,
     //                        credentialsId: NEXUS_CREDENTIAL_ID,
     //                        artifacts: [
     //                            [artifactId: pom.artifactId,
     //                            classifier: '',
     //                            file: artifactPath,
     //                            type: pom.packaging],
     //                            [artifactId: pom.artifactId,
     //                            classifier: '',
     //                            file: "pom.xml",
     //                            type: "pom"]
     //                        ]
     //                    );
     //                } 
		   //  else {
     //                    error "*** File: ${artifactPath}, could not be found";
     //                }
     //            }
	    //    }
     //        }
     //    }
	    // stage('DOCKER BUILD & PUSH') {
     //        steps {
     //            script {
    
     //                // Assuming your Dockerfile is in the root directory of your project
     //                def dockerImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}")

                    
     //                docker.withRegistry('https://registry.hub.docker.com', 'dockercred') {
     //                    dockerImage.push()
     //                }
     //            }
            }
        }
        }
    }

