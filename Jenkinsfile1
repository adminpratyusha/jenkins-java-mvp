pipeline {
    agent any
    environment {
        SSHCONFIGNAME='sshtest'
        GROUP_ID = 'com/visualpathit/vprofile'
         OUTPUTFILENAME = 'vprofile.war'
         ARTIFACT_NAME='vprofile'

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
   
                  def artifact_version = "${ARTIFACT_NAME}-${params.VERSION}.war"
                  sh "curl -v -o ${OUTPUTFILENAME} -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} ${NEXUS_URL}/${GROUP_ID}/${VERSION}/${artifact_version}"
                     }
                             


        }
            }
        }
        
        stage('Stop tomcat and remote old version files') {
            steps {
                script {
                      sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME , transfers: [
                                    sshTransfer(
                                        execCommand: "sudo systemctl stop tomcat9 && sudo rm -rf /var/lib/tomcat9/webapps/*",
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
                        transfers: [sshTransfer(flatten: false, sourceFiles: OUTPUTFILENAME)])
                    ])


                }
            }
        }
        
         stage('start tomcat') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME, transfers: [
                                    sshTransfer(
                                        execCommand: "sudo cp -rf /home/ubuntu/* /var/lib/tomcat9/webapps && rm -rf /home/ubuntu/* && sudo systemctl start tomcat9",
                                        execTimeout: 120000
                                    )
                                ])
                    ])
                }
               
                
            }
        }
    } 
    }
