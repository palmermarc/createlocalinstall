# createlocalinstall
Create a local website installation, and make the install a WordPress installation using WP-CLI if requested

This is a simple bash script written to speed up creating local websites. This is tailored specifically to our needs, but can always be adapted for other use. This has built-in WP-CLI support for creating a new local WordPress installation, or it can just create your local folders, virtual host file, and update your hosts.

There are quite a few things in this file that are simply assumed - For example, the hosts file location, apache path, etc.. Please pay attention to your local file system to make sure the paths are correct.

##First Steps

The first ~20 lines are all variables that are required for different parts of the script. A description of each variable can be found below:

**INSTALLPATH** - Where are we saving the files?
**USER** - Your local user. WP CLI doesn't like to be ran under SUDO, so we need to define the current user. (There's probably a better way to do this. Feel free to let me know the best way!)
**DBHOST** - Where is your database located?
**DBUSER** - Database Username
**DBPASS** - Database Password for the above user
**WPPASS** - WP-CLI specific. What do you want your local admin password to be?
**WPUSER** - WP-CLI specific. What do you want your local admin username to be?
**WPTITLE** - WP-CLI specific. Basically worthless, because you can change it later. However, it's recommended you put something.

##How to run
1. Copy the create_install.sh file onto your local system.
2. Open up a terminal, and cd into the folder the file was saved in
3. sudo ./create_install.sh
4. Enter your SUDO password
5. Follow the prompts
