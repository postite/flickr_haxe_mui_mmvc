---
title: Tasks
path: workflow/tasks
---

# Introduction

A task is a unit of work in Massive Task. Tasks are defined by adding `@task` metadata to any a 
module method. Simple string parameters are automatically parsed from the arguments passed to the 
build.

To execute a task from the command line, simply execute:

```shell
$ mtask [task] [?arguments]
```

All core functionality in mtask is implemented as tasks:

```shell
	$ mtask create source class HelloWorld
	        [task] [      arguments      ]
```

You can print all available tasks, along with short descriptiong for each by
executing:

```shell
$ mtask help
```

You can print documentation for a task by executing:

```shell
$ mtask help [task]
```

# Creating Tasks

In a module, add a task using the `@task` metadata:

```haxe
@task function sleep()
{
	trace("Sleeping...");
}
```

By default, the name of the task is the method name. You can change this 
default by passing a custom name to `@task`

```haxe
@task("sleep") function commenceSleeping()
{
	trace("Sleeping...");
}
```

You can use javadoc style comments to add documentation to your task:

```haxe
/**
	Sends build system to sleep.

	When the build system is tired and cranky sometimes what it needs is a 
	good long nap.
**/
@task function sleep()
{
	trace("Hello from foo!");
}
```

The first line of the docs will appear when `help` is run:

```shell
$ mtask help
  [...]
  sleep  Sends build system to sleep.
```

Additional docs are avaiable using `help task`:

```shell
$ mtask help sleep
Sends build system to sleep.

When the build system is tired and cranky sometimes what it needs is a 
good long nap.
```

# Options

To allow users to pass additional configuration to your task, you can specify 
String arguments for the task method:

```haxe
@task function sleep(hours:String)
{
	trace("Sleeping for " + hours + " hours.");
}
```

Optional arguments allow users to optionally specify a value:

```haxe
@task function sleep(?hours:String)
{
	if (hours == null) trace("Sleeping for 8 hours.");
	else trace("Sleeping for " + hours + " hours.");
}
```

# Dependencies

To execute one task from another, call invoke:

```haxe
invoke("sleep 8");
```
