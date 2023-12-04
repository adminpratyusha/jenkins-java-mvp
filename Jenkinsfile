pipeline {
    agent any
    environment {
        SSHCONFIGNAME = 'sshtest'
        NEXUS_URL = 'http://34.42.7.89:8081/repository/mvp-java-release'
        GROUP_ID = 'com/visualpathit/vprofile'
        VERSION = '1.0-23'
    }
    parameters {
        string(name: 'VERSION', defaultValue: '1.0-23', description: 'Enter the version along with build id')
    }

    stages {
        stage('Download artifact from Nexus') {
            steps {
                script {
                    sh "curl -v -o vprofile.war -u admin:admin ${NEXUS_URL}/${GROUP_ID}/${VERSION}/${outputFile}"

                    if (fileExists(outputFile)) {
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
                    ])])
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                script {
                    def outputFile = "vprofile.war"
                    sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME ,
                        transfers: [sshTransfer(flatten: false, sourceFiles: outputFile)])
                    ])
                }
            }
        }

        stage('Start tomcat') {
            steps {
                script {
                    sshPublisher(publishers: [sshPublisherDesc(configName: SSHCONFIGNAME, transfers: [
                        sshTransfer(
                            execCommand: "sudo cp -rf /home/ubuntu/* /var/lib/tomcat9/webapps && rm -rf /home/ubuntu/* && sudo systemctl restart tomcat9",
                            execTimeout: 120000
                        )
                    ])])
                }
            }
        }
    }
} 
