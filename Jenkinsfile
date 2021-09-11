
pipeline {
agent any
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
}
}
