#!/bin/bash

##################################################
# Author : pilbbq
# Last Edit : 2019-10-01
# Purpose : Ensuring that all the route-maps applied to NX-OS neighbors have prefix-lists that actually exists.
# Packages required : bash,sed,ssh,grep
# Other requirement : ssh-agent or an unencrypted private key
##################################################

# VARIABLES #
spines=('spine1.example.com' 'spine2.example.com')
user='localuser'

# BEGIN #
echo 'Each dot is a "proper" route-map/prefix-list association'
echo 'If you only have dots, you are fine'
for i in "${spines[@]}"
do
  echo -e "\n########## WORKING ON : $i ##########"
  # Only keep the neighbors that have an Established state.
  spineneighborsstring=`ssh $user@$i -oStrictHostKeyChecking=no -oBatchMode=yes -q "show ip bgp summary | exclude \"Active\" | exclude \"Idle\"" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])'`
  spineneighborsarray=($spineneighborsstring)
  for f in "${spineneighborsarray[@]}"
  do
    # get route-map for each neighbor
    routemap=`ssh $user@$i -oStrictHostKeyChecking=no -oBatchMode=yes -q "show ip bgp neighbors $f | include \"Inbound route-map\"" | sed 's/\(Inbound route-map configured is\|,\|handle obtained\|<END>\)//g' | sed 's/ //g'`
    if [ ! -z "${routemap// }" ]
    then
      # get prefix-list for each route-map
      prefixlist=`ssh $user@$i -oStrictHostKeyChecking=no -oBatchMode=yes -q "show route-map $routemap | include \"prefix-list\"" | sed 's/\(ip address prefix-lists: \|<END>\)//g' | sed 's/ //g'`
      # check prefix-list existence
      prefixlistdetail=`ssh $user@$i -oStrictHostKeyChecking=no -oBatchMode=yes -q "show ip prefix-list $prefixlist | in \"entries\""`
      if [ ! -z "${prefixlistdetail// }" ]
      then
        echo -n "."
      else
        echo -e "\nOn $i, for the $f neighbor, the route-map is $routemap and the associated prefix-list ($prefixlist) IS EMPTY/UNSET, meaning that the route-map is basically an ALLOW ANY"
      fi
    fi
  done
done
echo 'Script complete'
# END #
