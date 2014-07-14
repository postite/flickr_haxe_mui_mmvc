---
title: Unit Testing
path: overview/testing
---

# Introduction

Massive Unit is a metadata driven unit testing framework for cross-platform Haxe development. It 
includes tools for creating, updating, compiling and running unit test cases from the command line.

# Features

## Cross Platform

Massive Unit has been designed for cross platform Haxe development. It currently supports js, 
swf8, swf9, neko and c++, and the tool chain works on PC and OSX.


## Test Metadata

Test cases use Haxe metadata to simplify creating tests (and avoid needing to extend or implement 
framework classes).

```haxe
@Test
public function testExample():Void
{
	Assert.isTrue(true);
}
```

## Asynchronous Tests

Unlike the default haxe unit test classes, Massive Unit supports asynchronous testing

```haxe
@AsyncTest
public function asyncTestExample(factory:AsyncFactory):Void
{
	...
}
```

## Tool Chain

Massive Unit is much more than just a unit test framework. It includes a command line tool for 
working with munit projects to streamline your development workflow.

* Setup stub test projects in seconds
* Auto generate test suites based on test classes in a src directory
* Compile and run multiple targets from an hxml build file
* Launch and run test applications in the browser or command line (neko)
* Save out text and junit style test reports to the file system for reporting and CI
* Auto generate stub test classes (and/or target classes)
* Integrated code coverage compilation with [Massive Cover](https://github.com/massiveinteractive/MassiveCover)
