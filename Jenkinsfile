pipeline {
  agent any
  stages {
    stage('Create AMI') {
      steps {
        echo "Build AMI"
        withCredentials([
          usernamePassword(credentialsId: 'aws_packer', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_ACCESS'),
          sshUserPrivateKey(credentialsId: "PackerTest", keyFileVariable: 'keyfile')
        ]) {
          sh 'packer build -var "efs_volume=${EFS_VOLUME}" -var aws_secret_key=${AWS_SECRET} -var aws_access_key=${AWS_ACCESS} ecs_stage.json'
        }
      }
    }
    stage('Approval') {
      steps {
        mail to: 'scott.eppler@dunkinbrands.com',
             from: 'jenkins@dunkinbrands.com',
             subject: "Build ${JOB_BASE_NAME} needs approval",
             body: "Please approve ${BUILD_URL}input"
        input "Deploy to AWS?"
      }
    }
    stage('AWS Deployment') {
      steps {
          echo "Deploy"
      }
    }
  }
  post {
      success {
        mail to: 'scott.eppler@dunkinbrands.com',
             from: 'jenkins@dunkinbrands.com',
             subject: "Build ${JOB_BASE_NAME} finished successfully",
             body: "You can see the log at ${BUILD_URL}console"
      }
      failure {
        mail to: 'scott.eppler@dunkinbrands.com',
             from: 'jenkins@dunkinbrands.com',
             subject: "Build ${JOB_BASE_NAME} failed",
             body: "You can see the log at ${BUILD_URL}console"
      }
  }
}
