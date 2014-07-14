---
title: Installing the MDK
path: overview/installation
order: 1
---

# Introduction

This guide walks you through installation of the Massivision MDK and a five minute "Hello World" 
application.

Installation of the Massivision MDK is accomplished using [mpm][mpm], the Massive package manager. 
This command line tool is responsible for downloading and managing the individual modules of the 
MDK as well as switching between different MDK and module versions.


# Install Haxe and Neko

The Massivision MDK is built with [Haxe][haxe] and [Neko][neko]. To install both follow the 
instructions on the [official download page][haxe-download].

Verify installation of Haxe and Neko by executing:

	$ haxe
	$ neko

[Setup HaxeLib][haxelib] with a user-writable repository for libraries:
	
	$ sudo mkdir -p /usr/lib/haxe/lib
	$ sudo chown `whoami` /usr/lib/haxe/lib
	$ haxelib setup /usr/lib/haxe/lib

[Associate an editor][file-association] with `.hx` and `.json` files, as the command line tools 
use `open` to launch configuration files in your editor.

Finally, you will need read access to the Massive GitHub repositories. For simpler cross platform 
setup, `mpm` uses `https` authentication rather than `ssh`. If you'd like to avoid re-entering your 
user name and password for each dependency, see the "password caching" section of 
[this GitHub article][github-setup].


# Install the MDK

Install the Massive package manager directly from GitHub:

	$ haxelib git mpm https://github.com/massiveinteractive/mpm.git src

> Note: If running `haxelib run mpm` returns an error like `Library mpm version dev does not have a 
> run script` it means haxelib has not checked out the `src` subdirectly correctly. Try checking 
> out mpm locally and running `haxelib dev mpm {MPM PATH}/src`

Install channels

	$ mpm channel add http://ui.massive.com.au/mpm/channel-ssh.json

Install the MDK

	$ haxelib run mpm install mui 3 -global

Run mtask setup and follow the instructions:

	$ haxelib run mtask setup

> The mtask setup task optionally creates a command line shortcut. To ensure the shortcut is 
> available, restart your command line application after running setup.

Add the `mui` plugin to the global build to enable MDK specific tasks and 
templates:

	$ mtask config plugin.mui 1 -global

# Verify Installation

To verify installation create a "Hello World" application and run it by executing:

	$ mtask create project mui HelloWorld
	$ cd HelloWorld
	$ mtask run web

Your default browser should launch a simple "Hello World" application.

[mpm]: https://github.com/massiveinteractive/mpm/blob/master/README.md
[haxe]: http://haxe.org
[haxe-download]: http://haxe.org/download
[haxelib]: http://haxe.org/com/haxelib/setup
[neko]: http://nekovm.org
[github-setup]: https://help.github.com/articles/set-up-git
[file-association]: http://osxdaily.com/2011/08/15/easily-set-file-association-in-mac-os-x-lion-using-always-open-with-app/
