pipeline {
    agent any

    environment {
        PACKAGE_NAME = 'mvp-java-release'
        OUTPUTFILENAME="vprofile-1.0.war"
        SSHCONFIGNAME='sshtest'
        GROUP_ID = 'com/visualpathit/vprofile'

    }

    parameters {
        string(name: 'VERSION', defaultValue: '1.0-23', description: 'Enter the version along with build id')
    }

    stages {
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                    
                    withCredentials([
                        string(credentialsId: 'nexusurl', variable: 'NEXUS_URL'),
                        string(credentialsId: 'nexusrepo-release', variable: 'NEXUS_REPO_ID'),
                        string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
                        string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME')
                    ]) {

  sh "curl -v -o ${OUTPUTFILENAME} -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} ${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${GROUP_ID}/${PACKAGE_NAME}/${PACKAGE_NAME}-${VERSION}"                    


        }
            }
        }
        }
        stage('Stop tomcat and remote old version files') {
            steps {
                script {
                      sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME , transfers: [
                                    sshTransfer(
                                        execCommand: "sudo systemctl stop tomcat9 -y && sudo rm -rf /var/lib/tomcat9/webapps/*",
                                        execTimeout: 120000
                                    )
                                ])
                    ])
                
                }
               
                
            }
        }
        

      
    }}
