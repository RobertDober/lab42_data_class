
## Context: Builtin Constraints


Given some setup
```ruby
    require "lab42/data_class/builtin_constraints"

    let(:constraint_error) { Lab42::DataClass::ConstraintError }
```
### Calling Convention

At first please note that all Builtins that take _exactly_ one constraint
as a paramter can also take a block, the block is registered as a constraint and
**not** it's value

Then surprisingly
```ruby
    bad_constraint = DataClass(:value).with_constraint(value: NilOr{Set.new(%w[x y z])})
    expect{ bad_constraint.new(value: "a") }.not_to raise_error # BUT SHOULD
```

But the following (useless complicated) works:
```ruby
    complicated_constraint = DataClass(:value).with_constraint(value: NilOr{ Set.new(%w[x y z]).member? _1 })
    expect{ complicated_constraint.new(value: "a") }.to raise_error(constraint_error) # BUT SHOULD
```

### Enumerable Constraints

#### Context: `All?(constraint)`

> :warning: This might be costly

Given a dataclass with an array value
```ruby
    let(:listy) { DataClass(value: []).with_constraint(value: All?(:odd?)) }
```
Then we are ok if we obey ;)
```ruby
    expect(listy.new.merge(value: [1, 3]).value).to eq([1, 3])
```

But beware of evens
```ruby
    expect{ listy.new(value: [2]) }
      .to raise_error(constraint_error)
```

#### Context: `Any?(constraint)`

> :warning: This might be costly

This works analogously

Given a dataclass with a hash_value
```ruby
    let(:hashy) { DataClass(:value).with_constraint(value: Any?{|(_,v)| v == 42}) }
```

Then we need a value of 42, of course
```ruby
    expect(hashy.new(value: {a: 42}).value[:a]).to eq(42)
```

And if not, beware
```ruby
    expect{ hashy.new(value: {a: 41, b: 43}) }
      .to raise_error(constraint_error)
```

#### Context: `ListOf(constraint)`

Not only is the constraint a convenient way to validate for linked lists and their contents but
it generates special merge operations that can validate the constraint in `O(1)` runtime as the
tail of the list does not change

<<<<<<< HEAD
Given a `DataClass` with such a constraint
```ruby
    let(:evens) { DataClass(list: Nil, name: "myself").with_constraint(list: ListOf(:even?)) }
=======
For details see [here](ATTRIBUTE_SETTING_CONSTRAINTS.md)

Given a `DataClass` with such a constraint
```ruby
    let(:evens) { DataClass(list: Nil).with_constraint(list: ListOf(:even?)) }
