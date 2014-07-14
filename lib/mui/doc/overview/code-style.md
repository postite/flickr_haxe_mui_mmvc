---
title: Coding Conventions
path: overview/code-style
---

# Introduction

> Code is read much more often than it is written.
>
> *- Guido van Rossum, creator of Python*

The goal of this style guide is improve the consistency, legibility and maintainability of all 
front end code written at Massive. The term "code" is used loosely here, as the guide extends to 
the organization of projects, libraries, repositories, and frameworks.

There are many violations of this guide in the existing Massive code base. These should be fixed 
where doing so does not break public API, or documented for fixing in a future major release if 
that is not possible.

Inconsistency introduces a cognitive overhead to everyone, and so it is every developers 
responsibility to follow the guide, and improve things where inconsistencies exist.

This guide is a living document. If you disagree with it or find it does not cover a particular 
situation, branch it, fix it and open a pull request for discussion with the team.


# Ignoring the Guide

There are situations in which this style guide does not apply. When in doubt, always use your best 
judgment or come to a consensus on the right approach with the team.

Some good reasons for ignoring the guide:

- Where doing so would make code less readable.
- To be consistent with surrounding code style (unless you have the time to update the surrounding 
  code to adhere to the guide of course)
- The code belongs to a third party.


# Code Layout


## Indentation

Use tabs for indentation in all source files. Make sure your editor is configured as such (IntelliJ, 
for example, defaults to spaces).


## Maximum Line Length

Limit all lines to a maximum of 99 characters (100 character margin). This restriction allows 
editing of multiple files next to each other and facilitates comparison of code in side-by-side 
code review tools.

Wrapping lines:

```haxe
class MyClass
{
	/**
		Wrapping long method definitions.
	**/
	public function myLongMethodName(myArgumentName1:MyArgumentType1, 
		myArgumentName2:MyArgumentType2, myArgumentName3:MyArgumentType3, 
		myArgumentName4:MyArgumentType3):Void
	{
		// wrapping long method calls
		anotherLongMethodName(myArgumentName1, myArgumentName2, 
			myArgumentName3, myArgumentName4);

		// wrapping long ternary expression
		var longOptionValue = longFlagName == true
			? longOptionValue1 + somethingElse
			: longOptionValue2 + anotherThing;
	}
}
```


## Blank Lines

Type fields (properties, methods, enum values, typedef fields) and multiple types in a module are 
separated by a single blank line.

Use blank lines in functions, sparingly, to indicate logical sections.

Blank lines should contain no whitespace (such as local indentation) as this 
interferes with code comparison tools.

Source files should end with a single blank line.


## File Encoding and Line Endings

All source code should use UTF-8 encoding.

All source code should use Unix style line endings (`\n` not `\r\n`).

> For more information about line endings and source control see GitHub's article on [dealing with line endings](https://help.github.com/articles/dealing-with-line-endings).


## Packages

Omit the package statement for top level types. Also, avoid top level unless there is an excellent 
reason for them.

The package statement should be the first line of your module.

Packages should:

- use lower camel case names
- user singular names, ie. `view` not `views`
- prefer grouping for modularity rather than for functionality, eg. `home`, `purchase`, `player` 
  not `view`, `model`, `data`
- be used sensibly to *simplify* navigating code

## Imports

Imports should go immediately after the package statement.

Use wildcard should be avoided unless they substantially reduce the number of imports. Explicit 
imports are more readable and work better with code analysis tools.

Imports should be grouped in the following order:

1. Standard library imports
2. External library imports
3. Local application/library imports

## Whitespace in Expressions

Do not use whitespace:

- Immediately inside parentheses, brackets or braces.

```
foo(bar[1], {baz:2}); // yes
foo( bar[ 1 ], { baz:2 } ); // no
```

- Before a comma or semicolon

```
foo({bar:1, baz:2}); // yes
foo({bar:1 , baz:2}) ; // no
```

- Immediately before the open parenthesis of a function call

```
foo(1); // yes
foo (1); // no
```

- Immediately before the open bracket for array access

```
foo[0]; // yes
foo [0]; // no
```

- For any kind of code alignment outside of that required by line wrapping

```
// yes
var x = 0;
var y = 1;
var longVariable = 2;

// no
var x =            0;
var y =            1;
var longVariable = 2;
```

- Around assignment of default argument values

```
function(a:Int=0) {} // yes
function(a:Int = 0) {} // no
```

- Around unary operators

```
i++; // yes
!isFlag; // yes 
i ++; // no
! isFlag; // no
```

Always use whitespace:

- Around binary and unary operators (=, +, -, *, +=, >=, etc.)

```
var a = (b >= c ? b + c * d : d / 2); // yes
var a=(b>=c ? b+c*d : d/2); // no
```

- Around arrows in function types

```
var callback:Void -> Void; // yes
var callback:Void->Void; // no
```

- after block statements (if, else, for, while, try, etc.)

```
if (foo == 1) bar(); // yes
if(foo == 1) bar(); // no
```

## Comments

Comments that contradict the code are worse than no comments. Always make a priority of keeping the 
comments up-to-date when the code changes!

