#!groovy
standardDeliveryPipeline {
    name = 'spring-petclicnic'
    bcModels = {
        return openshift.process("-f", "openshift.bc.json",
         "-p", "APP_NAME=${metadata.appName}",
         "-p", "ENV_NAME=${metadata.buildEnvName}",
         "-p", "NAME_PREFIX=${metadata.buildNamePrefix}",
         "-p", "NAME_SUFFIX=${metadata.buildNameSuffix}",
         "-p", "GIT_REPO_URL=${metadata.gitRepoUrl}")
    }
}