>>>>>>> db85dfe (I021 list of constraint (#27))
```

And we construct such a list (`O(n)` anyway):
```ruby
    let(:fours) { evens.new(list: List(*(1..3).map{ _1 * 4 })) }
```

<<<<<<< HEAD
Then we can just add a new element to such a list
```ruby
    with_0 = fours.set(:list).cons(0)
    expect(with_0.list.car).to eq(0)
    expect(with_0.list.cadr).to eq(4)
    expect(with_0.list.caddr).to eq(8)
```

Or we can remove it
```ruby
    without_4 = fours.set(:list).cdr
    expect(without_4.list.car).to eq(8)
    expect(without_4.list.cadr).to eq(12)
    expect(without_4.list.cddr).to eq(Nil)
```

But we cannot call the setter for a different attribute
```ruby
    expect do
      fours.set(:name)
    end
      .to raise_error(Lab42::DataClass::UndefinedSetterError)
    
=======
But a list with an odd will just not do
```ruby
    expect do
      evens.new(list: List(*0..2))
    end
      .to raise_error(constraint_error)
```

And nor will an array

```ruby
    expect do
      evens.new(list: [0, 2])
    end
      .to raise_error(constraint_error)
>>>>>>> db85dfe (I021 list of constraint (#27))
```


#### Context: `PairOf(fst, snd)`

When defining constraints on our special classes we can dig deeper

Given such a constraint
```ruby
    let(:my_pair){ DataClass(:pair).with_constraint(pair: PairOf(Symbol, [:>, 0])) }
```

Then let us comply with that
```ruby
    expect(my_pair.new(pair: Pair(:alpha, 42)).pair.second).to eq(42)
```

But there are multiple ways to violate this contract
```ruby
    not_a_pair = Triple(:hello, 42, 42)
    not_a_sym = Pair("hello", 1)
    not_positive = Pair(:hello, 0)

    [not_a_pair, not_a_sym, not_positive].each do |culprit|
      expect{my_pair.new(pair: culprit)}
        .to raise_error(constraint_error)
    end
```

For the Attribute Setting Constraints see [here](ATTRIBUTE_SETTING_CONSTRAINTS.md)

#### Context: `TripleOf(fst, snd, trd)`

Nothing new going on here

Given
```ruby
    let(:my_triple) { DataClass(:triple).with_constraint(triple: TripleOf(String, String, String)) }
```

Then strings it shall be
```ruby
    expect{ my_triple.new(triple: Triple("a", "b", "c")) }.not_to raise_error
```

But else
```ruby
    [
      Triple("a", "b", 3),
      Triple("a", 2, "c"),
      Triple(1, "b", "c")
      ].each do |culprit|
      expect{my_triple.new(triple: culprit)}
        .to raise_error(constraint_error)
    end


```

For the Attribute Setting Constraints see [here](ATTRIBUTE_SETTING_CONSTRAINTS.md)

### High Order Constraints

#### Context: NilOr(constraint)

NilOr resambles a `Maybe` type in which `Some` is not stated and `None` is replaced by `nil`.
Therefore a `nil` value is valid and all other values are valid iff they satisfy the constraint.

Given such a constraint
```ruby
    let(:maybe) { DataClass(number: nil).with_constraint(number: NilOr(Fixnum)) }
```

**N.B.** That constraints are checked against _default values_ and therefore the constraint `Fixnum` was not
even applicable under this definition

Then we get
```ruby
    expect(maybe.new.number).to be_nil
    expect(maybe.new(number: 42).number).to eq(42)
    expect{ maybe.new(number: false) }.to raise_error(constraint_error)
```

#### Context: `Not(constraint)`

Not (pun intended) to say here

And therefore
```ruby
    negator = DataClass(:consonant).with_constraint(consonant: Not(Set.new(%w[a e i o u])))
    expect(negator.new(consonant: "b").consonant).to eq("b")
    expect{ negator.new(consonant: "a") }.to raise_error(constraint_error)
```
#### Context: `Choice(*constraints)`

Given a choice between Strings and Symbols as keys we might model as follows
```ruby
    let(:key_constraint) { Choice(String, Symbol) }
    let(:entry) { DataClass(:value).with_constraint(value: PairOf(key_constraint, Anything)) }
```

Then the following holds:
```ruby
    entry.new(value: Pair("hello", "world"))
    entry.new(value: Pair(:hello, 42))
```

But indeed:
```ruby
    expect{ entry.new(value: Pair(42, "hello")) }.to raise_error(constraint_error)
```

#### Context: `Lambda(arity)`

Actually `Lambda` stands for a _callable_ with the given `arity`

Then we see that the following callables are compliant
```ruby
    callable1 = Lambda(1)
    compliants = [
      -> { _1 },
      1.method(:+) ]
    non_compliants = [
      -> { nil },
      42,
      Set.method(:new) # arity -1
      ]
    compliants.each do |compliant|
      expect(callable1.(compliant)).to be_truthy
    end
    non_compliants.each do |culprit|
      expect(callable1.(culprit)).to be_falsy
    end
```

### Context: String Constraints

Given these builtins
```ruby
    let(:starts) { StartsWith("<") }
    let(:ends)   { EndsWith(">") }
    let(:container) { Contains("div") }
```

Then we can check
```ruby
    expect(starts.("<hello")).to be_truthy
    expect(starts.("<")).to be_truthy
    expect(starts.(" ")).to be_falsy
    expect(starts.("")).to be_falsy
    expect(starts.(" <@")).to be_falsy
```

And also
```ruby
    expect(ends.(">")).to be_truthy
    expect(ends.("<hello>")).to be_truthy
    expect(ends.("")).to be_falsy
    expect(ends.("> ")).to be_falsy
```

And eventually
```ruby
    expect(container.("div")).to be_truthy
    expect(container.("some <div>")).to be_truthy
    expect(container.("some <dv>")).to be_falsy
    expect(container.("")).to be_falsy
```


### Miscellaneous

#### Context: `Anything`

This has already been shown (bad practice, but should be obvious)

And we see
```ruby
    expect(Anything.(nil)).to eq(true)
    expect(Anything.(42)).to eq(true)
    expect(Anything.(BasicObject.new)).to eq(true)
    expect(Anything.(self)).to eq(true)
```

#### Context: `Boolean` 

As we do not have such a type in Ruby this constraint is quite useful

And it is true for exactly two values
```ruby
    expect(Boolean.(true)).to eq(true)
    expect(Boolean.(false)).to eq(true)
    expect(Boolean.(nil)).to eq(false)
    expect(Boolean.(42)).to eq(false)
    expect(Boolean.([])).to eq(false)
    expect(Boolean.([false])).to eq(false)
    
```
<!--SPDX-License-Identifier: Apache-2.0-->
