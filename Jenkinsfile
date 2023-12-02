pipeline {
    agent any

    environment {
        SSHCONFIGNAME='sshtest'
        GROUP_ID = 'com/visualpathit/vprofile'
        NEXUS_URL = 'nexusurl'
        NEXUS_REPO_ID = 'nexusrepo-release'
        NEXUS_USERNAME = 'nexususername'
        NEXUS_PASSWORD = 'nexuspassword'
        OUTPUTFILENAME = 'vprofile-1.0.war'

    }
    parameters {
        string(name: 'VERSION', defaultValue: '1.0-23', description: 'Enter the version along with build id')
    }

    stages {
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                    
                    def nexusArtifactUrl = "${NEXUS_URL}/repository/${NEXUS_REPO_ID}/${GROUP_ID}/${VERSION}"
                    
                    echo "Downloading artifact from: ${nexusArtifactUrl}"

                    sh "curl -v -o ${OUTPUTFILENAME} -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} ${nexusArtifactUrl}"
                    
                    // Check if the artifact download was successful
                    if (fileExists(OUTPUTFILENAME)) {
                        echo "Artifact downloaded successfully."
                    } else {
                        error "Failed to download artifact."
                    }                 


        }
            }
        }
        }
        // stage('Stop tomcat and remote old version files') {
        //     steps {
        //         script {
        //               sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME , transfers: [
        //                             sshTransfer(
        //                                 execCommand: "sudo systemctl stop tomcat9 -y && sudo rm -rf /var/lib/tomcat9/webapps/*",
        //                                 execTimeout: 120000
        //                             )
        //                         ])
        //             ])
                
        //         }
               
                
        //     }
        // }
        

      
    }}
