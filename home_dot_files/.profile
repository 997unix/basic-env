#. /usr/local/share/chruby/chruby.sh


#  setup python env for the trading robot class
# 2022-02-12 04:07:12 PM MST
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

for i in "$GOPATH/bin" "$HOME/basic_env/bin" ; do
  [[ -d $i ]] && PATH+=":$i"
done  

(git config -l|grep -q alias.lol) || git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
(git config -l|grep -q alias.co) || git config --global --add alias.co "checkout"
(git config -l|grep -q alias.st) || git config --global --add alias.st "status"
(git config -l|grep -q alias.ci) || git config --global --add alias.ci "duet-commit"
git config --global user.email "$LOGNAME@pivotal.io"
[[ $LOGNAME =~ 'thansmann' ]] && git config --global user.name "Tony Hansmann"

# set the git credential cache to avoid typing id/pass a bunch of times
git config --global credential.helper 'cache --timeout 1200'

complete -C /usr/local/bin/aws_completer aws
export EDITOR=vi
echo 'bind status C !git ci' >> ~/.tigrc

# kubeclt setup
[[ -f /usr/local/etc/bash_completion.d/kubectl ]] && . /usr/local/etc/bash_completion.d/kubectl

#chruby ruby-1.9.3-p448
[ -x /usr/libexec/java_home ] && export JAVA_HOME=`/usr/libexec/java_home -v 1.6`
export maj=cetas-dev-majestic
export w="$HOME/workspace"
export wda="$HOME/workspace/deployments-aws"
export wd="$HOME/workspace/dea_ng"
export wcc="$HOME/workspace/cloud_controller_ng"
export wcf="$HOME/workspace/cf-release"
export wb="$HOME/workspace/bosh"
export wp="$HOME/workspace/prod-aws"
export wt="$HOME/workspace/tools"
export ssl="/Volumes/Untitled/workspace/ssl_certs"

for path_element in $dht/bin /usr/local/go/bin $HOME/go/bin $EC2_HOME/bin $HOME/bin /usr/local/bin ; do
    [[ -d $path_element ]] && PATH+=":${path_element}"
done

export jb=jb.run.pivotal.io
export staging=jb.staging.cf-app.com

alias k='kubectl'
alias kp='kubectl get pods'
alias att='cd ~/workspace/BDPaaS'
alias gti='git'
alias ll='ls -alrt'
alias w="cd $HOME/workspace"
alias wda="cd $HOME/workspace/deployments-aws"
alias wd="cd $HOME/workspace/dea_ng"
alias wcc="cd $HOME/workspace/cloud_controller_ng"
alias wcf="cd $HOME/workspace/cf-release"
alias wb="cd $HOME/workspace/bosh"
alias wt="cd $HOME/workspace/tools"
alias wp="cd $HOME/workspace/prod-aws"
alias wy="cd $HOME/workspace/vcap-yeti"
alias x='echo '
alias sg='git status'
alias e='egrep'
alias ll='ls -lart'
alias l.='ldot'
alias dir='ls -lart|grep ^d'
alias pa='. $te/aliases'
alias c='tput clear'
alias n='nslookup'
alias t='cd ~/tmp/; pwd'
alias ec='emacsclient'
alias r=$(type -p ruby)
alias rd=$(type -p rdebug)
alias XX='set -x'
alias xx='set +x'
alias rrh='echo rbenv rehash; rbenv rehash'
alias bed='bosh edit deployment'
alias bv='bosh vms'
alias btl='bosh task last'
alias btld='bosh task last --debug'
alias btr='bosh tasks recent 50'
alias btrn='bosh tasks recent 50 --no-filter'
alias gpp='git pull --rebase && git push'
alias gppom='git pull --rebase && git push origin master'
alias gst='git status'
alias pdd='pushd'
alias pd='popd'


function sp(){
    if [ -f $dht/.profile ] ; then
        source $dht/.profile
    else
        source ~/.profile
    fi

}


function vp(){
    if [ -f $dht/.profile ] ; then
        vi $dht/.profile
    else
        vi ~/.profile
    fi

}



function be() {
  if [ "$1" = "green" ]; then
    shift
    bundle exec rspec $*
  else
    bundle exec $*
  fi
}

