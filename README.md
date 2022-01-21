
[![Gem Version](http://img.shields.io/gem/v/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)
[![CI](https://github.com/robertdober/lab42_data_class/workflows/CI/badge.svg)](https://github.com/robertdober/lab42_data_class/actions)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/lab42_data_class/badge.svg?branch=main)](https://coveralls.io/github/RobertDober/lab42_data_class?branch=main)


# Lab42::DataClass

A dataclass with an immutable API (you can still change the state of the object with metaprogramming and `lab42_immutable` is not ready yet!)

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

#### Context: Immutable

Given
```ruby
    let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
```
Then we have a new instance with the old instance unchanged
```ruby
    expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
    expect(my_instance.to_h).to eq(name: "robert", email: nil)
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
### Context: Making a dataclass from a class

Given
```ruby
    class DC
      dataclass x: 1, y: 41
      def sum; x + y end
    end
```

Then we can define methods on it
```ruby
   expect(DC.new.sum).to eq(42)
```

And we have a nice name for our instances
```ruby
    expect(DC.new.class.name).to eq("DC")
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

# LICENSE

Copyright 2022 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
<!-- SPDX-License-Identifier: Apache-2.0-->
