node{
    def buildNumber = BUILD_NUMBER
    stage("Git CheckOut"){
        git url: 'https://github.com/piyalondhe/pipeline.git',branch: 'main'
    }
    
    stage(" Maven Clean Package"){
      sh "mvn clean package"
    } 
    
    stage("Build Dokcer Image") {
         sh "docker build -t piya29/my-webapp:${buildNumber} ."
    }
    
    stage("Docker Push"){
        withCredentials([string(credentialsId: 'docker-account', variable: 'Docker_Hub_Pwd')]) {
          sh "docker login -u piya29 -p ${Docker_Hub_Pwd}"
        }
        sh "docker push piya29/my-webapp:${buildNumber}"
        
    }
    
    // Remove local image in Jenkins Server
    stage("Remove Local Image"){
        sh "docker rmi -f  piya29/my-webapp:${buildNumber}"
    }
    
    stage("Deploy to docker swarm cluster"){
        sshagent(['Docker_Swarm_Manager_Dev']) {
            sh "ssh ec2-user@3.94.103.214 docker service create --name javawebapp -p 8080:8080 --replicas 2 piya29/my-webapp:${buildNumber}"
        }
    }
}
