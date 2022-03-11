# v0.9.0 2022-03-11

- Double Linked List `DList` and associatted Attribute Setting Constraint
`DListOf` https://github.com/RobertDober/lab42_data_class/issues/37

# v0.8.3 2022-03-09

- Convenience attribute setter for `ListOf` attributes: `set_car` https://github.com/RobertDober/lab42_data_class/issues/34

- And chainable setters with `.with_attribute(name){ | setter | setter.update(1).push(2).shift }` e.g.

# v0.8.3 2022-03-08

- Fix cons on Nil error https://github.com/RobertDober/lab42_data_class/issues/32

# v0.8.2 2022-03-08

- Hotfix for missing `to_proc` in `Constraint`

# v0.8.1 2022-03-08

- Fix for unfrozen attributes, now `DataClass` instances are deeply immutable

# v0.8.0 2022-03-06

- Implement `PairOf` and `TripleOf` constraint  https://github.com/RobertDober/lab42_data_class/issues/22

- Implement `ListOf` constraint  https://github.com/RobertDober/lab42_data_class/issues/21

- Implement `List` class https://github.com/RobertDober/lab42_data_class/issues/20

# v0.7.2 2022-03-03

- Fixed warning on redefinition of derive method https://github.com/RobertDober/lab42_data_class/issues/17

- Fixed unnecessary constraint checks after merge https://github.com/RobertDober/lab42_data_class/issues/19

- Implemented Custom Constraints https://github.com/RobertDober/lab42_data_class/issues/18

# v0.7.1 2022-02-28

- Fixed bug for constraint on attribute defined in parent https://github.com/RobertDober/lab42_data_class/issues/14

- Documentation for already implemented issue error on multiple derived attributes 
  https://github.com/RobertDober/lab42_data_class/issues/12

# v0.7.0 2022-02-27

- Inheritance

- Derived Attributes

- Much better documentation/speculations

# v0.6.0 2022-02-24

- Implement `extend DataClass` in classes

# v0.5.1 2022-02-24

- Convenience Constraints fixed for default values https://github.com/RobertDober/lab42_data_class/issues/9

# v0.5.0 2022-02-23

- Constraints https://github.com/RobertDober/lab42_data_class/issues/7

- Validations https://github.com/RobertDober/lab42_data_class/issues/7

- Dissallow spurious initialiasing params https://github.com/RobertDober/lab42_data_class/issues/6

# v0.4.1 2022-02-22

- #merge did not return correct class for returned object https://github.com/RobertDober/lab42_data_class/issues/4
<!--SPDX-License-Identifier: Apache-2.0-->
