Introduction
============

The MassiveUI framework is built on years of experience in building user 
interfaces for the web, internet enabled TVs and in flight entertainment 
systems. As a result, it is a framework that strikes a careful balance between 
utility and flexibility.

The concepts at the core of the framework are:

* Flexibility: we take pride in delivering the right user experience for 
  brands, users and devices. This often means creating bespoke experiences that 
  do not fit into establish interaction patterns. Rather than provide "out of 
  the box" solutions to problems, the framework provides a rich tool-set for 
  rapidly creating custom experiences.
* Separation: the core challenges of developing user interfaces – navigation, 
  data, layout, skinning, etc. – are addressed by distinct modules of 
  functionality. This separation facilitates customisation of user experience 
  for different devices.
* Extensibility: much thought has been given not only to the API's developers 
  use to build with the framework, but how core functionality can be customised 
  to meet their needs.

Component
=========

Graphical user interfaces share a common language. Objects on the screen are a 
visual representation of the data and state of the system. They take input from 
the user (clicking, touching, pressing), manipulate the state of the system and 
update to reflect changes in state. At the core of MassiveUI is a clean 
separation between data and visual representation.

As a simple example, imagine an application that allows users to browse the 
following collection of products:

--------------------------------------------------------
| Title	  | Description                | Image | Price |
--------------------------------------------------------
| Apples  | Fresh Granny Smith apples. |       | $2    |
--------------------------------------------------------
| Oranges | Tangy Seville oranges.     |       | $4    |
--------------------------------------------------------
| Pears	  | Sweet Bosc pears.          |       | $3    |
--------------------------------------------------------

Each product is an object in the application, represented by the following data:

	class Product
	{
		var title:String;
		var description:String;
		var image:String;
		var price:Float;
	}

As the user navigates the application, they are presented with different 
graphic representations of the data. One representation might a row in a list.

[]

Another might be a product detail view.

[]

Another might be a tile in a product gallery.

[]

Or a line item on a customers order.

[]

In each case, the data represented is the same. The representation might vary 
based on the intent of the user, or the context in which it is being viewed. It 
might also vary based on the device the customer is using to access the store.

In MassiveUI, a visual representation of data which a user can interact with is 
called a component. A component manages the visual representation of the data, 
as well as it's behaviour in response to user input.

The following pseudo class represents the core features of a component.

class Component<T> extends Display
{
	public var data:T;
	public var focused:Bool;
	public var selected:Bool;
}

Components in MassiveUI take advantage of Haxe type parameters, allowing 
developers restrict components to displaying data of a particular type. The 
following code demonstrates the advantage of this approach.

	class ProductDetail extends DataComponent<Product>
	{
		public function new()
		{
			super();
		}
	}
	 
	// usage
	var detail = new ProductDetail();
	detail.data = new Product();
	detail.data = 10; // compile time error, data is of type Product

Container
=========

A container is a group of components.

Collection
==========

A collection is a container that populates itself with components in response to its data.
