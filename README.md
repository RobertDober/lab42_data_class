
[![Gem Version](http://img.shields.io/gem/v/lab42_data_class.svg)](https://rubygems.org/gems/lab42_data_class)
[![CI](https://github.com/robertdober/lab42_data_class/workflows/CI/badge.svg)](https://github.com/robertdober/lab42_data_class/actions)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/lab42_data_class/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/lab42_data_class?branch=master)


# Lab42::DataClass


## So what does it do?

### Making a dataclass from a class

Given
```ruby
class LetterCounter
  dataclass :consonants, :vowels
end
let(:counter) {Letter.counter.new(consonants: 0, vowels: 0)}
```

Then
```ruby
  expect(counter.consonants).to be_zero
```


# LICENSE

Copyright 2022 Robert Dober robert.dober@gmail.com

Apache-2.0 [c.f LICENSE](LICENSE)
<!-- SPDX-License-Identifier: Apache-2.0-->