Comments should be complete sentences. If a comment is a phrase or sentence, its first word should 
be capitalized, unless it is an identifier that begins with a lower case letter (never alter the 
case of identifiers!).

If a comment is short, the period at the end can be omitted. Block comments generally consist of 
one or more paragraphs built out of complete sentences, and each sentence should end in a period.

Only use `// TODO(username)` comments if you intend to come back and actually fix it. One of these 
days I'll create a tool that emails you automatically when you don't.


### Block Comments

Block comments generally apply to some (or all) code that follows them, and are indented to the 
same level as that code. Each line of a block comment starts with `//` and a single space (unless 
it is indented text inside the comment).

Example:

```haxe
class MyClass
{
	function myFunction()
	{
		// This following while loop is complicated and requires some 
		// explanation. This block comment uses complete sentences to describe 
		// what the block does.
		//
		// Doing so hopefully simplifies comprehension by other developers.
		while (someCondition())
		{
			// ...
		}
	}
}

```


### Inline Comments

Use inline comments sparingly.

Idiomatic code should need very few inline comments, intention and flow should be easily readable.

An inline comment is a comment on the same line as a statement. Inline comments should be separated 
by one space from the statement. They should start with a `//` and a single space.

Example:

```
x = x + 1; // compensate for border
```

Do not state the obvious:

```
x = x + 1; // increment x
```


## Documentation

Public types, methods and properties in libraries should have documentation.

Use javadoc tags to describe parameters, return values, and exceptions.

Use markdown to format documentation, including markdown backtick blocks to highlight `code` and 
increase legibility of documentation.

The documentation tool will automatically link types and methods found in backtick blocks to the 
references object (use this instead of the javadoc `@see` tag)

Example:

```haxe
/**
	This is some documentation for a method.
	
	Here is some *additional* examplanation of what the method does. 
	We can use any valid [markdown](http://daringfireball.net/projects/markdown/) 
	syntax in here, and `MyObject` will be automatically linked if it exists 
	in the documentation tree.
	
	Usage example:
	
	```haxe
	var type = new MyType();
	type.doStuff(10, "bar");
	```
	
	@param num Controls the amount of stuff to do, multiline param docs 
		should be indented. You can use _markdown_ in here too.
		
		This could even go on to another paragraph.
	@param name A generic programmer style name.
	@returns The stuff that was done.
	@throws `StuffNotDoable` if the stuff can't be done.
**/
```

# Types

## Classes

- the `private` modifier should be omitted; fields are private by default
- the order of modifiers should be: `override`, `public`, `static`, `inline`, `dynamic`, `macro`
- setters should use `value` as the name of their parameter

## TypeDefs

- use class style notation for typedef properties


## Enums

- enum names should be `UpperCamelCase`
- enum value names should be `UpperCamelCase`
- enum value parameters should be `lowerCamelCase`
- enum values should always be fully qualified with their enum
- enum values should be documented like class methods, with `@param` tags for any parameters

Example:

```haxe
/**
	Enumerated values for `Video.aspectRatio`

	Describes how the video should resize the video display.
**/
enum AspectRatio
{
	/**
		The video should be scaled to a `1:1` ratio.
	**/
	Square;

	/**
		The video should be scaled to a `4:3` ratio.
	**/
	FourThree;

	/**
		The video should be scaled to a `16:9` ratio.
	**/
	SixteenNine;
	
	/**
		The video should be scaled to this custom ratio.

		@param aspect the ratio of `width` to `height`. A `4:3` ratio could 
			also be described as `Custom(4/3)`
	**/
	Custom(ratio:Float);
}

class ExampleUsage
{
	/**
		Returns the ratio of height to width of the provided `AspectRatio`
		
		@param ratio the ratio to calculate
		@returns the calculated ratio
	**/
	public static function getRatio(ratio:AspectRatio)
	{
		return switch (size)
		{
			case AspectRatio.Square: 1;
			case AspectRatio.FourThree: 4/3;
			case AspectRatio.SixteenNine: 16/9;
			case AspectRatio.Custom(ratio): ratio;
		}
	}
}
```

# Naming Conventions

- clear, descriptive, concise, contextual
- rename things if they don't make sense, evolve naming scheme as context grows
- use US spelling, eg. color, initialize
- only use abbreviations where it does not impede clarity. Acceptable abbreviations include: `min`, 
  `max`, `auto`, `eval`, `info`, `num`, `nav`, `util`
- accronyms should *not* be all caps (eg. XmlHttpRequest, JsonParser)
- value object names should not be suffixed, the noun is the data (eg. User not UserVO)


## API Names

- type names (classes, interfaces, enums, enum values, abstracts, typedefs) should be `UpperCamelCase`
- type fields (methods, properties) names should be `lowerCamelCase`
- parameters (method and enum value) names should be `lowerCamelCase`
- inline constant property names should be `UPPER_SNAKE_CASE`

## Other Names

- all directories and file names should be `lower-spine-case` except where that is not allowed (eg. 
  package directories, third party conventions)
- directories names should generally be singular (eg. `/doc` not `/docs`, `/test` not `/tests`)
- branches should be grouped using folders (eg. `fix/my-defect-id`, `feature/my-new-feature`
