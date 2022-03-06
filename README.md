
[![Issue Count](https://codeclimate.com/github/RobertDober/lab42_data_class/badges/issue_count.svg)](https://codeclimate.com/github/RobertDober/lab42_data_class)
[![CI](https://github.com/robertdober/lab42_data_class/workflows/CI/badge.svg)](https://github.com/robertdober/lab42_data_class/actions)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/lab42_data_class/badge.svg?branch=main)](https://coveralls.io/github/RobertDober/lab42_data_class?branch=main)
[![Gem Version](http://img.shields.io/gem/v/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)
[![Gem Downloads](https://img.shields.io/gem/dt/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)


# Lab42::DataClass

An Immutable DataClass for Ruby

Exposes a class factory function `Kernel::DataClass` and a module `Lab42::DataClass` which can
extend classes to become _Data Classes_.

Also exposes two _tuple_ classes, `Pair` and `Triple`

## Synopsis

Having immutable Objects has many well known advantages that I will not ponder upon in detail here.

One advantage which is of particular interest though is that, as every, _modification_ is in fact the
creation of a new object **strong contraints** on the data can **easily** be maintained, and this
library makes that available to the user.

Therefore we can summarise the features (or not so features, that is for you to decide and you to chose to use or not):

  - Immutable with an Interface à la `OpenStruct`
  - Attributes are predefined and can have **default values**
  - Construction with _keyword arguments_, **exclusively**
  - Conversion to `Hash` instances (if you must)
  - Pattern matching exactly like `Hash` instances
  - Possibility to impose **strong constraints** on attributes
  - Predefined constraints and concise syntax for constraints
  - Possibility to impose **arbitrary validation** (constraints on the whole object)
  - Declaration of **dependent attributes** which are memoized (thank you _Immutability_)
  - Inheritance with **mixin of other dataclasses** (multiple if you must)

## Usage

```sh
  gem install lab42_data_class
```

With bundler

```ruby
  gem 'lab42_data_class'
```

In your code

```ruby
require 'lab42/data_class'
```

## Speculations (literate specs)

The following specs are executed with the [speculate about](https://github.com/RobertDober/speculate_about) gem.

Given that we have imported the `Lab42` namespace
```ruby
    DataClass = Lab42::DataClass
```

## Context: Data Classes

### Basic Use Case

Given a simple Data Class
```ruby
    class SimpleDataClass
      extend DataClass
      attributes :a, :b
    end
```

And an instance of it
```ruby
    let(:simple_instance) { SimpleDataClass.new(a: 1, b: 2) }
```

Then we access the fields
```ruby
    expect(simple_instance.a).to eq(1)
    expect(simple_instance.b).to eq(2)
```

And we convert to a hash
```ruby
    expect(simple_instance.to_h).to eq(a: 1, b: 2)
```

And we can derive new instances
```ruby
    new_instance = simple_instance.merge(b: 3)
    expect(new_instance.to_h).to eq(a: 1, b: 3)
    expect(simple_instance.to_h).to eq(a: 1, b: 2)
```

For detailed speculations please see [here](speculations/DATA_CLASSES.md)

## Context: `DataClass` function

As seen in the speculations above it seems appropriate to declare a `Class` and
extend it as we will add quite some code for constraints, derived attributes and validations.

However a more concise _Factory Function_ might still be very useful in some use cases...

Enter `Kernel::DataClass` **The Function**

### Context: Just Attributes

If there are no _Constraints_, _Derived Attributes_, _Validation_ or _Inheritance_ this concise syntax
might easily be preferred by many:

Given some example instances like these
```ruby
    let(:my_data_class) { DataClass(:name, email: nil) }
    let(:my_instance) { my_data_class.new(name: "robert") }
```

Then we can access its fields
```ruby
    expect(my_instance.name).to eq("robert")
    expect(my_instance[:email]).to be_nil
```

But we cannot access undefined fields
```ruby
    expect{ my_instance.undefined }.to raise_error(NoMethodError)
```

And this is even true for the `[]` syntax
```ruby
    expect{ my_instance[:undefined] }.to raise_error(KeyError)
```

And we need to provide values to fields without defaults
```ruby
    expect{ my_data_class.new(email: "some@mail.org") }
      .to raise_error(ArgumentError, "missing initializers for [:name]")
```
And we can extract the values
```ruby
    expect(my_instance.to_h).to eq(name: "robert", email: nil)
```

#### Context: Immutable → self

Then `my_instance` is frozen:
```ruby
    expect(my_instance).to be_frozen
```
And we cannot even mute `my_instance`  by means of metaprogramming
```ruby
    expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
```

#### Context: Immutable → Cloning

Given
```ruby
    let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
```
Then we have a new instance with the old instance unchanged
```ruby
    expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
    expect(my_instance.to_h).to eq(name: "robert", email: nil)
```
And the new instance is frozen again
```ruby
    expect(other_instance).to be_frozen
```

For speculations how to add all the other features to the _Factory Function_ syntax please
look [here](speculations/FACTORY_FUNCTION.md)



## Context: `Pair` and `Triple`

Two special cases of a `DataClass` which behave like `Tuple` of size 2 and 3 in _Elixir_


They distinguish themselves from `DataClass` classes by accepting only positional arguments, and
cannot be converted to hashes.

These are actually two classes and not class factories as they have a fixed interface , but let us speculate about them to learn what they can do for us.

### Context: Constructor functions

Given a pair
```ruby
    let(:token) { Pair("12", 12) }
    let(:node)  { Triple("42", 4, 2) }
```

Then we can access their elements
```ruby
    expect(token.first).to eq("12")
    expect(token.second).to eq(12)
    expect(node.first).to eq("42")
    expect(node.second).to eq(4)
    expect(node.third).to eq(2)
```

And we can treat them like _Indexable_
```ruby
    expect(token[1]).to eq(12)
    expect(token[-2]).to eq("12")
    expect(node[2]).to eq(2)
```

And convert them to arrays of course
```ruby
    expect(token.to_a).to eq(["12", 12])
    expect(node.to_a).to eq(["42", 4, 2])
```

And they behave like arrays in pattern matching too
```ruby
    token => [str, int]
    node  => [root, lft, rgt]
    expect(str).to eq("12")
    expect(int).to eq(12)
    expect(root).to eq("42")
    expect(lft).to eq(4)
    expect(rgt).to eq(2)
```

And of course the factory functions are equivalent to the constructors
```ruby
    expect(token).to eq(Lab42::Pair.new("12", 12))
    expect(node).to eq(Lab42::Triple.new("42", 4, 2))
```

#### Context: Pseudo Assignments

... in reality return a new object

Given an instance of `Pair`
```ruby
    let(:original) { Pair(1, 1) }
```

And one of `Triple`
```ruby
    let(:xyz) { Triple(1, 1, 1) }
```

Then
```ruby
    second = original.set_first(2)
    third  = second.set_second(2)
    expect(original).to eq( Pair(1, 1) )
    expect(second).to eq(Pair(2, 1))
    expect(third).to eq(Pair(2, 2))
```

And also
```ruby
    second = xyz.set_first(2)
    third  = second.set_second(2)
    fourth = third.set_third(2)
    expect(xyz).to eq(Triple(1, 1, 1))
    expect(second).to eq(Triple(2, 1, 1))
    expect(third).to eq(Triple(2, 2, 1))
    expect(fourth).to eq(Triple(2, 2, 2))
```

## Context: `List`

A `List` is what a _list_ is in Lisp or Elixir it exposes the following API

Given such a _list_
```ruby
    let(:three) { List(*%w[a b c]) }
```

Then this becomes really a _linked_list_
```ruby
    expect(three.car).to eq("a")
    expect(three.cdr).to eq(List(*%w[b c]))
```

For all details please consult the [List speculations](speculations/LIST.md)

# LICENSE

Copyright 2022 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
<!-- SPDX-License-Identifier: Apache-2.0-->
