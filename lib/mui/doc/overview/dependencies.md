---
title: Dependency Management
path: overview/dependencies
---

# Introduction

Code reuse, modularity and dependency management are problems that are tightly 
coupled in software development. The SDK is divided into many small, focused 
libraries rather than catch-all utility belts. While this enables the 
libraries to evolve independently and with greater agility, it also requires a 
solid approach to dependency management to ensure projects can depend on 
library stability and satisfy dependencies at any point in the revision history.

MPM (inspired by [npm](http://npmjs.org)) is a simple dependency manager 
written in Haxe. It adheres to the [SemVer standard](http://semver.org) for 
version definition and comparison, and currently avoids the need for a central 
package repository by using git repositories and tags as a source for versions.


# Version Resolution

Define your dependencies in your `project.json` file:

```
{
	"project":
	{
		"dependencies":
		{
			"libkitten":"2.x",
			"libcat":"1.2.x",
			"liblol":"1.1.x"
		}
	}
}
```

When you run `mpm upgrade` mpm will look at your dependencies and checkout a 
git source repository for each into `~/.mpm/source` (if it is not already 
checked out). For each dependency, mpm will get a list of git tags that conform 
to the SemVer spec:

	libkitten: 1.1, 1.2, 1.3, 2.0, 2.1
	libcat:    1.0, 1.1, 1.2.0, 1.2.1, 1.3
	liblol:    1.0, 1.1.1, 1.1.2

Each list of versions is filtered by those that satisfy the project 
dependencies:

	libkitten: 2.0, 2.1
	libcat:    1.2.0, 1.2.1
	liblol:    1.1.1, 1.1.2

Each dependency is checked out at the highest satisfying version:

	libkitten: 2.0, [2.1]
	libcat:    1.2.0, [1.2.1]
	liblol:    1.1.1, [1.1.2]

The `project.json` of each dependency is read, looking for additional 
dependencies. In this case, both libraries depend on `liblol`.

```
libkitten/project.json
{
	"dependencies":
	{
		"liblol":"1.x"
	}
}

libcat/project.json
{
	"dependencies":
	{
		"liblol":"1.1.1"
	}
}

liblol/project.json
{
	"dependencies":{}
}
```

The available versions for each dependency are re-evaluated against the new 
dependencies:

	libkitten: 2.0, [2.1]
	libcat:    1.2.0, [1.2.1]
	liblol:    [1.1.1]

As the highest satisfying version of liblol changed, it is checked out at that 
tag and it's dependencies are re-evaluated. As it has no depenencies, the 
projects dependencies are considered satisfied. If at any stage the list of 
satisfying versions becomes empty, an error is thrown as dependencies cannot be 
satisfied.

The resolved version of each dependency is then copied into the project, under:

	lib/name

And the resolved dependencies are written to `lib.json`. Calling `mpm verify` 
will ensure the dependencies in `lib/` match those defined in `lib.json`.

To upgrade to new dependency versions when they are released:

	mpm fetch libcat
	mpm upgrade

The first command fetches any new tags and commits for the specified library 
(or all available libraries if none is specified) and upgrade performs the 
same dependency resolution process as before.


# Command Line Tool

MPM provides a command line tool for managing project dependencies. The tool 
is based on [mtask](workflow.md) and can be invoked through haxelib:

	haxelib run mpm help

Additional documentation on the available tasks can be accessed from the 
command line:

	haxelib run mpm help verify

