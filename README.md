# Product Review Platform

<a href="https://teamcity.gahmen.tech/viewType.html?buildTypeId=ProductReviewPlatform_UnitTest&guest=1"> 
<img src="https://teamcity.gahmen.tech/app/rest/builds/buildType(id:ProductReviewPlatform_UnitTest)/statusIcon"/>
</a>

<img src="public/favicon.png" width="96" />

**This project has been ported over to another repository for maintenance. As a result, this repo will be archived and made read-only.**

# GRP-RoR

Welcome! This document details the setting up of a development environment. The project uses the following frameworks:

* [Getting started with Rails](http://guides.rubyonrails.org/getting_started.html)
* [RSpec](http://rspec.info/)

# Setup
1. Install a package manager (OS X)

	[Homebrew](http://brew.sh/)

		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew update
		
    #### Troubleshooting Brew when installing or updating
    
    With mac no longer support running brew as root. You may find errors or warnings that you can't do X because of
     permissions of folders not being writable. To solve this type:
     
        brew doctor      
    
    It should shoot out warnings and things to fix - the stuff you want to focus on is the Warning:
        
        Warning: The following directories are not writable:
        /usr/local/{some directory}
        
        Warning: You have unlinked kegs in your Cellar
        ...
        {some lib}
        etc.

    You'll probably need to run for all of the directories:
    
        sudo chown -R $(whoami) /usr/local/{some directory}
    
    and missing links:
    
        brew link {some lib}


1. Install rbenv and ruby-build

	> rvm is incompatiable with rbenv. Keep using rvm if it works for you.

		brew install rbenv
		brew install ruby-build
		rbenv init
		rbenv install -l
		rbenv install 2.3.7

	if rbenv fails you may need to run the following command first before rbenv install: 
		xcode-select --install # possibly need xcode first as well

	[OS X](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x)  
	[Linux](https://github.com/rbenv/rbenv#installation)

1. Install ImageMagick
	
	For Mac: Run the brew command:
	
	    brew install imagemagick --build-from-source
	    
1. Install Postgres

        brew install postgresql	

1. Clone the project

	cd into the location you would like to clone the project to

	run this command on terminal: 

		git clone https://github.com/GovTechSG/product-review-platform

	ask any existing project team members for 'application.yml' and put it in the config folder

1. Configure the project

	cd into the root directory of the project
	
	ENSURE YOU HAVE THE APPLICATION YML FILE IN THE CONFIG

	run these command on terminal: 

        gem install bundler
		bundle install
		rails db:drop
		rails db:create
		rails db:schema:load
		rails db:seed

1. Test run

	In the project root directory..

	Test if the project is setup properly:
		
		rails s

    open http://localhost:3000/ on your browser. you should see a landing page.

	Test if project is working:

		rspec
		rubocop

    these should not give any errors (warnings are fine).
# Stack
	Ruby: 2.3.7
	Rails: 5.2.0
	Database: Postgresql 10
