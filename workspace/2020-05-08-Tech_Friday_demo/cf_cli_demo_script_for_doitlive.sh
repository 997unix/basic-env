# Recorded with the doitlive recorder
# cf cli workflow demo
#doitlive shell: /bin/bash
#doitlive prompt: default
#doitlive commentecho: true

# //List the resident buildpacks
cf buildpacks #

# //use a communinity supplied test app https://github.com/cloudfoundry-samples/test-app
cd $HOME/workspace/test-app #

# //Push a test app with buildpack hint - demos real-life workflow
time cf push -b go_buildpack -i 3 tech-friday-go-buildpack #

# //Push the same test app, but as a docker image from https://hub.docker.com/r/cloudfoundry/test-app
time cf push tech-friday-docker-docker-docker -o cloudfoundry/test-app 

# //scale an app
time cf scale -i 2 tech-friday-docker-docker-docker #

# //Show the apps running
cf apps #

# //tech-friday-buildpack - Hit the endpoint and dump some info 
for i in 1 2 3 4 5 ; do lynx -dump http://tech-friday-go-buildpack.cfapps.io/ ; done | paste - - - - - - - #


# //show some logs but limit lines
cf logs --recent tech-friday-go-buildpack | tail -15

# //Stop the apps 
cf stop tech-friday-docker-docker-docker ; cf stop tech-friday-go-buildpack ; sleep 5 #

# //Show the shutdown in the logs
cf logs --recent tech-friday-buildpack | tail -15 #

# //Delete the pushed apps
cf apps| grep tech-friday| pcut -f 1 | xargs -I % cf delete -f % ###

# //Clean up the route (by default, they stay after the app is deleted)
cf routes | grep tech-fri|pcut -f 2 | xargs -I % cf delete-route cfapps.io --hostname % -f #

