---
title: Unit Testing with Mocking
path: overview/mocking
---

# Introduction

Mockatoo is a Haxe library for mock creation, verification and stubbing. Mockatoo uses Haxe macros 
to generate mock implementations of classes and interfaces for testing.

# Quick Start

Import and use the 'using' mixin

	import mockatoo.Mockatoo.*;
	using mockatoo.Mockatoo;

Mock any class or interface, including typedef aliases and types with generics (type paramaters)

	var mockedClass = mock(SomeClass);
	var mockedInterface = mock(SomeInterface);
	var mockedClassWithTypeParams = mock(Foo,[Bar]); //e.g. Foo<Bar>

Verify a method has been called with specific paramaters (cleaner syntax since 1.3.0)

	mock.someMethod().verify();
	mock.someMethod("foo", "bar").verify();

Define a stub response when a method is invoked

	mock.foo("bar").returns("hello");
	mock.someMethod("foo", "bar").throws(new Exception("error"));

Custom argument matchers and wildcards

	mock.foo(anyString).returns("hello");
	mock.foo(anyString).verify();

Verify exact number of invocations 

	mock.foo().verify(2);//raw integers supported since 1.3.0
	mock.foo().verify(times(2));
	mock.foo().verify(atLeast(2));
	mock.foo().verify(atLeastOnce);
	mock.foo().verify(never);

Spying on real objects

	var spy = spy(SomeClass);//creates instance where all methods are real (not stubbed)
	spy.foo(); // calls real method;
	
	spy.foo().stub();
	spy.foo(); //calls default stub;
	
	spy.foo().returns("hello");
	spy.foo(); //calls custom stub;


Partial Mocking

	var mock = mock(SomeClass);
	mock.foo().callsRealMethod();
	mock.foo();//calls out to real method


Mock properties that are read or write only

	mock.someProperty.returns("hello");
	mock.someSetter.throws("exception");
	mock.someGetter.throws("exception");
	mock.someGetter.calls(function(){return "foo"});

# Create a Mock

Import Mockatoo module

	import mockatoo.Mockatoo.*;

Use 'using' mixin to greatly simplify mocking api (since 1.3.0)

	using mockatoo.Mockatoo.*;

Mocks can be generated from any Class, Interface or Typedef alias (not typedef structure)

	var mockedClass = mock(SomeClass);
	var mockedInterface = mock(SomeInterface);

	// or without using static imports
	Mockatoo.mock(SomeClass);

A Mock class type will be generated that extends the Class (or Interface), stubbing all methods, and generate the code to instanciate the instance:

	var mockedClass = new SomeClassMocked();
	var mockedInterface = new SomeInterfaceMocked();

If a class requires Type paramaters then you can either use a typedef alias.

	typedef FooBar = Foo<Bar>;

	...

	var mockFoo =  mock(FooBar);

Or pass through the types as a second paramater

	var mockFoo = mock(Foo,[Bar]);

Both these generates the equivalent expressions:

	var mockFoo = new FooMocked<Bar>();


> Note: These usages are required in order to circumvent limitation of compiler with generics. You cannot compile `Foo.doSomething(Array<String>)`


You can also 'mock' a typedef structure, however the
generated object is not technically a mock, so does not support verification or stubbing.

	typedef SomeTypeDef = {name:String}
	...
	var mockedTypDef = SomeTypeDef.mock();

# Verifying Behaviour

Verification refers to validation of of if, and how often a method has been
called (invoked) with particular argument values.

To verify that a method *foo* has been invoked:

	mock.someMethod("someValue").verify(); //verify called once
	mock.someMethod("someValue").verify(2); //verify called twice

	// or without using 'using'
	Mockatoo.verify(mock.someMethod("someValue"), 2);

Once created, mock will remember all interactions. Then you can selectively verify whatever interaction you are interested in.


# Basic Stubbing

Mockatoo allows the behaviour of methods to be stubbed

	mock.someMethod("foo").returns("hello");

	// or without using 'using'
	Mockatoo.when(mock.someMethod("foo")).thenReturn("hello");

You can also specify an execption

	mock.someMethod("bar").throws(new SomeException("is not foo"));

	//or without using 'using'
	Mockatoo.when(mock.someMethod("bar")).thenThrow(new SomeException("is not foo"));

# Argument Matchers

Mockatoo verifies argument values in natural syntax: by using an <code>equals()</code> method. Sometimes, when extra flexibility is required then you might use argument matchers. Matchers can be used for both verifying and stubbing fields.


Matching against a type:

	mock.foo(anyString).verify();

	//other examples
	mock.foo(anyInt).verify();
	mock.foo(anyFloat).verify();
	mock.foo(anyBool).verify();
	mock.foo(anyObject).verify(); 	//anonymous data structures only (not class instances)
	mock.foo(anyIterator).verify(); // any Iterator or Iterable (e.g. Array, Hash, etc)
	mock.foo(anyEnum).verify(); 	// any enum value of any enum;

Matching against a specific class or enum:

	mock.foo(enumOf(Color)).verify(); 		 	// any enum value of Enum Colour
	mock.foo(instanceOf(SomeClass)).verify(); 	// any instance of SomeClass (or it's subclasses)


