
[![Issue Count](https://codeclimate.com/github/RobertDober/lab42_data_class/badges/issue_count.svg)](https://codeclimate.com/github/RobertDober/lab42_data_class)
[![CI](https://github.com/robertdober/lab42_data_class/workflows/CI/badge.svg)](https://github.com/robertdober/lab42_data_class/actions)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/lab42_data_class/badge.svg?branch=main)](https://coveralls.io/github/RobertDober/lab42_data_class?branch=main)
[![Gem Version](http://img.shields.io/gem/v/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)
[![Gem Downloads](https://img.shields.io/gem/dt/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)


# Lab42::DataClass


An Immutable DataClass for Ruby

Exposes a class factory function `Kernel::DataClass` and a class
modifer `Module#dataclass`, also creates two _tuple_ classes, `Pair` and
`Triple`

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


## So what does it do?

Well let us [speculate about](https://github.com/RobertDober/speculate_about) it to find out:

## Context `DataClass`

### Context: `DataClass` function

Given
```ruby
    let(:my_data_class) { DataClass(:name, email: nil) }
    let(:my_instance) { my_data_class.new(name: "robert") }
```

Then we can access its fields
```ruby
    expect(my_instance.name).to eq("robert")
    expect(my_instance.email).to be_nil
```

But we cannot access undefined fields
```ruby
    expect{ my_instance.undefined }.to raise_error(NoMethodError)
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

### Context: Defining behavior with blocks

Given
```ruby
    let :my_data_class do
      DataClass :value, prefix: "<", suffix: ">" do
        def show
          [prefix, value, suffix].join
        end
      end
    end
    let(:my_instance) { my_data_class.new(value: 42) }
```

Then I have defined a method on my dataclass
```ruby
    expect(my_instance.show).to eq("<42>")
```

### Context: Equality

Given two instances of a DataClass
```ruby
    let(:data_class) { DataClass :a }
    let(:instance1) { data_class.new(a: 1) }
    let(:instance2) { data_class.new(a: 1) }
```
Then they are equal in the sense of `==` and `eql?`
```ruby
    expect(instance1).to eq(instance2)
    expect(instance2).to eq(instance1)
    expect(instance1 == instance2).to be_truthy
    expect(instance2 == instance1).to be_truthy
```
But not in the sense of `equal?`, of course
```ruby
    expect(instance1).not_to be_equal(instance2)
    expect(instance2).not_to be_equal(instance1)
```

#### Context: Immutability of `dataclass` modified classes

Then we still get frozen instances
```ruby
    expect(instance1).to be_frozen
```

### Context: Inheritance

... is a no, we do not want inheritance although we **like** code reuse, how to do it then?

Well there shall be many different possibilities, depending on your style, use case and
context, here is just one example:

Given a class factory
```ruby
    let :token do
      ->(*a, **k) do
        DataClass(*a, **(k.merge(text: "")))
        end
    end
```

Then we have reused the `token` successfully
```ruby
    empty = token.()
    integer = token.(:value)
    boolean = token.(value: false)

    expect(empty.new.to_h).to eq(text: "")
    expect(integer.new(value: -1).to_h).to eq(text: "", value: -1)
    expect(boolean.new.value).to eq(false)
```

#### Context: Mixing in a module can be used of course

Given a behavior like
```ruby
    module Humanize
      def humanize
        "my value is #{value}"
      end
    end

    let(:class_level) { DataClass(value: 1).include(Humanize) }
```

Then we can access the included method
```ruby
    expect(class_level.new.humanize).to eq("my value is 1")
```

### Context: Pattern Matching

A `DataClass` object behaves like the result of it's `to_h` in pattern matching

Given
```ruby
    let(:numbers) { DataClass(:name, values: []) }
    let(:odds) { numbers.new(name: "odds", values: (1..4).map{ _1 + _1 + 1}) }
    let(:evens) { numbers.new(name: "evens", values: (1..4).map{ _1 + _1}) }
```

Then we can match accordingly
```ruby
    match = case odds
            in {name: "odds", values: [1, *]}
              :not_really
            in {name: "evens"}
              :still_naaah
            in {name: "odds", values: [hd, *]}
              hd
            else
              :strange
            end
    expect(match).to eq(3)
```

And in `in` expressions
```ruby
    evens => {values: [_, second, *]}
    expect(second).to eq(4)
```

#### Context: In Case Statements

Given a nice little dataclass `Box`
```ruby
    let(:box) { DataClass content: nil }
```

Then we can also use it in a case statement
```ruby
    value = case box.new
      when box
        42
      else
        0
      end
    expect(value).to eq(42)
```

And all the associated methods
```ruby
    expect(box.new).to be_a(box)
    expect(box === box.new).to be_truthy
```

### Context: Behaving like a `Proc`

It is useful to be able to filter heterogeneous lists of `DataClass` instances by means of `&to_proc`, therefore

Given two different `DataClass` objects
```ruby
    let(:class1) { DataClass :value }
    let(:class2) { DataClass :value }
```

And a list of instances
```ruby
    let(:list) {[class1.new(value: 1), class2.new(value: 2), class1.new(value: 3)]}
```

Then we can filter
```ruby
    expect(list.filter(&class2)).to eq([class2.new(value: 2)])
```

### Context: Behaving like a `Hash`

We have already seen the `to_h` method, however if we want to pass an instance of `DataClass` as 
keyword parameters we need an implementation of `to_hash`, which of course is just an alias

Given this keyword method
```ruby
    def extract_value(value:, **others)
      [value, others]
    end
```
And this `DataClass`:
```ruby
    let(:my_class) { DataClass(value: 1, base: 2) }
```

Then we can pass it as keyword arguments
```ruby
    expect(extract_value(**my_class.new)).to eq([1, base: 2])
```

### Context: Constraints

Values of attributes of a `DataClass` can have constraints

Given a `DataClass` with constraints
```ruby
    let :switch do
      DataClass(on: false).with_constraint(on: -> { [false, true].member? _1 })
    end
```

Then boolean values are acceptable
```ruby
    expect{ switch.new }.not_to raise_error
    expect(switch.new.merge(on: true).on).to eq(true)
```

But we can neither construct or merge with non boolean values
```ruby
    expect{ switch.new(on: nil) }
     .to raise_error(Lab42::DataClass::ConstraintError, "value nil is not allowed for attribute :on")
    expect{ switch.new.merge(on: 42) }
     .to raise_error(Lab42::DataClass::ConstraintError, "value 42 is not allowed for attribute :on")
```

And therefore defaultless attributes cannot have a constraint that is violated by a nil value
```ruby
    error_head = "constraint error during validation of default value of attribute :value"
    error_body = "  undefined method `>' for nil:NilClass"
    error_message = [error_head, error_body].join("\n")

    expect{ DataClass(value: nil).with_constraint(value: -> { _1 > 0 }) }
      .to raise_error(Lab42::DataClass::ConstraintError, /#{error_message}/)
```

And defining constraints for undefined attributes is not the best of ideas
```ruby
    expect { DataClass(a: 1).with_constraint(b: -> {true}) }
      .to raise_error(ArgumentError, "constraints cannot be defined for undefined attributes [:b]")
```


#### Context: Convenience Constraints

Often repeating patterns are implemented as non lambda constraints, depending on the type of a constraint
it is implicitly converted to a lambda as specified below:

Given a shortcut for our `ConstraintError`
```ruby
    let(:constraint_error) { Lab42::DataClass::ConstraintError }
    let(:positive) { DataClass(:value) }
```

##### Symbols

... are sent to the value of the attribute, this is not very surprising of course ;)

Then a first implementation of `Positive`
```ruby
    positive_by_symbol = positive.with_constraint(value: :positive?)

    expect(positive_by_symbol.new(value: 1).value).to eq(1)
    expect{positive_by_symbol.new(value: 0)}.to raise_error(constraint_error)
```

##### Arrays

... are also sent to the value of the attribute, this time we can provide paramaters
And we can implement a different form of `Positive`
```ruby
    positive_by_ary = positive.with_constraint(value: [:>, 0])

    expect(positive_by_ary.new(value: 1).value).to eq(1)
    expect{positive_by_ary.new(value: 0)}.to raise_error(constraint_error)
```

If however we are interested in membership we have to wrap the `Array` into a `Set`

##### Membership

And this works with a `Set`
```ruby
    positive_by_set = positive.with_constraint(value: Set.new([*1..10]))

    expect(positive_by_set.new(value: 1).value).to eq(1)
    expect{positive_by_set.new(value: 0)}.to raise_error(constraint_error)
```

And also with a `Range`
```ruby
    positive_by_range = positive.with_constraint(value: 1..Float::INFINITY)

    expect(positive_by_range.new(value: 1).value).to eq(1)
    expect{positive_by_range.new(value: 0)}.to raise_error(constraint_error)
```

##### Regexen

This seems quite obvious, and of course it works

Then we can also have a regex based constraint
```ruby
    vowel = DataClass(:word).with_constraint(word: /[aeiou]/)

    expect(vowel.new(word: "alpha").word).to eq("alpha")
    expect{vowel.new(word: "krk")}.to raise_error(constraint_error)
```

##### Other callable objects as constraints


Then we can also use instance methods to implement our `Positive`
```ruby
    positive_by_instance_method = positive.with_constraint(value: Fixnum.instance_method(:positive?))

    expect(positive_by_instance_method.new(value: 1).value).to eq(1)
    expect{positive_by_instance_method.new(value: 0)}.to raise_error(constraint_error)
```

Or we can use methods to implement it
```ruby
    positive_by_method = positive.with_constraint(value: 0.method(:<))

    expect(positive_by_method.new(value: 1).value).to eq(1)
    expect{positive_by_method.new(value: 0)}.to raise_error(constraint_error)
```

#### Context: Global Constraints aka __Validations__

So far we have only speculated about constraints concerning one attribute, however sometimes we want
to have arbitrary constraints which can only be calculated by access to more attributes

Given a `Point` DataClass
```ruby
    let(:point) { DataClass(:x, :y).validate{ |point| point.x > point.y } }
    let(:validation_error) { Lab42::DataClass::ValidationError }
```

Then we will get a `ValidationError` if we construct a point left of the main diagonal
```ruby
    expect{ point.new(x: 0, y: 1) }
      .to raise_error(validation_error)
```

But as validation might need more than the default values we will not execute them at compile time
```ruby
    expect{ DataClass(x: 0, y: 0).validate{ |inst| inst.x > inst.y } }
      .to_not raise_error
```

And we can name validations to get better error messages
```ruby
    better_point = DataClass(:x, :y).validate(:too_left){ |point| point.x > point.y }
    ok_point     = better_point.new(x: 1, y: 0)
    expect{ ok_point.merge(y: 1) }
      .to raise_error(validation_error, "too_left")
```

And remark how bad unnamed validation errors might be
```ruby
    error_message_rgx = %r{
       \#<Proc:0x[0-9a-f]+ \s .* spec/speculations/README_spec\.rb: \d+ > \z
    }x
    expect{ point.new(x: 0, y: 1) }
      .to raise_error(validation_error, error_message_rgx)
```

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

# LICENSE

Copyright 2022 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
<!-- SPDX-License-Identifier: Apache-2.0-->
