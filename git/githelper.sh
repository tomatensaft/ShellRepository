#!/bin/sh

#Script for Git Interaction
#Usage githelper [option] [comment]

#Parameter
username="tomatensaft"
email="marco_unterberger@gmx.at"
token="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"
repository="ShellRepository"

#Test
#Pull Option
#git config pull.ff only 
git config pull.rebase true 

#Check Arguments - at least 1 arg
if [ $# -lt 1 ]
  then
    printf "Too less arguments...\n"
    exit 1
fi

#Copy RepoScript for Backup
cp $0 $repository/$0

#Select Command
case "$1" in

    "-pull")
    printf "Pull repo\n"
    cd ${repository}
    #git pull "https://${token}@github.com/${username}/${repository}.git"
    git pull
    ;;

    "-list")
    #Output Global data
    printf "List Global Config Data...\n"
    git config --global --list
    ;;

  "-setglobal")
    #Set Global Data
    printf "Init Git global data...\n"
    git config --global user.name=${username}
    git config --global user.email=${email}
    #git config --global user.password=${token}
    ;;

    "-push")
    #Add Files
    if [ ! -z $repository ]
    then
        printf "Add folder for commit\n"
        cd $repository
        git add -A
    else
        printf "No folder/files to add\n"
        exit 1
    fi

    #Commit
    if [ ! -z "$2" ]
    then
        printf "Commit Repo with Comment - $2\n"
        git commit -m $2
    else
        printf "No Commitstring\n"
        exit 1
    fi

    #Push Repo
    printf "Push Repo\n"
    cd ${repository}
    git push
    #git push "https://${token}@github.com/${username}/${repository}.git"
    ;;  

  "-clone")
    printf "Clone Repo\n"
    git clone "https://${token}@github.com/${username}/${repository}.git"
    ;;
  
  "-delete")
    printf "Delete...\n"
    ;;

  *)
    printf "Wrong Command.\n"
    printf "Usage: githelper [option] [folder] [comment]\n"
    exit 1
    ;;
esac

exit 0