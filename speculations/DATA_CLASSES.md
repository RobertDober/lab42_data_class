# Data Classes

Given the following `DataClass`
```ruby
    let(:constraint_error) { Lab42::DataClass::ConstraintError }

    class Animal
      extend Lab42::DataClass
      attributes :name, :age, :species
    end
```

And some specimen
```ruby
    let(:vilma) { Animal.new(name: "Vilma", species: "dog", age: 18) } # RIP my dear lab42
```

### Context: Pattern Matching

Then we can pattern match on it:
```ruby
    vilma => {name:, species:}
    expect(name).to eq("Vilma")
    expect(species).to eq("dog")
```


### Context: Constraints

Data Classes can have very specific constraints on their attributes, we shall speculate about
this by using _Inheritance_ on the fly

Given a specialised form of `Animal`
```ruby
    class Dog < Animal
      extend Lab42::DataClass
      attributes :breed

      constraint :breed, Set.new(["Labrador", "Australian Shepherd"])
      constraint :species, [:==, "dog"] # This of course is a code smell, the base class needing to be constrained
                                        # but for the sake of the demonstration please bear with me (just do not do
                                        # this at home)
    end
```

Then we can instantiate an object as long as we obey the constraints
```ruby
    Dog.new(age: 18, name: "Vilma", breed: "Labrador", species: "dog")
```

But we will get `ConstraintError`s if we do not
```ruby
    expect do
      Dog.new(age: 18, name: "Vilma", breed: "Pug", species: "dog")
    end
      .to raise_error(constraint_error)
```

Or
```ruby
    expect do
      Dog.new(age: 18, name: "Vilma", breed: "Labrador", species: "human")
    end
      .to raise_error(constraint_error)
```

### Context: Defaults

Let us fix the code smell and introduce _default values for attributes_ at the same time

Given a better base
```ruby
    module WithAgeAndName
      extend Lab42::DataClass

      attributes :name, :age
      constraint :name, String
      constraint :age, [:>=, 0]
    end
```

And then a new Dog class
```ruby
    class BetterDog
      include WithAgeAndName
      extend Lab42::DataClass

      AllowedBreeds = [
        "Labrador", "Australian Shepherd"
      ]

      attributes breed: "Labrador"

      constraint :breed, Set.new(AllowedBreeds)
    end
```

Then construction can use the defaults now
```ruby
    expect(BetterDog.new(age: 18, name: "Vilma").to_h)
      .to eq(name: "Vilma", age: 18, breed: "Labrador")
```

And is object to the constraints of the included module
```ruby
    expect do
      BetterDog.new(age: 18, name: :Vilma)
    end
      .to raise_error(constraint_error, "value :Vilma is not allowed for attribute :name")
```

And of the constraints of the base class too
```ruby
    expect do
      BetterDog.new(age: 18, name: "Vilma", breed: "Pug")
    end
      .to raise_error(constraint_error, %{value "Pug" is not allowed for attribute :breed})
```

### Context: Derived Attributes

Let us change the domain for _Derived Attributes_ now and assume that we are parsing
Markdown and use Data Classes for our _tokens_ produced by the Scanner, a Real World Use Case™
for once:

Given a base token
```ruby
    module Token
      extend Lab42::DataClass

      attributes :line, :content, lnb: 0
    end
```

And, say a `HeaderToken`  token
```ruby
    class HeaderToken
      include Token
      extend Lab42::DataClass

      derive :content do
        _1.line.gsub(/^\s*\#+\s*/, "")
      end

      derive :level do
        _1.line[/^\s*\#+\s*/].strip.length
      end
    end
```

Then we can observe how _defaults_ and _derivations_ provide us with the final object
```ruby
    expect(HeaderToken.new(line: "# Hello").to_h)
      .to eq(line: "# Hello", content: "Hello", lnb: 0, level: 1)
```
<!--SPDX-License-Identifier: Apache-2.0-->
