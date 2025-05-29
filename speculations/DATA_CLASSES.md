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

#### Context: Builtin Constraints

There are the following _Builtin Constraints_

##### Enumerable Constraints

- `All?(constraint)` a constraint that holds for all elements → `-> { _1.all?(&constraint) }`
- `Any?` a constraint that holds for any element → `-> { _1.any?(&constraint) }`
- `PairOf(fst, snd)` →  `-> { Pair === _1 && fst.(_1.first) && snd.(_1.second) }`
- `TripleOf(fst, snd, trd)` → `-> { Triple === _1 && fst.(_1.first) && snd.(_1.second) && trd.(_1.third) }`

##### High Order Constraints

- `Option(constraint)` either nil or satisfies the constraint → `-> { _1.nil? || constraint.(_1) }`
- `Not(constraint)` negation of a constraint → `-> { !constraint.(_1) }`
- `Choice(*constraints)` satisfies one of the constraints, again useful in v0.8 with `ListOf`, e.g. `ListOf(Choice(Symbol, String))` → `-> { |v| constraints.any?{ |c| c.(v) } }`
- `Lambda(arity=-1)` a callable with the given arity → `-> { _1.respond_to?(:arity) && _1.arity == arity }`

##### String Constraints

- `StartsWith(string)` → `-> { _1.start_with?(string) }`
- `EndsWith(string)` → `-> { _1.end_with?(string) }`
- `Contains(string)` → `-> { _1.contains?(string) }`

##### Miscellaneous

- `Anything` useful with `PairOf` or `TripleOf` e.g. `PairOf(Symbol, Anything)` → `-> {true}`
- `Boolean` → `Set.new([false, true])`

Here is a simple example of their usage, detailed description can be found [here](speculations/BUILTIN_CONSTRAINTS.md)

Given a dataclass with a builtin constraint (needs an explicit require)
```ruby
    require "lab42/data_class/builtin_constraints"
    let(:entry) { DataClass(:value).with_constraint(value: PairOf(Symbol, Anything)) }
```

Then these constraints are well observed
```ruby
    expect(entry.new(value: Pair(:world, 42)).value).to eq(Pair(:world, 42))
    expect{ entry.new(value: Pair("world", 43)) }
      .to raise_error(Lab42::DataClass::ConstraintError)
    expect{ entry.new(value: Triple(:world, 43, nil)) }
      .to raise_error(Lab42::DataClass::ConstraintError)
```

#### Attribute Setting Constraints

These are special _builtin constraints_ that allow to set attributes in a very specific, controlled way such as
that the constraint on the attribute needs only be partially checked.

A good example is the `ListOf` constraint.

If an attribute has the `ListOf` constraint then its dataclass instance gets a special `set` method
that allows to create a new dataclass instance in which only the change in the attribute and not the whole attribute needs
to be constraint checked.

Therefore we can still

```ruby
      some_instance.merge(list: some_instance.list.cons(1)) # Bad O(n)
```

or better

```ruby
      some_instance.set(:list).cons(1) # Goof O(1)
```

These special Constraints are described in detail [here](speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md)

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

### Context: Validation

With _Derived Attributes_ we could assure that dependant data was correct, but sometimes dependency is more lose and can be
expressed with _Validations_

The difference between _Constraints_ and _Validations_ is simply that a _Validation_ is a block that will validate the
**whole instance** of a _Data Class_.

Given a DataClass
```ruby
    let(:validation_error) { Lab42::DataClass::ValidationError }
    class Person
      extend Lab42::DataClass

      attributes :name, :age, member: false

      validate :members_are_18 do
        _1.age >= 18 || !_1.member
      end
    end
```

Then we can assure that all members are at least 18 years old
```ruby
    expect do
      Person.new(name: "junior", age: 17, member: true)
    end
      .to raise_error(validation_error)
```

And of course validation is also carried out when new instances are derived
```ruby
    senior = Person.new(name: "senior", age: 42, member: true)
    expect do
      senior.merge(name: "offspring", age: 10)
    end
      .to raise_error(validation_error)
```

#### Context: Validation, a code smell?

I guess too many validations might in fact be a code smell, and even the simple example above might be better
modelled with _Constraints_ in mind

Given a Person module
```ruby
    module Person1
      extend Lab42::DataClass

      attributes :name, :age, :member
      constraint :member, Set.new([false, true])
    end

    class Adult
      include Person1
      extend Lab42::DataClass

      constraint :age, [:>=, 18]
    end

    class Child
      include Person1
      extend Lab42::DataClass

      constraint :age, [:<, 18]
      derive(:member){ false }
    end
```

Seems to be a much cleaner approach

Then it also works _better_ in the way that we cannot _merge_ an `Adult` into a `Child`
```ruby
    expect{ Adult.new(name: "senior", age: 18, member: true) }
      .not_to raise_error

    expect(Child.new(name: "junior", age: 17).to_h).to eq(name: "junior", age: 17, member: false)
```


### Context: Error Handling

#### Duplicate Deriveds

Given an Operation DataClass
```ruby
    let(:duplicate_definition_error) { Lab42::DataClass::DuplicateDefinitionError }
```


Then we must not define the same operation twice
```ruby
    expect do
      Class.new do
        extend Lab42::DataClass
        attributes(lhs: 0, rhs: 0)

        derive(:result) {_1.lhs + _1.rhs}
        derive(:result) {_1.lhs + _1.rhs}
      end
    end
      .to raise_error(duplicate_definition_error, "Redefinition of derived attribute :result")
```

<!--SPDX-License-Identifier: Apache-2.0-->
