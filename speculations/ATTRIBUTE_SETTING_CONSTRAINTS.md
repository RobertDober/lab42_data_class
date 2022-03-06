# Attribute Setting Constraints

Given this setup
```ruby
    require "lab42/data_class/builtin_constraints"
    let(:constraint_error) { Lab42::DataClass::ConstraintError }
```
## Context: `ListOf(constraint)`


Given a `ListOf` attribute
```ruby
    let(:evens) { DataClass(list: Nil, name: "myself").with_constraint(list: ListOf(:even?)) }
    let(:fours) { evens.new(list: List(*(1..3).map{ _1 * 4 })) }
```

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

```

## Context: `PairOf(left_constraint, right_constraint)`

Given a `DataClass` with a `PairOf` constraint
```ruby
    let(:pairs) { DataClass(:entry).with_constraint(entry: PairOf(Symbol, Fixnum)) }
    let(:instance) { pairs.new(entry: Pair(:a, 1)) }
```

Then we can just create a new instance with a new first element of the pair
```ruby
    expect(instance.set(:entry).first_element(:b).entry).to eq(Pair(:b, 1))
```

Or with the second
```ruby
    expect(instance.set(:entry).second_element(2).entry).to eq(Pair(:a, 2))
```

But the constraints are still validated for the changing value
```ruby
    expect do
      instance.set(:entry).second_element(:b)
    end
      .to raise_error(constraint_error)
```

## Context: `TripleOf(first_constraint, second_constraint, third_constraint)`

Given a `DataClass` with a `TripleOf` constraint
```ruby
    let(:triple) { DataClass(:value).with_constraint(value: TripleOf(Symbol, Fixnum, String)) }
    let(:instance) { triple.new(value: Triple(:a, 1, "hello")) }
```

Then we can just create a new instance with a new first element of the triple
```ruby
    expect(instance.set(:value).first_element(:b).value).to eq(Triple(:b, 1, "hello"))
```

Or with the second
```ruby
    expect(instance.set(:value).second_element(2).value).to eq(Triple(:a, 2, "hello"))
```

Or even the third
```ruby
    expect(instance.set(:value).third_element("world").value).to eq(Triple(:a, 1, "world"))
```

But the constraints are still validated for the changing value
```ruby
    expect do
      instance.set(:value).second_element(:b)
    end
      .to raise_error(constraint_error)
    expect do
      instance.set(:value).third_element(42)
    end
      .to raise_error(constraint_error)
```
<!--SPDX-License-Identifier: Apache-2.0-->
