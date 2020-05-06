# Recorded with the doitlive recorder
#doitlive shell: /bin/bash
#doitlive prompt: default

# show the CF we're interacting with
cf target

# show our apps, running or not
cf apps

# show bound and unbound routes
cf routes

# show bound and unbound services
cf services

cd /Users/thansmann/workspace/test-app
cf push tech-friday-demo

curl http://tech-friday-demo.cfapps.io/
curl http://tech-friday-demo.cfapps.io/env

# dockerfile version
cf push tech-friday-docker-docker-docker -o cloudfoundry/test-app
curl http://tech-friday-docker-docker-docker.cfapps.io/
curl http://tech-friday-docker-docker-docker.cfapps.io/env

# show some logs
cf logs tech-friday-docker-docker-docker
