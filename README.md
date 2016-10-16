# .BashSetup
This repo contains the .bashrc I use and other CLI subsequent tools I've setup.

## Installation
In order to override the .bashrc and etc, you must install this in the home folder.
```
cd ~
git init .
git remote add -t \* -f origin git@github.com:stefanjcollier/.BashSetup.git
```

This works assuming you have none of the following files in your home (~) folder:
 * .gitignore
 * .README.md
 * .git
 * .bashrc
 * .bash_files/

If you do, delete or rename them. We cannot allow duplicates. 
