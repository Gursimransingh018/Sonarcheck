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
}
stage('build'){
steps{
script{
sh 'docker build . -t gursi05/sonar:$Docker_tag'
sh 'docker login -u gursi05 -p shinchan@20'
sh 'docker push gursi05/sonar:$Docker_tag'
}
}
}
}
stage('ansible playbook'){
steps{
script{
sh '''final_tag=$(echo $Docker_tag | tr -d ' ')
echo ${final_tag}test
sed -i "s/docker_tag/$final_tag/g"  deployment.yaml
'''
ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
}
}
}
}
}
