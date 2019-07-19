pipeline {
  agent { dockerfile true }
  environment {
      AWS_ACCESS_KEY_ID     = credentials('aws_packer_access_key')
      AWS_SECRET_ACCESS_KEY = credentials('aws_packer_secret_key')
  }
  stages {
    stage('Create AMI') {
      steps {
        echo "Build AMI"
        withCredentials([
          sshUserPrivateKey(credentialsId: "PackerTest", keyFileVariable: 'PackerTestPem')
        ]) {
          sh "cat ${PackerTestPem} > PackerTest.pem"
          sh "/usr/local/bin/packer build -var efs_volume=${EFS_VOLUME} -machine-readable ecs_stage.json | tee build.log"
          sh "grep 'artifact,0,id' build.log | awk -F',' '{print \$6}' | awk -F':' '{print \$2}' > ami_id.txt"
        }
      }
    }
    stage('Test AMI') {
      steps {
          sh "aws ec2 run-instances --image-id \$(cat ami-id.txt) --region us-east-1 --count 1 --instance-type t2.micro --key-name PackerTest --security-group-ids sg-07be025cd45c13f15 sg-0b61b8be23cfe7e91 --subnet-id subnet-f5dc57af --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=${BUILD_TAG}-test}]'"
          sh "aws ec2 describe-instances --filters 'Name=tag:Name,Values=${BUILD_TAG}-test' --output text --query 'Reservations[*].Instances[*].InstanceId') > instance_id.txt"
          sh """
            RUNNING=\$false
            while [ !\$RUNNING ]; do
              status=\$(aws ec2 describe-instance-status --instance-ids \$(cat instance_id.txt) --output text --query 'InstanceStatuses[*].InstanceStatus.Status')
              if [ \$status == 'ok' ]; then
                RUNNNING=\$true
              else
                sleep 10
            done
            """
      }
    }
    stage('Approval') {
      steps {
        mail to: 'scott.eppler@dunkinbrands.com',
             from: 'jenkins@dunkinbrands.com',
             subject: "Build ${JOB_BASE_NAME} ${BUILD_DISPLAY_NAME} needs approval",
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
