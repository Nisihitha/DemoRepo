def DEPLOY_BRANCH = 'main'

def awsTenantDetails;
def VERSION_NO = "";
def BASE_VERSION='1.0';
@Library('shared-library')_

//pass parameter as graphql/backend/ui/lamda/ansible/spark
jenkinsAWSInputParameters  'ui'

pipeline {
  agent {
    label 'built-in'
  }
  options {
    disableConcurrentBuilds()
    timeout(time: 1, unit: 'HOURS')
    buildDiscarder(logRotator(numToKeepStr: '3'))
  }
  stages {
      stage('CREATE & PUSH TAG'){
          when {
            expression {env.BRANCH_NAME == DEPLOY_BRANCH }
          }
          steps{
            script{
                VERSION_NO = gitTag "${BASE_VERSION}";
            }
          }
    }
    stage('prepare'){
      steps {
        nodejs('NodeJS') {
          sh 'npm install'
        }
      }
    }
    stage('build number'){
      steps {
        updateBuildNumber "${VERSION_NO}";
      }
    }
    stage('compile') {
      steps {
        nodejs('NodeJS') {
          sh 'node --max_old_space_size=8048 node_modules/@angular/cli/bin/ng build'
        }
      }
    }
 

//   stage('GET TENANT INFO FROM PLATFORM'){
//           when {
//             expression {env.BRANCH_NAME == DEPLOY_BRANCH }
//           }
//         steps{
//         withCredentials([usernamePassword(credentialsId: "${params.MASTER_ACCOUNT_NAME}-marketplace-user", passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
//           script{
//                 sh 'chmod 755 cloud/aws/platform-cli.sh'
//                 sh "./cloud/aws/platform-cli.sh -t ${params.MASTER_ACCOUNT_NAME} -e ${params.AWS_ENV} -k ${PASSWORD}"
//               }
//           }
//         }
//       }
    stage('Set environment variable'){
      when{
        branch DEPLOY_BRANCH
      }
      steps{
        script{
        withAWS(region:"${params.AWS_REGION}",credentials:"${params.AWS_ENV}"){
            sh 'chmod 755 cloud/aws/tenant-aws-cli.sh'
            sh './cloud/aws/tenant-aws-cli.sh'

            awsTenantDetails = readJSON file: 'cloud/aws/tenant-aws-data.json'
            echo " DATABASE_URL : ${awsTenantDetails.DATABASE_URL}"
        }
       }
      }
    }
    stage('Run Sql Script'){
      when{
        branch DEPLOY_BRANCH
      }
      steps{
        script{
          withAWS(region:"${params.AWS_REGION}",credentials:"${params.AWS_ENV}"){
            sh "sed -i  's/%ENVIRONMENT%/${params.AWS_ENV}/g;s/%CLOUD_REGION%/${params.AWS_REGION}/g;s/%VERSION_NUMBER%/${VERSION_NO}/g;s/%CLOUD_PROVIDER%/aws/g;s/%DOMAIN%/${params.DOMAIN}/g;' db/demo2_configuration.sql"
            sh 'psql postgresql://'+"${awsTenantDetails.DATABASE_URL}"+'/'+"${awsTenantDetails.DATABASE_NAME}"+' -f db/demo2_configuration.sql'
          }
        }
      }
    }
    stage('deploy') {
      when{
        branch DEPLOY_BRANCH
      }
      steps {
        script {
          try{
            withAWS(credentials:"${params.AWS_ENV}"){
					   // sh "aws s3 sync --delete --cache-control max-age=31556926 dist/. s3://${params.AWS_REGION}-neo-${params.AWS_ENV}-datalake/"
			        sh "demo.2/"
              distributionID = sh(script: 'aws cloudfront list-distributions --query "DistributionList.Items[*].{Domain: join(\', \', Aliases.Items), DistributionID: Id}[?contains(Domain, \'datalake.'+"${params.AWS_ENV}"+"${params.DOMAIN}"+'\')] | [0].DistributionID" | tr -d \'"\' | tr -d \'\\n\'', returnStdout: true)
            }
            if(distributionID!=null){
               withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${params.AWS_ENV}", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                echo distributionID
                try{
                  step([$class: 'LambdaInvokeBuildStep', lambdaInvokeBuildStepVariables: [awsAccessKeyId: AWS_ACCESS_KEY_ID, awsRegion: "${params.AWS_REGION}", awsSecretKey: AWS_SECRET_ACCESS_KEY, functionName: 'SYS_CLOUDFRONT_CREATE_INVALIDATION', payload: '{"distributionId":"'+distributionID+'"}', synchronous: true]])
                }
                catch(e)
                {
                  echo "Cloudfront invalidateion invoke exception:" + e
                  echo 'or SYS_CLOUDFRONT_CREATE_INVALIDATION does not exist'
                }
              }
            }
            else {
              echo 'Distribution Id is null'
            }
          }
          catch(err){

          }
        }
      }
    }
//     stage('cleanup'){
//       steps{
//                sh "rm -rf node_modules"
//        }
//     }
  }
}