[[ -d ~/workspace/tools ]] && . ~/workspace/tools/bosh_ssh
[[ -d ~/workspace/cf-tools ]] && . ~/workspace/cf-tools/bosh_ssh

function known_hosts_kill (){
    o
    cp -a $HOME/.ssh/known_hosts $o
    > $HOME/.ssh/known_hosts
    }

# save me from mistying less
function le () {
less $*
}

function les () {
less $*
}


biguns () { gfind $1 -mount -size +${2:-2000} -exec ls -ld {} \; ; }
Fsort () { sort -rn +4 -5 - ; }
Fsum () { awk '{ s+=$5 }
        END {print s, "bytes" }' ;}
sbiguns () { biguns $1 $2 | Fsort ; }

function ldot {
    ls -al $1|perl -n -e 'if ( /^-/ ) {split;if (@_[-1] =~ /^\..*$/) {print "@_[-1] \n";}}'
}

function tssh () {
  ssh -F ${th_ssh_config} $*
}

function tscp () {
  scp -F ${th_ssh_config} $*
}

function vsc () {
  vim ${th_ssh_config}
}

function diary (){
  vim $dht/diary
}

function bosh_all () {
  parallel -j5 --keep "bosh -n --color {}" ::: status deployments stemcells releases
}

function bt () {
  bosh target $*
}

function btl () {
  bosh task last $*
}

function btr () {
  bosh tasks recent 15
}

function bdm () {
  bosh download manifest $*
}

function seed_etc_profile (){
  sudo ' echo "function sp () { source $dht/.profile ; }" >> /etc/profile'
}
alias tkey='th_ssh_key'

function gh () {
  echo git clone ssh://git@github.com/cloudfoundry/cf-release.git
}

function tabasco () {
  bosh_me bosh.tabasco.cf-app.com $*
  NATS_USER_PASS=$(ruby -ryaml -e 'y = YAML.load_file("#{ENV["HOME"]}/workspace/deployments-aws/tabasco/cf-aws-stub.yml"); puts "#{y["properties"]["nats"]["user"]}:#{y["properties"]["nats"]["password"]}"')
}

function a1 () {
  ssh -A thansmann@jb.a1.cf-app.com $*
  #bosh_me bosh.a1.cf-app.com
  #NATS_USER_PASS=$( ruby -ryaml -e 'y = YAML.load_file("#{ENV["HOME"]}/workspace/deployments-aws/a1/cf-shared-secrets.yml"); puts "#{y["properties"]["nats"]["user"]}:#{y["properties"]["nats"]["password"]}"' )
}

function nats-ads () {
  ( cd $HOME/workspace/tools/nats-inspect
    go get
    go install
    bosh_tunnel nats/0 &
    echo sleep a 12 sec to let the tunnel come up
    sleep 12
    ./nats-inspect -u="nat://${NATS_USER_PASS}@localhost:4222" dea-ads
  )
}

function prod () {
  if [[ ! -z "$PIVOTAL_USER" ]] ; then
    prod_key $PIVOTAL_USER
  else
    if [[ ! -z "$1" ]] ; then
      PIVOTAL_USER=$1
      shift
    else
      PIVOTAL_USER=thansmann
    fi
  fi
  ssh -A $PIVOTAL_USER@jb.run.pivotal.io $*
}

function bird () {
  if [[ ! -z "$PIVOTAL_USER" ]] ; then
    prod_key $PIVOTAL_USER
  else
    if [[ ! -z "$1" ]] ; then
      PIVOTAL_USER=$1
      shift
    else
      PIVOTAL_USER=thansmann
    fi
  fi
  ssh -A $PIVOTAL_USER@jb.birdnest.cf-app.com $*
}
function jb_root_staging () {
  ssh-add -D
  chmod 400 $HOME/workspace/staging-aws/config/id_rsa_jb
  ssh-add -t 4900 $HOME/workspace/prod-aws/config/id_rsa_jb
  ssh -A ubuntu@jb.run.pivotal.io $*
}

function jb_root_prod () {
  ssh-add -D
  chmod 400 $HOME/workspace/prod-aws/config/id_rsa_jb
  ssh-add -t 4900 $HOME/workspace/prod-aws/config/id_rsa_jb
  ssh -A ubuntu@jb-z2.run.pivotal.io $*
}


function D () {
    date +%F
}

function space2slash_s_+() {
 perl -pe 's{\s+}{\\s+}g; print "\n"'
}

bbb(){
  set -x
  cat $HOME/basic_env/home_dot_files/bosh_job_paste | pbcopy
  set +x
}


function bosh_diff_loop(){
  this_deploy=$(bosh -n deployment)
  deployment_name=$(basename $this_deploy)
  local tmp_file=~/tmp/${deployment_name}_$(date +%F)
  mkdir -p ~/tmp
  cp -v $this_deploy $tmp_file
  while :
    do
      bosh -n diff $1
      vi  $this_deploy
      cp $tmp_file $this_deploy
      read -p "Again (ctrl-c otherwise): " noskdie_ignore
    done
}

function dang() {
  bosh -n deploy
}

function goshdarnit() {
  bosh -n upload release && dang
}

function goddammit() {
  bosh -n create release --force && goshdarnit
}

function gfd () {
 cd ~/workspace/cf-release
 bosh target
 bosh deployment
 read -p "Press any key to continue: " arlksxi_ignore
 goddammit
}

function gonarc() {
  cd ~/workspace/narc
  export GOPATH=$PWD
  cd src/github.com/vito/narc
}

function goto {
  cd ~/workspace/*$1* && \
    export GOPATH=$PWD && \
    export PATH=$GOPATH/bin:$PATH && \
    cd src/*/*/*${2:-$1}*
}

function virtualbox_start_my_stemcell (){
   epoch=$(date +%s)
   local stemcell_tgz=$1
   local stemcell_name=$(basename $stemcell_tgz | perl -pe 's/bosh-stemcell-// ;s/\.tgz//xmsi')
   local vm_name="${epoch}_${stemcell_name}"
   local tmp_dir=/tmp/${vm_name}
   mkdir ${tmp_dir} && cd ${tmp_dir} ;  tar xvf ${stemcell_tgz} image  ; tar xvf image
   VBoxManage import ${tmp_dir}/image.ovf  --vsys 0 --vmname ${vm_name}
   VBoxManage startvm ${vm_name}
}


function checkman {
  \curl https://raw.github.com/cppforlife/checkman/master/bin/install | bash -s
}

function bo {
  BUNDLE_GEMFILE=~/workspace/bosh/Gemfile bundle exec bosh $*
}

function fcd {
  cd $(dirname $1)
}

function jb() {
  ssh -A thansmann@jb.run.pivotal.io
}

function staging() {
  prod_key
  if [[ -z $1 ]] ; then
    ID=thansmann
  else
    ID=$1
  fi
  ssh -L 25555:bosh.staging.cf-app.com:25555 -A $ID@jb.staging.cf-app.com
}

function staging2() {
  prod_key
  if [[ -z $1 ]] ; then
    ID=thansmann
  else
    ID=$1
  fi
  ssh -L 25555:bosh.staging.cf-app.com:25555 -A $ID@jb-z2.staging.cf-app.com
}

function checklist_reset() {
  perl  -pe 's{\[x\]}{[ ]}g' $1
}

function prod_keys() {
  kc
  if [[ ! $(ssh-add -l | grep -q prod-keys) ]] ; then
    [[ -d ~/workspace/prod-keys ]] || git clone git@github.com:cloudfoundry/prod-keys.git  ~/workspace/prod-keys
    kc
  fi
}


function whats_in_the_deploy() {
  kc
  cd ~/workspace/cf-release
  git fetch
  git checkout release-candidate
  ./update
  bundle install
  bundle exec git_release_notes html \
       -f origin/deployed-to-prod \
       -t origin/release-candidate \
       -u https://github.com/cloudfoundry/cf-release > ~/Desktop/whats-in-the-deploy.html
}

function ttmux() {
  tmux -f $dht/.tmux.conf
}

function myip() {
  wget -qO- http://ipecho.net/plain ; echo
}

function grep_ip(){
grep -E "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $*

}

function di() {
  bosh -t bosh.dijon.cf-app.com $*
}

function ta() {
  bosh -t bosh.tabasco.cf-app.com $*
}

function job_order() {
  # greps a bosh manifest for the list of jobs
  egrep '^jobs:|^  (name:)' $*
}

function describe-instances (){
  aws ec2 describe-instances --output text|  tr '	' ' ' | perl -pe 's/(RESERVATION)/\n$1/'
}

function ssl_decode_csr() {
  set -x
  set -f
  openssl req -in $1 -noout -text
  set +f
  set +x

}

pushenv () {
    if [[ -d $dht ]] ; then
      pushd $dht
    else
      pushd ~
    fi
    scp -r .screenrc .profile env bin $1:;
    ssh $1 "chmod 755 .profile; ln -sf .profile .bash_profile";
    popd
}


function att_spiff(){
  bash -x $HOME/workspace/att_spiffable_template/bin/att_spiff
}

function aws_ssh_fingerprint () {
  echo "This needs the private key to generate the digest aws uses"
  openssl rsa -in $1 -pubout -outform DER | openssl md5 -c
}

##############################
##########
# Wed Sep 26 13:47:25 2007
# got tired of making up tmp file names.
# get a tmpfile with your userid in it so there's no collisions
# theres a cleanvt fuction to so you can clear them easily.
# after you run this the '$f' var has the file you just edited for easy
# recall - i wrote for this idiom:
# vi a tmp file, paste some junk, then "grep foo $f"
function vt () {
      eval `next_file_named -f foo`
      vi $f
      echo $f
}

function vts () {
          eval `next_file_named -f foo`
          (echo '#!/bin/bash' ; echo ) >> $f
          chmod 755 $f
          vi + $f
          echo $f
}

function f () {
    eval `next_file_named -f foo`
      touch $f
      echo $f
}

function ef () {
      eval `current_file_named -f foo`
      echo $f
}

function o () {
        eval `next_file_named -f out`
        touch $o
        echo $o
}

function eo () {
      eval `current_file_named -f out`
      vi $o
      echo $o

}

function ej () {
      eval `current_file_named -f jsh`
      echo $j
}

function vj () {
      eval `current_file_named -f jsh`
      vi $j
      echo $j
}

function p () {
        eval `next_file_named -f put`
        touch $p
        echo $p
}

function ep () {
      eval `current_file_named -f put`
      echo $p
}


function q () {
        eval `next_file_named -f qoo`
        touch $q
        echo $q
}

function eq () {
      eval `current_file_named -f qoo`
      echo $q
}



function z () {
        eval `next_file_named -f zoo`
        touch $z
        echo $z
}


function ez () {
      eval `current_file_named -f zoo`
      echo $z
}

# causes a shell issue i can't figure out - commenting out Wed Mar  3 15:22:10 2010
 function all-e () {

  echo '
    f  - make a temp file and put it env var $f
    ej - existing jsh log file - exports j={current jsh file} to the env
    vj - vi existing jsh log file
    jc - get the last 25 jsh commands.
    it - instanciate temp file. use like: it; ifconfig > $f ; vi $f
    et - existing temp file - prints it and exports f={current foo tmp file} to the env
    vt - vi a NEW foo temp file -  exports f={current foo tmp file} to the env
    vts - make a temp file, add shbang line, mark 755, open in vi ready to insert.
    o - make a temp output file
    eo - make a temp output file and edit it.
'
}


function migrate_basic_env() {
  if [[ -d ~/workspace/basic-env ]] ; then
    cd ~/workspace/basic-env && git stash && git pull --rebase && git stash pop
  else
    cd ~/workspace && git clone git@github.com:pivotal-cf-experimental/basic-env.git
  fi

  if [[ -d ~/workspace/basic-env ]] ; then
    cp -a $dht/{.profile,.screenrc,.tmux.conf} $dht/home_dot_files/.gitconfig ~/workspace/basic-env
    mkdir -p ~/workspace/basic-env/bin
    cp -a $dht/bin/{gen_sudo_shell_command.bash,aws_NAT_boxes_for_all_regions.bash,push_env,install_bosh+tools,check_ssh_keys,jsh,summarize_jsh,ll,llp,lll,pcut,++,nl2.pl,print_between,tree_perms.pl,kibme,next_file_named,show_swapping_procs,llll} ~/workspace/basic-env/bin
    git commit -a --cleanup=strip -v
  fi
}

function new_env() {
  echo "do setup for a new env"
  cd ; mkdir ~/bin ; install  ~/basic-env/bin/* ~/bin
  cd ; ln -svf ~/basic-env/home_dot_files/.profile .profile
  cd ; ln -svf ~/basic-env/home_dot_files/.screenrc .screenrc
  cd ; ln -svf ~/basic-env/home_dot_files/.tmux.conf .tmux.conf
  cd ; ln -svf ~/basic-env/home_dot_files/.gitignore_global .gitignore_global
  git config --global core.excludesfile ~/.gitignore_global
  cd bin ; ./nl2.pl --egg| xargs -I {} bash -c '{}'
  cd ; ~/bin/install_bosh+tools
}

function gc() {
  pushd ~/workspace
  local repo=$(echo $1| perl -pe 's/\.git$//')
  git clone git@github.com:${repo}.git
  echo "cd-ing into $repo - do popd to go back to where you started"
  cd $repo
  pwd
}

function tt() {
  f
  $* | tee $f
}

function ssh-keyness() {
  if [[ -f $1  ]] ; then
    local KEY=$1
    chmod 400 $KEY
    local FINGERPRINT=$(ssh-keygen -lf $KEY|awk '{print $2}')
    (ssh-add -l | grep -q $FINGERPRINT ) || ssh-add $KEY
  else
    echo "WARN: could not find key [$1], doing nothing"
  fi
}


function prod_key() {
  ssh-keyness $HOME/workspace/prod-aws/keys/id_rsa_$PIVOTAL_USER
}

function prod_bosh_key() {
  ssh-keyness $HOME/workspace/prod-aws/config/id_rsa_bosh
}

function prod_jb_key() {
  ssh-keyness $HOME/workspace/prod-aws/config/id_rsa_jb
}
function staging_bosh_key() {
  ssh-keyness $HOME/workspace/staging-aws/config/id_rsa_bosh
}
function staging_jb_key() {
  ssh-keyness $HOME/workspace/staging-aws/config/id_rsa_jb
}
function lakitu_jb_key() {
  ssh-keyness $HOME/workspace/cloudop-ci/config/id_rsa_jb
}

function lakitu() {
    lakitu_jb_key
    ssh -A vcap@jb.lakitu.cf-app.com $*
}

function sandbox2() {
    gerrit_key
    ssh -AL 25555:10.107.0.10:25555 root@12.144.186.145 $*
}

function sandbox3() {
    gerrit_key
    ssh root@12.144.186.59 $*
}

function sandbox4() {
    gerrit_key
    ssh root@12.144.186.67 $*
}

function stagex() {
    gerrit_key
    ssh  root@12.144.186.18 $*
}

function devx() {
    gerrit_key
    ssh  root@12.144.186.13 $*
}

function ssl() {
  cd /Volumes/Untitled/workspace/ssl_certs
  pwd
}


abspath() {
    local DIR=$(dirname "$1")
    cd $DIR
    printf "%s/%s\n" "$(pwd)" "$(basename "$1")" | perl -pe 's{/{2,}}{/}g'
    cd "$OLDPWD"
}

abspath_dir() {
  local DIR=$(dirname "$1")
  cd $DIR
  pwd
  cd "$OLDPWD"
}

function bosh_env () {
  THIS_HOST_EXTERNAL_IP=$(curl -s ifconfig.me)
  case $THIS_HOST_EXTERNAL_IP in
  54.85.115.27)
    bosh target micro.run.pivotal.io micro
    bosh target bosh.run.pivotal.io prod
    BOSHES="micro prod"
    ;;
  *)
       echo "ERROR: $(basename $0) does not know external IP [${THIS_HOST_EXTERNAL_IP}]"
    ;;
   esac

  parallel "echo %%%%%%%%%% {} %%%%%%%%%% ; bosh -t {} deployments" ::: $BOSHES

}


function grH () {
  git reset HEAD $*
}

function add_pwd_to_path(){
  echo "Before: $PATH"
  PATH+=":$(pwd)"
  path_clean
  echo "After: $PATH"
}

function path_clean () {
  PATH=$(perl -e 'my %seen; @NEW = grep !$seen{$_}++, (split /:/, $ENV{PATH}); print join(":", @NEW), "\n" ;')
}

function ttt(){
 set -x
 (
  echo "git clone https://github.com/pivotal-cf-experimental/basic-env.git ~/basic-env ; . ~/basic-env/.profile"
  echo new_env
  echo set_prod_bosh_env
  )| pbcopy
 set +x
}

function set_prod_bosh_env(){
  mkdir -p ~/jb_env

  if [[ -s ~/jb_env/our-ip ]] ; then
    OUR_IP=$(cat  ~/jb_env/our-ip)
  else
    OUR_IP=$(curl -s ifconfig.me 2> /dev/null)
    echo $OUR_IP > ~/jb_env/our-ip
  fi

  case $OUR_IP in
    54.210.178.15)
      JB_NAME=jb-z1.staging.cf-app.com
      MAIN_DEPLOY=cf-staging
      BOSH_TARGET=bosh.staging.cf-app.com
      BOSH_TREE=~/workspace/staging-aws
    ;;

    54.210.167.180)
      JB_NAME=jb-z2.staging.cf-app.com
      MAIN_DEPLOY=cf-staging
      BOSH_TARGET=bosh.staging.cf-app.com
      BOSH_TREE=~/workspace/staging-aws
    ;;

    54.85.115.27)
      JB_NAME=jb-z1.run.pivotal.io
      MAIN_DEPLOY=cf-cfapps-io2
      BOSH_TARGET=bosh.run.pivotal.io
      BOSH_TREE=~/workspace/prod-aws
    ;;

    54.84.228.119)
      JB_NAME=jb-z2.run.pivotal.io
      MAIN_DEPLOY=cf-cfapps-io2
      BOSH_TARGET=bosh.run.pivotal.io
      BOSH_TREE=~/workspace/prod-aws
    ;;

    *)
      echo "IP Address [$OUR_IP] is unknown - guessing prod"
      MAIN_DEPLOY=cf-cfapps-io2
      BOSH_TARGET=bosh.run.pivotal.io
      BOSH_TREE=~/workspace/prod-aws
    ;;
  esac

  bosh target $BOSH_TARGET
  main_manifest

  all_bosh_vms
}


function vms_sane(){
      grep_ip | tr -d '|' | pcut -f 1,-1
}

function main_manifest(){
  if (bosh task last > /dev/null) ; then
     bosh -n download manifest $MAIN_DEPLOY ~/tmp/${MAIN_DEPLOY}.yml &
     bosh_all
   else
     echo "ERROR: need to login to $BOSH_TARGET"
   fi
}

function all_bosh_vms() {
  mkdir -p ~/tmp/vms
  bosh deployments | cut -f 2 -d '|'|egrep -v Name| egrep '^ [[:alpha:]]' | tr -d ' ' |
    parallel -j9  -rt 'bosh vms --details {} > ~/tmp/vms/{}.yml'

}

function vms() {
   if [[ ! -z $MAIN_DEPLOY ]]; then
   [[ -d ~/tmp/vms ]] ||  all_bosh_vms
   if [[ ! -z $* ]] ; then
     echo "vms list to cat: "
     select VM_LIST in ~/tmp/vms/*.yml ; do
       cat $VM_LIST
       break
     done
   else
     cat ~/tmp/vms/${MAIN_DEPLOY}.yml
  fi
 else
    set_prod_bosh_env
 fi
}


function pull_basic-env(){
  pushd ~/basic-env
  git pull
  popd
  sp
}

function cf_migrations(){
  cd ~/workspace/cf-release
  if [[ -z "$1" ]] ; then
    LAST_TWO_TAGS=$(git tag |egrep '^v\d+'|tr -d 'v'|sort -n|tail -2| parallel -n2 echo "v{1}..v{2}")
  else
    LAST_TWO_TAGS=$1
  fi
  echo "Checking tags $LAST_TWO_TAGS for db migrations in the cloud_controller_ng"
  CC_COMMITS_FOR_LAST_REQUESTED_TAGS=$(git diff $LAST_TWO_TAGS -- src/cloud_controller_ng | tail -2| pcut | cut -c 1-8 | parallel -n2 echo "{1}..{2}")
  echo "Tags $LAST_TWO_TAGS corrospond to cc commits $CC_COMMITS_FOR_LAST_REQUESTED_TAGS"
  cd src/cloud_controller_ng
  git fc $CC_COMMITS_FOR_LAST_REQUESTED_TAGS -- db/migrations
}

function aws_prod_ro(){
  if [[ -d ~/workspace/prod-aws/config ]] ; then
  local RO_KEYS=$(find ~/workspace/prod-aws -name aws_readonly_keys)
    source $RO_KEYS
    aws $*
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
  else
    cd ~/workspace
    gerrit_key
    git clone git@github.com:pivotal-cf/prod-aws.git
  fi
}

function all_the_repos() {
  gerrit_key
  mkdir -p ~/workspace
  pushd ~/workspace

  for i in bosh cf-release ; do
    [[ -d $i ]] || GET_ME+="$i "
  done
  echo $GET_ME
  [[ ! -z $GET_ME ]] && parallel -j 25 -rt --keep git clone git@github.com:cloudfoundry/{} ::: $GET_ME
  unset GET_ME

  for i in prod-aws deployments-aws bosh-jumpbox cloudops-tools prod-keys staging-aws jumpbox-release ; do
    [[ -d $i ]] || GET_ME+="$i "
  done

  unset GET_ME
  [[ ! -z $GET_ME ]] && parallel -j 25 -rt --keep git clone git@github.com:pivotal-cf/{} ::: $GET_ME
  unset GET_ME
  popd
}


function ssh_config(){
  mkdir -p ~/.ssh
  if (egrep -q 'ignore our cows moos' ~/.ssh/config) ; then
    echo "We ignoring mooing"
  else
    echo '
Host 10.* # ignore our cows moos
  User vcap
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
Host jb*.pivotal.io
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
Host jb*.cf-app.com
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
' >> ~/.ssh/config
fi
}

function tmate_install() {
  staging_jb_key
  for i in 1 2 ; do
  ssh -A ubuntu@jb-z$i.staging.cf-app.com "
    sudo apt-get install -y python-software-properties && \
    sudo add-apt-repository ppa:nviennot/tmate      && \
    sudo apt-get update                             && \
    sudo apt-get install -y tmate
   "
 done

}


function bosh_jobs_list() {
  for i in $* ; do
    echo -e "Jobs for $i\n===================="
    print_between -s '^jobs:' -e '^network' $i --not-last |
    egrep '^name' |
    perl -pe 's/_z\d+//xms' |
    pcut |
    uniq
    echo
  done
}

function vim_config() {
  git clone https://github.com/Casecommons/vim-config.git ~/.vim
  cd ~/.vim
  git submodule update --init --recursive
  ln -s ~/.vim/vimrc ~/.vimrc
  mv init/casebook2.vim after/
  echo '
:set nu
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27' >> ~/.vimrc.local
}

function mac_dns_idiocy () {
  # you know, for when cli resovling just stops working! Mac OS 10.10+
  sudo launchctl kickstart -k system/com.apple.networking.discoveryd
}

function movie-move () {
   ssh ayn id || { echo ssh not working to ayn ; exit ; }
   cd ~/Movies && find . -maxdepth 1 |
      parallel --keep -rt -j 8 \
      rsync --remove-source-files -ahv {} thansmann@ayn:/usr/local/media/Media/Videos
   find . -type d -empty -delete

}


function 90days () {
   for i in $(seq 0 90 ) ; do gdate -d "today + $i days"  +"%A %F" ; done
   unset i
}


function gym () {
   cal -3
   perl -e 'print "\n" . "+" x 77 . "\n"'
   90days |
   perl -ne '/Sat/ and print "10AM PDT ";  /Mon|Wed/ and print  "6PM PDT " ; print "$_"; /Sat/ and print "---\n"'
}

function dattach() {
  docker exec -it $(docker ps | grep -v STATUS | pcut) bash
}

function mycal3() {
   cal -3h -m $(gdate -d "now + 1 month" +%B) 2019
}


# from https://gist.github.com/bitops/188a1809121246101e54
function is_guid() {
egrep -hir -E '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}'
}

function rm_guid_files() {
   ls -1 | is_guid | xargs -I% rm -v %
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thansmann/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/thansmann/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thansmann/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/thansmann/Downloads/google-cloud-sdk/completion.bash.inc'; fi

function daily_draft(){
   for i in $(seq 0 90); do  gdate -d "now + $i days" +"mkdir -pv daily_drafts/%Y/%b/%A/%F; touch daily_drafts/%Y/%b/%A/%F/$(uuidgen)" ;done
}
