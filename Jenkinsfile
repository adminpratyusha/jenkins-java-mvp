@Library('shared-library') _
pipeline {
    agent any
    environment {
        SSHCONFIGNAME='sshtest'
        GROUP_ID = 'com/visualpathit/vprofile'
         OUTPUTFILENAME = 'vprofile.war'
         ARTIFACT_NAME='vprofile'

    }


    stages {
        // stage('set environment'){    
        //       steps {
        //         script {
        //              if (params.ENVIRONMENT == "QA") {
        //                 SSHCONFIGNAME = 'QACRED'
        //             } else if (params.ENVIRONMENT == "Pre-Prod") {
        //                 SSHCONFIGNAME = 'PREPRODCRED'
        //             } else {
        //                 SSHCONFIGNAME = 'PRODCRED'
        //             }
        //             echo "SSH Configuration Name: ${SSHCONFIGNAME}"
 
 
        // }
        //       }
        // }    
        stage('Download artifact from Nexus') {
            steps {
                script {
                
                     withCredentials([
                         string(credentialsId: 'developdownloadurl', variable: 'NEXUS_URL'),
                         string(credentialsId: 'nexususername', variable: 'NEXUS_USERNAME'),
                         string(credentialsId: 'nexuspassword', variable: 'NEXUS_PASSWORD'),
                     ])
                     {
                        downloadnexusartifact.download(OUTPUTFILENAME,NEXUS_USERNAME,NEXUS_PASSWORD,NEXUS_URL,env.GROUP_ID,params.buildID,ARTIFACT_NAME)
                
                     }
             }
            }
        }
        
        stage('Stop tomcat and remote old version files') {
            steps {
                script {
                     stoptomcat.stop(SSHCONFIGNAME)
                
                }
               
                
            }
        }
        stage('Deploy to VM') {
            steps {
                script {
                    deploytoVM.deploy(SSHCONFIGNAME,OUTPUTFILENAME)
                }
            }
        }
        
         stage('start tomcat') {
            steps {
                  script {
                     starttomcat.start(SSHCONFIGNAME)
                }
               
                
            }
        }
    } 
    }
