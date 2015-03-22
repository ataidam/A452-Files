#!/bin/bash
#========================================
#This assumes the input file is a data file of students
#and teachers
#and must be in the following format (and also
#assumes this is the first line of the file):
#Name:Group
#
#=========================================
filein="List_usernames_and_groups.txt"
IFS=$'\n'

if [ ! -f "$filein" ]
then
  echo "Cannot find file $filein"
else

  #create arrays of groups and usernames
  groups=(`cut -d: -f 2 "$filein" | sed 's/ //'`)
  usernames=(`cut -d: -f 1 "$filein"`)


  #checks if the group exists, if not then creates it
  for group in ${groups[*]}
  do
    grep -q "^$group" /etc/group ; let x=$?
    if [ $x -eq 1 ]
    then
      groupadd "$group"
    fi
  done

  #creates the user accounts, adds them to groups
  x=0
  created=0
  for user in ${usernames[*]}
  do
    useradd -n -c ${usernames[$x]} -g "${groups[$x]}" $user 2> /dev/null
    if [ $? -eq 0 ]
    then
      let created=$created+1
    fi
  echo "Usename: ${usernames[$x]}, Group: ${groups[$x]}"

    x=$x+1
    echo -n "..."
    sleep .25
  done
  sleep .25
  echo " " 
  echo "Complete. $created accounts have been created."
fi
