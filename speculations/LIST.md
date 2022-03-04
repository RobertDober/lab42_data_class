
# `Lab42::List` a linked list implementation with a LISP like API

As for when to use a linked list and when not, this is not the scope for a detailed discussion.

However a some very quick guidelines

## Introduction

### Use a linked list

- When you access only a bound number of elements from the top  (e.g. a stack)

- When your list size is bound to a relatively small number (depends on a lot of factors but 100 should not be a problem)
**unless** the other constrains listed here hold

- When you push often to the top of the list

- When you remove often from the top of the list

- The length is tracked though and is of complexity `O(1)`

- `List` is immutable and thusly _thread safe_

- `List` paired with the `ListOf` constraint creates an efficient way
to update list attributes in `DataClass` instances with `O(1)` constraint validation (unless you use `merge(list: ...)`

As a résumé, when your use case is similar to a stack

### Do not use a linked list

When the following operations which are all `O(n)` may be too costly (see above for when n should not be a problem)

- Random Access à la `list[k]`

- Appending and reading the end

- Traversing (that includes reversing) the list with its `Enumerable` API
Though a typical use case is ok:
  
  - Start with an empty list

  - Extensive computations pushing elements to the top

  - **Eventually** and **only once** reverse the list (into an array)


## Context: API

### Base Constructor `cons`

Given we constract a list with `Nil`
```ruby
    let(:list) { Lab42::List }
    let(:my_list) { list.cons(42, Nil) }
```

### Convenience Constructor

And with the convenience constructor
```ruby
    let(:same_list) { List(42) }
```

Then they are actually the same
```ruby
    expect(my_list).to eq(same_list)
```

And the convenience constructor is actually nothing other than:
```ruby
    expect(List(1, 2)).to eq(list.new(1, 2))
```

And remark also that the constructor can return `Nil`
```ruby
    expect(List()).to eq(Nil)
```

### Context: Length

As mention in the [README.md](../README.md) length is tracked and can be computed in `O(n)`

And therefore
```ruby
    expect(List(*1..100).length).to eq(100)
    expect(Nil.length).to eq(0)
```
### Context: PatternMatching

By the nature of a linked list we can deconstruct it _only_ into `car` and `cdr`

Given a list
```ruby
    let(:for_match) { List(:a, :b) }
```
Then we can pattern match as follows:
```ruby
    for_match => [h, t]
    expect(h).to eq(:a)
    expect(t.car).to eq(:b)
```

And for edge cases we have
```ruby
    List(1) => [_, t]
    expect(t).to eq(Nil)
```

And `Nil` only matches the empty list
```ruby
    Nil => []
```

### Context: `Enumerable`

> :warning: using the `Enumerable` mixin means `O(n)`

But if you can afford it ;)

Given a list like
```ruby
   let(:letters) { %w[alpha beta gamma delta epsilon sita] }
   let(:a_list) { List(*letters) }
```

Then we can happily use the `Enumerable` mixin
```ruby
    expect(a_list.to_a).to eq(letters)
```

And a lazy version might be preferable
```ruby
    expect(a_list.lazy).to be_kind_of(Enumerator::Lazy) # same as YHS
```

<!--SPDX-License-Identifier: Apache-2.0-->
