pipeline {
    agent any
    environment {
        SSHCONFIGNAME='sshtest'
        GROUP_ID = 'com/visualpathit/vprofile'
        OUTPUTFILENAME = 'vprofile-1.0.war'

    }
    parameters {
        string(name: 'VERSION', defaultValue: '1.0-23', description: 'Enter the version along with build id')
    }

    stages {
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                    withCredentials([
                        string(credentialsId: 'nexusdownloadurl', variable: 'NEXUS_URL'),
                        string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME'),
                        string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
                        string(credentialsId: 'nexusrepo-release', variable: 'NEXUS_REPO_ID')
                    ])
                    {
   
                   
                    
                 sh "curl -v -o ${OUTPUTFILENAME} -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} ${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${GROUP_ID}/${VERSION}"
                    }
                    if (fileExists(OUTPUTFILENAME)) {
                        echo "Artifact downloaded successfully."
                    } else {
                        error "Failed to download artifact."
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
        stage('Deploy to VM') {
            steps {
                script {
                 
                    sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME ,
                        transfers: [sshTransfer(flatten: false, sourceFiles: "vprofile-1.0.war")])
                    ])


                }
            }
        }

    } 
    }
