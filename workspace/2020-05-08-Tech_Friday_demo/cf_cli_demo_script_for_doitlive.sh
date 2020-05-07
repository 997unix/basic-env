# Recorded with the doitlive recorder
# cf cli workflow demo
#doitlive shell: /bin/bash
#doitlive prompt: default
#doitlive commentecho: true

# //List the resident buildpacks
cf buildpacks

# //reserve a couple of routes
#
#cf create-route development cfapps.io --hostname tech-friday-buildpack
#cf create-route development cfapps.io --hostname tech-friday-docker-docker-docker

cd $HOME/workspace/test-app
# //Push a test app with no hint to see the baseline workflow
cf push tech-friday-buildpack --route-path tech-friday-buildpack | tee ~/tmp/tech-friday-buildpack

# //Push the same test app, but as a docker image from https://hub.docker.com/r/cloudfoundry/test-app
cf push tech-friday-docker-docker-docker -o cloudfoundry/test-app --route-path tech-friday-docker-docker-docker | tee ~/tmp/tech-friday-docker

# //scale an app
cf scale -i 5 tech-friday-buildpack

# //Hit the endpoint and dump some info 
for i in 1 2 3 4 5 ; do lynx -dump http://$(egrep "^routes:" ~/tmp/tech-friday-buildpack | pcut)/ ; done

# //show some logs but limit lines
cf logs --recent tech-friday-buildpack | tail -15

# //Stop the app 
cf stop tech-friday-buildpack ; sleep 5

cf logs --recent tech-friday-buildpack | tail -15

cf delete tech-friday-buildpack 


