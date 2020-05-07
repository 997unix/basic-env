# Recorded with the doitlive recorder
# cf cli workflow demo
#doitlive shell: /bin/bash
#doitlive prompt: default
#doitlive commentecho: true

# //List the resident buildpacks
cf buildpacks #

# //use a communinity supplied test app https://github.com/cloudfoundry-samples/test-app
cd $HOME/workspace/test-app #

# //Push a test app with no buildpack hint - demos baseline workflow
time cf push -i 5 tech-friday-buildpack | tee ~/tmp/tech-friday-buildpack #
export ROUTE_buildpack=$(egrep "^routes:" ~/tmp/tech-friday-buildpack | pcut) #
echo $ROUTE_buildpack #


# //Push the same test app, but as a docker image from https://hub.docker.com/r/cloudfoundry/test-app
time cf push tech-friday-docker-docker-docker -o cloudfoundry/test-app | tee ~/tmp/tech-friday-docker #
export ROUTE_docker=$(egrep "^routes:" ~/tmp/tech-friday-buildpack | pcut) #
echo $ROUTE_docker #

# //scale an app
cf scale -i 5 tech-friday-docker-docker-docker #

# //Show the apps running
cf apps #

# //Hit the endpoint and dump some info 
for i in 1 2 3 4 5 ; do lynx -dump http://${ROUTE_buildpack}/ ; done #
for i in 1 2 3 4 5 ; do lynx -dump http://${ROUTE_docker}/ ; done #

# //show some logs but limit lines
cf logs --recent tech-friday-buildpack | tail -15

# //Stop the app 
cf stop tech-friday-tech-friday-docker-docker-docker #
cf stop tech-friday-buildpack ; sleep 5 #

cf logs --recent tech-friday-buildpack | tail -15 #

cf delete tech-friday-buildpack ###
cf delete tech-friday-docker-docker-docker ###


