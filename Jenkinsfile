#!groovy



def bcModels(){
    def models = []
        models.add(['-f', 'openshift.bc.json',
         '-p', 'APP_NAME=${metadata.appName}',
         '-p', 'ENV_NAME=${metadata.buildEnvName}',
         '-p', 'NAME_PREFIX=${metadata.buildNamePrefix}',
         '-p', 'NAME_SUFFIX=${metadata.buildNameSuffix}',
         '-p', 'GIT_REPO_URL=${metadata.gitRepoUrl}'])
    return models;
}


def dcModels(){
    def models = []

    models.add(['openshift//mysql-ephemeral',
            '-p', 'DATABASE_SERVICE_NAME=${dcPrefix}-db${dcSuffix}',
            '-p', 'MYSQL_DATABASE=petclinic'])

    models.add(['-f', 'openshift.dc.json',
                     '-p', 'APP_NAME=${metadata.appName}',
                     '-p', 'ENV_NAME=${envName}',
                     '-p', 'NAME_PREFIX=${dcPrefix}',
                     '-p', 'NAME_SUFFIX=${dcSuffix}',
                     '-p', 'BC_PROJECT=${buildProject}',
                     '-p', 'DC_PROJECT=${deployProject}'])

    return models;
}

standardDeliveryPipeline {
    name = 'spring-petclicnic'
    bcModels = bcModels()
    dcModels = dcModels()
}
