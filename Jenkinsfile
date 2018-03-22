#!groovy

@NonCPS
def bcModels(){
    return {
        return openshift.process("-f", "openshift.bc.json",
         "-p", "APP_NAME=${metadata.appName}",
         "-p", "ENV_NAME=${metadata.buildEnvName}",
         "-p", "NAME_PREFIX=${metadata.buildNamePrefix}",
         "-p", "NAME_SUFFIX=${metadata.buildNameSuffix}",
         "-p", "GIT_REPO_URL=${metadata.gitRepoUrl}")
    }
}

@NonCPS
def dcModels(){
    return {
        return openshift.process(
                'openshift//mysql-ephemeral',
                "-p", "DATABASE_SERVICE_NAME=${dcPrefix}-db${dcSuffix}",
                '-p', "MYSQL_DATABASE=petclinic"
        ) + openshift.process("-f", "openshift.dc.json",
                "-p", "APP_NAME=${metadata.appName}",
                "-p", "ENV_NAME=${envName}",
                "-p", "NAME_PREFIX=${dcPrefix}",
                "-p", "NAME_SUFFIX=${dcSuffix}",
                "-p", "BC_PROJECT=${openshift.project()}",
                "-p", "DC_PROJECT=${openshift.project()}"
        )
    }
}

standardDeliveryPipeline {
    name = 'spring-petclicnic'
    bcModels = bcModels()
    dcModels = dcModels()
}
