# Recorded with the doitlive recorder
# cf cli workflow demo
#doitlive shell: /bin/bash
#doitlive prompt: default
#doitlive commentecho: true

###
# run: 
#   o ;  while : ; do cf logs tech-friday-go-buildpack ; sleep 5 ;done | tee $o
# in another pane
###
# ---------------------------------------- 
# //List the resident buildpacks - describe the buildpack model
cf buildpacks #

########################################
# ---------------------------------------- 
# //use a communinity supplied test app https://github.com/cloudfoundry-samples/test-app
cd $HOME/workspace/test-app #
git co 4dfe151

########################################
# ---------------------------------------- 
# //Look at the app manifest for the go_buildpack hint
cat manifest.yml
########################################
# ---------------------------------------- 
# //Going to push two instances of the same app: Buildpack and Docker
# //Push app, run 3 instances, has buildpack hint - real-life workflow
time cf push -i 3 tech-friday-go-buildpack #

########################################
# ---------------------------------------- 
# //Push the same test app, but as a docker image from https://hub.docker.com/r/cloudfoundry/test-app
git co a28c7ac #
time cf push tech-friday-docker-docker-docker -o cloudfoundry/test-app #

########################################
# ---------------------------------------- 
# //scale the docker app
time cf scale -i 2 tech-friday-docker-docker-docker #

########################################
# ---------------------------------------- 
# //Show the apps running
cf apps #

########################################
# ---------------------------------------- 
# //tech-friday-buildpack - Hit the endpoint and dump some info 
for i in 1 2 3 4 5 ; do lynx -dump http://tech-friday-go-buildpack.cfapps.io/ ; done | paste - - - - - - - #

########################################
# ---------------------------------------- 
# //Stop the apps 
cf apps | grep tech-friday| pcut -f 1 | xargs -P 3 -t -I % cf stop % ###

########################################
# ---------------------------------------- 
# //Delete the pushed apps
cf apps| grep tech-friday| pcut -f 1 | xargs -P 3 -t -I % cf delete -f % ###

########################################
# ---------------------------------------- 
# //Clean up the route (by default, they stay after the app is deleted)
cf routes | grep tech-fri|pcut -f 2 | xargs -I % cf delete-route cfapps.io --hostname % -f #


# ---------------------------------------- 
# ---------------------------------------- 
# //What are not covering: Services and Marketplace, Applications Security Groups, Isolations segments, Backup and Recovery, etc
