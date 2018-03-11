# openshift-spring-petclinic
Spring Petclinic


```
oc delete all -l app-name=spring-petclinic
oc get templates/postgresql-ephemeral  -n openshift
oc export templates/postgresql-ephemeral  -n openshift -o json
oc process --parameters -n openshift postgresql-ephemeral

```