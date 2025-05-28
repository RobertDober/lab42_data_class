# DO NOT EDIT!!!
# This file was generated from "speculations/DATA_CLASSES.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/DATA_CLASSES.md" do
  # speculations/DATA_CLASSES.md:4
  let(:constraint_error) { Lab42::DataClass::ConstraintError }

  class Animal
  extend Lab42::DataClass
  attributes :name, :age, :species
  end
  # speculations/DATA_CLASSES.md:14
  let(:vilma) { Animal.new(name: "Vilma", species: "dog", age: 18) } # RIP my dear lab42
  # speculations/DATA_CLASSES.md:18
  context "Pattern Matching" do
    it "we can pattern match on it: (speculations/DATA_CLASSES.md:21)" do
      vilma => {name:, species:}
      expect(name).to eq("Vilma")
      expect(species).to eq("dog")
    end
  end
  # speculations/DATA_CLASSES.md:28
  context "Constraints" do
    # speculations/DATA_CLASSES.md:34
    class Dog < Animal
    extend Lab42::DataClass
    attributes :breed

    constraint :breed, Set.new(["Labrador", "Australian Shepherd"])
    constraint :species, [:==, "dog"] # This of course is a code smell, the base class needing to be constrained
    # but for the sake of the demonstration please bear with me (just do not do
    # this at home)
    end
    it "we can instantiate an object as long as we obey the constraints (speculations/DATA_CLASSES.md:47)" do
      Dog.new(age: 18, name: "Vilma", breed: "Labrador", species: "dog")
    end
    it "we will get `ConstraintError`s if we do not (speculations/DATA_CLASSES.md:52)" do
      expect do
      Dog.new(age: 18, name: "Vilma", breed: "Pug", species: "dog")
      end
      .to raise_error(constraint_error)
    end
    it " (speculations/DATA_CLASSES.md:60)" do
      expect do
      Dog.new(age: 18, name: "Vilma", breed: "Labrador", species: "human")
      end
      .to raise_error(constraint_error)
    end
    # speculations/DATA_CLASSES.md:67
    context "Builtin Constraints" do
      # speculations/DATA_CLASSES.md:99
      require "lab42/data_class/builtin_constraints"
      let(:entry) { DataClass(:value).with_constraint(value: PairOf(Symbol, Anything)) }
      it "these constraints are well observed (speculations/DATA_CLASSES.md:105)" do
        expect(entry.new(value: Pair(:world, 42)).value).to eq(Pair(:world, 42))
        expect{ entry.new(value: Pair("world", 43)) }
        .to raise_error(Lab42::DataClass::ConstraintError)
        expect{ entry.new(value: Triple(:world, 43, nil)) }
        .to raise_error(Lab42::DataClass::ConstraintError)
      end
    end
  end
  # speculations/DATA_CLASSES.md:138
  context "Defaults" do
    # speculations/DATA_CLASSES.md:143
    module WithAgeAndName
    extend Lab42::DataClass

    attributes :name, :age
    constraint :name, String
    constraint :age, [:>=, 0]
    end
    # speculations/DATA_CLASSES.md:154
    class BetterDog
    include WithAgeAndName
    extend Lab42::DataClass

    AllowedBreeds = [
    "Labrador", "Australian Shepherd"
    ]

    attributes breed: "Labrador"

    constraint :breed, Set.new(AllowedBreeds)
    end
    it "construction can use the defaults now (speculations/DATA_CLASSES.md:170)" do
      expect(BetterDog.new(age: 18, name: "Vilma").to_h)
      .to eq(name: "Vilma", age: 18, breed: "Labrador")
    end
    it "is object to the constraints of the included module (speculations/DATA_CLASSES.md:176)" do
      expect do
      BetterDog.new(age: 18, name: :Vilma)
      end
      .to raise_error(constraint_error, "value :Vilma is not allowed for attribute :name")
    end
    it "of the constraints of the base class too (speculations/DATA_CLASSES.md:184)" do
      expect do
      BetterDog.new(age: 18, name: "Vilma", breed: "Pug")
      end
      .to raise_error(constraint_error, %{value "Pug" is not allowed for attribute :breed})
    end
  end
  # speculations/DATA_CLASSES.md:191
  context "Derived Attributes" do
    # speculations/DATA_CLASSES.md:198
    module Token
    extend Lab42::DataClass

    attributes :line, :content, lnb: 0
    end
    # speculations/DATA_CLASSES.md:207
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
    it "we can observe how _defaults_ and _derivations_ provide us with the final object (speculations/DATA_CLASSES.md:223)" do
      expect(HeaderToken.new(line: "# Hello").to_h)
      .to eq(line: "# Hello", content: "Hello", lnb: 0, level: 1)
    end
  end
  # speculations/DATA_CLASSES.md:228
  context "Validation" do
    # speculations/DATA_CLASSES.md:237
    let(:validation_error) { Lab42::DataClass::ValidationError }
    class Person
    extend Lab42::DataClass

    attributes :name, :age, member: false

    validate :members_are_18 do
    _1.age >= 18 || !_1.member
    end
    end
    it "we can assure that all members are at least 18 years old (speculations/DATA_CLASSES.md:251)" do
      expect do
      Person.new(name: "junior", age: 17, member: true)
      end
      .to raise_error(validation_error)
    end
    it "of course validation is also carried out when new instances are derived (speculations/DATA_CLASSES.md:259)" do
      senior = Person.new(name: "senior", age: 42, member: true)
      expect do
      senior.merge(name: "offspring", age: 10)
      end
      .to raise_error(validation_error)
    end
    # speculations/DATA_CLASSES.md:267
    context "Validation, a code smell?" do
      # speculations/DATA_CLASSES.md:273
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
      it "it also works _better_ in the way that we cannot _merge_ an `Adult` into a `Child` (speculations/DATA_CLASSES.md:300)" do
        expect{ Adult.new(name: "senior", age: 18, member: true) }
        .not_to raise_error

        expect(Child.new(name: "junior", age: 17).to_h).to eq(name: "junior", age: 17, member: false)
      end
    end
  end
  # speculations/DATA_CLASSES.md:308
  context "Error Handling" do
    # speculations/DATA_CLASSES.md:313
    let(:duplicate_definition_error) { Lab42::DataClass::DuplicateDefinitionError }
    it "we must not define the same operation twice (speculations/DATA_CLASSES.md:319)" do
      expect do
      Class.new do
      extend Lab42::DataClass
      attributes(lhs: 0, rhs: 0)

      derive(:result) {_1.lhs + _1.rhs}
      derive(:result) {_1.lhs + _1.rhs}
      end
      end
      .to raise_error(duplicate_definition_error, "Redefinition of derived attribute :result")
    end
  end
end