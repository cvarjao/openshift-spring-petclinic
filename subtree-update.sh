#!/usr/bin/env bash
if [ ! -d "spring-petclinic" ]; then
  git subtree add --prefix spring-petclinic https://github.com/spring-projects/spring-petclinic.git master --squash
else
  git subtree pull --prefix spring-petclinic https://github.com/spring-projects/spring-petclinic.git master --squash
fi
