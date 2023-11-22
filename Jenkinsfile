
pipeline {
       
	agent any
	environment {
		IMAGE_NAME = 'pratyusha2001/mvpjava'
		NEXUS_VERSION = "nexus3"
                NEXUS_PROTOCOL = "http"
                NEXUS_URL = "35.232.107.144:8081"
                NEXUS_REPOSITORY = "mvpjava"
	        NEXUS_REPO_ID    = "mvpjava"
                NEXUS_CREDENTIAL_ID = "nexuslogin"
                ARTVERSION = "${env.BUILD_ID}"
	}
    stages{
                stage('Checkout') {
            steps {
                checkout scm
            }
			when {
        expression { env.CHANGE_ID != null }
    }
        stage('BUILD'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

	stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }
 
	stage('INTEGRATION TEST'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
	stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } 
		    else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
	    stage('DOCKER BUILD & PUSH') {
            steps {
                script {
    
                    // Assuming your Dockerfile is in the root directory of your project
                    def dockerImage = docker.build("${env.IMAGE_NAME}:${env.BUILD_ID}")

                    
                    docker.withRegistry('https://registry.hub.docker.com', 'dockercred') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
