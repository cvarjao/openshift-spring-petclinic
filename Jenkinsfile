
import hudson.model.Result
import jenkins.model.CauseOfInterruption.UserInterruption

//@Library('utils') _

def appName='spring-petclinic'
def appId=null;
def doDeploy=false;
def gitCommitId=''
def isPullRequest=false;
def pullRequestNumber=null;
def gitBranchRemoteRef=''
def buildBranchName = null;
def resourceBuildNameSuffix = '-dev';
def buildEnvName = 'dev'

def killOldBuilds() {
  while(currentBuild.rawBuild.getPreviousBuildInProgress() != null) {
    currentBuild.rawBuild.getPreviousBuildInProgress().doKill()
  }
}

pipeline {
    // The options directive is for configuration that applies to the whole job.
    options {
      // Keep 10 builds at a time
      buildDiscarder(logRotator(numToKeepStr:'10'))
      skipDefaultCheckout()
    }
    agent none
    stages {
        stage('Prepare') {
            agent any
            steps {
              script {
                killOldBuilds();
              }
              checkout scm
              //sh "git rev-parse HEAD"
              //sh "git ls-remote"
              sh "git show-ref --head"
              sh "git show-ref --head --dereference"
              //sh "git branch"
              //sh "git branch -a"
              //sh "git status"
              //sh "git status -sb"
              //echo "${env}"
              echo 'Building Branch: ' + env.BRANCH_NAME
              echo 'Build Number: ' + env.BUILD_NUMBER
              echo 'CHANGE_ID: ' + env.CHANGE_ID
              echo "CHANGE_TARGET: ${env.CHANGE_TARGET}"
              echo "JOB_NAME: ${env.JOB_NAME}"
              echo "JOB_BASE_NAME: ${env.JOB_BASE_NAME}"
              //timeout(time: 10, unit: 'MINUTES') {
              //  echo "Checkout ..."
              //  echo "Checkout ... Done!"
              //}
              script {
                gitCommitId = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                isPullRequest=(env.CHANGE_ID != null && env.CHANGE_ID.trim().length()>0)

                echo "gitCommitId:${gitCommitId}"
                echo "isPullRequest:${isPullRequest}"


                def scmUrl = scm.getUserRemoteConfigs()[0].getUrl()
                def envName = null;


                if (isPullRequest){
                  pullRequestNumber=env.CHANGE_ID
                  gitBranchRemoteRef="refs/pull/${pullRequestNumber}/head";
                  buildBranchName = env.BRANCH_NAME;
                  sh "git remote -v"
                  sh "git ls-remote origin refs/pull/${pullRequestNumber}/*"
                }else{
                  buildBranchName = env.BRANCH_NAME;
                  resourceBuildNamePrefix = "-dev";
                }

                echo "scmUrl:${scmUrl}"
                echo "appName:${appName}"
                echo "appId:${appId}"
                echo "buildBranchName:${buildBranchName}"
                echo "scm.getBranches():${scm.getBranches()}"
                echo "scm.getKey():${scm.getKey()}"
              } //end script
            } // end steps
        }
        stage('Build') {
            agent any
            steps {
                script {
                    def bcPrefix=appName;
                    def bcSuffix='-dev';
                    def buildRefBranchName=gitBranchRemoteRef;

                    if (isPullRequest){
                        buildEnvName = "pr-${pullRequestNumber}"
                        bcSuffix="-pr-${pullRequestNumber}";
                    }else{
                        buildEnvName = 'dev'
                    }

                    def bcSelector=['app-name':appName, 'env-name':buildEnvName];

                    openshift.withCluster() {
                        echo "Waiting for all builds to complete/cancel"
                        openshift.selector( 'bc', bcSelector).narrow('bc').cancelBuild()
                        openshift.selector( 'builds', bcSelector).watch {
                          if ( it.count() == 0 ) return true
                          def allDone = true
                          it.withEach {
                              def buildModel = it.object()
                              echo "${it.name()}:status.phase: ${it.object().status.phase}"
                              if ( it.object().status.phase != "Complete" &&  it.object().status.phase != "Failed") {
                                  allDone = false
                              }
                          }
                          return allDone;
                        }
                        //create or patch DCs
                        def models = openshift.process("-f", "openshift.bc.json",  "-p", "APP_NAME=${appName}", "-p", "ENV_NAME=${buildEnvName}", "-p", "NAME_PREFIX=${bcPrefix}", "-p", "NAME_SUFFIX=${bcSuffix}")
                        echo "The template will create/update ${models.size()} objects"
                        for ( o in models ) {
                            o.metadata.labels[ "app" ] = "${appName}-${buildEnvName}"
                            if (openshift.selector("${o.kind}/${o.metadata.name}").count()==0){
                                echo "Creating '${o.kind}/${o.metadata.name}"
                                openshift.create([o]);
                            }else{
                                echo "Patching '${o.kind}/${o.metadata.name}"
                                //TODO: Patching
                            }
                        }

                        echo "The template created : ${created.names()}"

                        echo "Starting Build"
                        def buildSelector = openshift.selector( 'bc', bcSelector).narrow('bc').startBuild("--commit=${buildRefBranchName}")
                        echo "New build started - ${buildSelector.name()}"
                        buildSelector.logs('-f');
                        echo buildSelector.object();

                        //TODO: Re-add build triggers (ImageChange, ConfigurationChange)
                    }

                } //end script
            } //end steps
        } // end stage
        stage('deploy - DEV') {
            agent any
            when {
                expression { doDeploy == true}
            }
            steps {
                echo 'Deploying'
            }
        }
        stage('testing') {
            agent any
            steps {
                echo "Testing ..."
                echo "Testing ... Done!"
            }
        }
        stage('packaging') {
            agent any
            steps {
                echo "Packaging ..."
                echo "Packaging ... Done!"
            }
        }
        stage('publishing') {
            agent any
            steps {
                echo "Publishing ..."
                echo "Publishing ... Done!"
            }
        }
    }
}