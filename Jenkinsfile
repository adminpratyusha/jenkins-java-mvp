
pipeline {
        triggers {
    pollSCM('* * * * *') // Enabling being build on Push
	}
	agent any
    stages{
        
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
	    stage('DOCKER BUILD & PUSH') {
            steps {
                script {
    // some block}
                    // Assuming your Dockerfile is in the root directory of your project
                    def dockerImage = docker.build("username/test:${env.BUILD_ID}")

                    
                    docker.withRegistry('https://registry.hub.docker.com', 'dockercred') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