Wildcard matches

	mock.foo(any).verify();	 		//any value (including null)
	mock.foo(isNotNull).verify();	// any non null value

Custom matching function

	var f = function(value:Dynamic):Bool
	{
		return value == "foo";
	}

	mock.foo(customMatcher(f)).verify();


# Verifying exact number of invocations

Verifications use natural language to specify the minimum and maximum times a method was invoked with specific arguments

	mock.foo().verify(2);
	mock.foo().verify(times(2));
	mock.foo().verify(atLeast(2));
	mock.foo().verify(atLeastOnce);
	mock.foo().verify(never);

> Note: Default mode is times(1);


# Advanced stubbing

Stubbing is chainable, so you can stub with different behavior for consecutive method calls.

This can be achieved by providing multiple return (or thrown) values:

	mock.someMethod().returns("a", "b");
	mock.someMethod().throws("one", "two");

Combinations can also be chained together

	Mockatoo.when(mock.someMethod()).thenReturn("one", "two").thenThrow("empty");

The last stubbing (e.g: thenThrow("empty")) determines the behavior for any further consecutive calls.

**Custom Callback Stub**

You can also set a custom callback when a method is invoked

	var f = function(args:Array<Dynamic>)
	{
		if(Std.is(args[0], String) return args[0].charAt(0) == "b";
	}

	mock.foo("bar")).calls(f);

	//or without using 'using'
	Mockatoo.when(mock.foo("bar")).thenCall(f);

Mockatoo supports several other stubbing options defined later in this document

	mock.foo("bar")).callsRealMethod(); // calls out to real method
	mock.foo("bar")).stub(); // resets default stubbing behaviour


# Resetting a mock

You can reset a mock to remove any custom stubs and/or verifications

	Mockatoo.reset(mock);

# Spying on real objects

> Since 1.1.0

You can create spies of real objects. When you use the spy then the real methods
are called unless a method is explicitly stubbed.


Real spies should be used carefully and occasionally, for example when dealing with legacy code.

	var mock = spy(SomeClass);
	//or without using static imports
	var mock = Mockatoo.spy(SomeClass);

All method calls (both real and stubbed) are recorded for verification

	mock.someMethod();//calls real method
	
	mock.someMethod().returns("one");
	mock.someMethod();//returns stub value;

	mock.someMethod().verify(2); //both calls recorded

You can also quickly convert a real method to the default stub behaviour:

	mock.someMethod().stub();
	mock.someMethod(); //returns default mock value (usually null)


There are several limitations to spying:

* The real constructor cannot be accessed directly, and will always be called with
the default values for each argument type - e.g:

			super(null,null,null);

* Interfaces cannot be spied (Mockatoo will ignore these and used normal mocking instead)

# Partial Mocking

> Since 1.2.0

You can explicitly set a mock to call out to the underlying real method

	mock.someMethod().callsRealMethod();

Like spies, you can also reset them to their mocked behaviour

	mock.someMethod().stub();

# Mocking Properties that are read or write only

> Since 1.2.0

A property that is read/write only, or calls out to getter/setter functions
can be stubbed to a specific return value:

	mock.someReadOnlyProperty.returns("foo");


If a property has a getter function, stubbing a return value will automatically
stub the underlying getter method - the equivalent of:

	Mockatoo.when(mock.get_someReadOnlyProperty()).thenReturn("foo"); 

Getters can also be stubbed to a custom callback:

	mock.someGetter.calls(f); 

Both Getters and Setters can also be stubbed with an exception:

	mock.someGetter).throws("foo");
	mock.someSetter).throws("foo");

	var result = mock.someGetter;//throws exception
	mock.someSetter = "a";//throws exception


>Note: If a property has both a getter and setter, both getting and setting the
property with trigger the exception


There are some limitations to property stubbing:

* stubbed properties cannot be chained (thenReturn("foo", "bar", "etc"))
* only getters support stubbed callbacks (`thenCall(f)`)
* only getter and setters support stubbed exceptions (`thenThrow(xxx)`)


# Known Limitations

## Mocking inlined methods

In Haxe 2.10 inlined methods cannot be mocked. Mockatoo will print a compiler warning and skip affected fields.

	inline public function someMethod()
	{
		// ..
	}

In Haxe 3 this has been resolved (<http://code.google.com/p/haxe/issues/detail?id=1231>) and requires the `--no-inline` compiler flag

## Mocking final classes and methods

Mockatoo supports overriding @:final classes and methods in targets other than flash.

	@:final public function someMethod()
	{
		// ..
	}

Mocking a @:final class in flash will throw a compiler error.

Mocking a @:final method in flash will generate a compiler warning and leave the
real method untouched.

See <http://code.google.com/p/haxe/issues/detail?id=1246> for more details.

## Mocking methods which reference private types

Some classes may expect arguments, or return values typed to a private Class, Enum or Typedef. For example, mocking `haxe.Http` will fail to compile on the neko target due to a reference to `private typedef AbstractSocket`

	Mockatoo.mock(haxe.Http);

This is due to an edge case with tink_macros that is fixed in tink_macros 1.2.1;
