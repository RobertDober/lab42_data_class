
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
    expect{ bad_constraint.new(value: "a") }.not_to raise_error(constraint_error) # BUT SHOULD
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
- `TripleOf(fst, snd, trd)` → `-> { Triple === _1 && fst.(_1.first) && snd.(_1.second) && trd.(_1.third) }`

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
- `Lambda(arity=-1)` a callable with the given arity → `-> { _1.respond_to?(:arity) && _1.arity == arity }`

### String Constraints

- `StartsWith(string)` → `-> { _1.start_with?(string) }`
- `EndsWith(string)` → `-> { _1.end_with?(string) }`
- `Contains(string)` → `-> { _1.contains?(string) }`

### Miscellaneous

- `Anything` useful with `PairOf` or `TripleOf` e.g. `PairOf(Symbol, Anything)` → `-> {true}`
- `Boolean` → `Set.new([false, true])`
<!--SPDX-License-Identifier: Apache-2.0-->
