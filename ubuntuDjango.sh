#!/bin/bash
# With the help of https://www.digitalocean.com/community/tutorials/how-to-serve-django-applications-with-apache-and-mod_wsgi-on-ubuntu-14-04
#############
# VARIABLES #
#############
# A variable representing which version of Python you want to use. Change this to 2 if you want to use python2
PYTHON=3

########
# BODY #
########
#Always update repo pointers first, consider also upgrade and autoremove first.
sudo apt-get update

#Installs using Python3 by default. If user has changed, install other Python
if [ $PYTHON == 3 ] then
	sudo apt-get install python3-pip apache2 libapache2-mod-wsgi-py3
else
	sudo apt-get install python-pip apache2 libapache2-mod-wsgi
fi

#If using Python3, we need to use pip3 for all later commands. Otherwise, use pip
#We need to install virtual environments to isolate our project from our system tools and other Django projects
if [ $PYTHON == 3] then
	sudo pip3 install virtualenv
else
	sudo pip install virtualenv
fi

#This is where the user should make a new project, change into it and initialize it
mkdir ~/myDjangoProject
cd ~/myDjangoProject
virtualenv myDjangoProjectEnvironment
#Then activate the environmentm, you should see your command line change to reflect this
source myDjangoProjectEnvironment/bin/activate

#Install Django in this location
if [ $PYTHON == 3 ]
	pip3 install django
else
	pip install django
fi

#Create the Django project
django-admin.py startproject myDjangoProject .

exit

#USER WILL NEED TO INTERVENE HERE
#Edit the file myDjangoProject/settings.py and add STATIC_ROOT = os.path.join(BASE_DIR, "static/") under STATIC_URL

#The user will have to enter these next few lines manually
#If you are unfamiliar with Django, be prepared to type makemigrations and migrate a lot
cd ~/myDjangoProject
./manage.py makemigrations
./manage.py migrate

#Create an admin account with 
./manage.py createsuperuser

#Collect all static content with
./manage.py collectstatic

#Finally, run the server to test it. You can replace the IP and port with whatever
./manage.py runserver 0.0.0.0:8000

#Access the webserver via another browser, ideally on another machine to assure conenctivity
#TODO Find out how to run on port 80
#TODO fix Disallowed host issue