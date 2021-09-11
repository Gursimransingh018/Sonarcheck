def getDockerTag(){
def tag = sh script: 'git rev-parse HEAD', returnStdout: true
return tag
}
pipeline {
agent any
environment{
Docker_tag = getDockerTag()
}
stages {
stage('Quality Gate status check') {
steps{
script{
withSonarQubeEnv('sonarqube_scanner') {
sh "mvn sonar:sonar"
}
timeout(time: 5, unit: 'MINUTES') {
def qg = waitForQualityGate()
if (qg.status != 'OK') {
error "Pipeline aborted due to quality gate failure: ${qg.status}"
}
}
sh "mvn clean install"
}
}
stage('build'){
steps{
script{
sh 'docker build . -t gursi05/Sonar_Pipeline:$Docker_tag'
sh 'docker login -u gursi05 -p shinchan@20'
sh 'docker push gursi05/Sonar_Pipeline:$Docker_tag'
}
}
}
}
}
}
