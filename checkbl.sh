#!/usr/bin/env bash


# this is a simplified version of https://github.com/adionditsak/blacklist-check-unix-linux-utility.git

#### main ####
main() {

  [ $# -ne 1 ] && error "Please specify an IP as a parameter."
  
  loopthroughblacklists $1
  
#### reverseit ####
reverseit() {

  reverse=$(echo $1 |
  sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")

  if [ "x${reverse}" = "x" ] ; then

    error $2 
    exit 1
  fi
}


#### loopthroughblacklists ####
loopthroughblacklists() {

  reverse_dns=$(dig +short -x $1)
  
  for bl in ${blacklists} ; do

      listed="$(dig +short -t a ${reverse}.${bl}.)"

      if [[ $listed ]]; then

        if [[ $listed == *"timed out"* ]]; then
           continue
        else
        exit 2
        fi
      fi
  done
}

#### blacklists - grabbed from https://hetrixtools.com/blacklist-check ####
blacklists="
b.barracudacentral.org
bb.barracudacentral.org
bl.score.senderscore.com
bl.spamcop.net
cbl.abuseat.org
zen.spamhaus.org
sip.invalument.com
#rbl.megarbl.net
"
#rbl.megarbl.net - this one always lists any Ip, either by error or intention is a good way to test a listing


### initiate script ###
main $1
