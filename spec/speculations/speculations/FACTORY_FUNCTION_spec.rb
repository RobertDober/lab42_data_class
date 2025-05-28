# DO NOT EDIT!!!
# This file was generated from "speculations/FACTORY_FUNCTION.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/FACTORY_FUNCTION.md" do
  # speculations/FACTORY_FUNCTION.md:1
  context "Defining behavior with blocks" do
    # speculations/FACTORY_FUNCTION.md:4
    let :my_data_class do
    DataClass :value, prefix: "<", suffix: ">" do
    def show
    [prefix, value, suffix].join
    end
    end
    end
    let(:my_instance) { my_data_class.new(value: 42) }
    it "I have defined a method on my dataclass (speculations/FACTORY_FUNCTION.md:16)" do
      expect(my_instance.show).to eq("<42>")
    end
  end
  # speculations/FACTORY_FUNCTION.md:20
  context "Equality" do
    # speculations/FACTORY_FUNCTION.md:23
    let(:data_class) { DataClass :a }
    let(:instance1) { data_class.new(a: 1) }
    let(:instance2) { data_class.new(a: 1) }
    it "they are equal in the sense of `==` and `eql?` (speculations/FACTORY_FUNCTION.md:29)" do
      expect(instance1).to eq(instance2)
      expect(instance2).to eq(instance1)
      expect(instance1 == instance2).to be_truthy
      expect(instance2 == instance1).to be_truthy
    end
    it "not in the sense of `equal?`, of course (speculations/FACTORY_FUNCTION.md:36)" do
      expect(instance1).not_to be_equal(instance2)
      expect(instance2).not_to be_equal(instance1)
    end
    # speculations/FACTORY_FUNCTION.md:41
    context "Immutability of `dataclass` modified classes" do
      it "we still get frozen instances (speculations/FACTORY_FUNCTION.md:44)" do
        expect(instance1).to be_frozen
      end
    end
    # speculations/FACTORY_FUNCTION.md:48
    context "Inheritance with `DataClass` factory" do
      # speculations/FACTORY_FUNCTION.md:56
      let :token do
      ->(*a, **k) do
      DataClass(*a, **(k.merge(text: "")))
      end
      end
      it "we have reused the `token` successfully (speculations/FACTORY_FUNCTION.md:65)" do
        empty = token.()
        integer = token.(:value)
        boolean = token.(value: false)

        expect(empty.new.to_h).to eq(text: "")
        expect(integer.new(value: -1).to_h).to eq(text: "", value: -1)
        expect(boolean.new.value).to eq(false)
      end
    end
    # speculations/FACTORY_FUNCTION.md:75
    context "Mixing in a module can be used of course" do
      # speculations/FACTORY_FUNCTION.md:78
      module Humanize
      def humanize
      "my value is #{value}"
      end
      end

      let(:class_level) { DataClass(value: 1).include(Humanize) }
      it "we can access the included method (speculations/FACTORY_FUNCTION.md:89)" do
        expect(class_level.new.humanize).to eq("my value is 1")
      end
    end
  end
  # speculations/FACTORY_FUNCTION.md:93
  context "Pattern Matching" do
    # speculations/FACTORY_FUNCTION.md:98
    let(:numbers) { DataClass(:name, values: []) }
    let(:odds) { numbers.new(name: "odds", values: (1..4).map{ _1 + _1 + 1}) }
    let(:evens) { numbers.new(name: "evens", values: (1..4).map{ _1 + _1}) }
    it "we can match accordingly (speculations/FACTORY_FUNCTION.md:105)" do
      match = case odds
      in {name: "odds", values: [1, *]}
      :not_really
      in {name: "evens"}
      :still_naaah
      in {name: "odds", values: [hd, *]}
      hd
      else
      :strange
      end
      expect(match).to eq(3)
    end
    it "in `in` expressions (speculations/FACTORY_FUNCTION.md:120)" do
      evens => {values: [_, second, *]}
      expect(second).to eq(4)
    end
    # speculations/FACTORY_FUNCTION.md:125
    context "In Case Statements" do
      # speculations/FACTORY_FUNCTION.md:128
      let(:box) { DataClass content: nil }
      it "we can also use it in a case statement (speculations/FACTORY_FUNCTION.md:133)" do
        value = case box.new
        when box
        42
        else
        0
        end
        expect(value).to eq(42)
      end
      it "all the associated methods (speculations/FACTORY_FUNCTION.md:144)" do
        expect(box.new).to be_a(box)
        expect(box === box.new).to be_truthy
      end
    end
  end
  # speculations/FACTORY_FUNCTION.md:149
  context "Behaving like a `Proc`" do
    # speculations/FACTORY_FUNCTION.md:154
    let(:class1) { DataClass :value }
    let(:class2) { DataClass :value }
    # speculations/FACTORY_FUNCTION.md:160
    let(:list) {[class1.new(value: 1), class2.new(value: 2), class1.new(value: 3)]}
    it "we can filter (speculations/FACTORY_FUNCTION.md:165)" do
      expect(list.filter(&class2)).to eq([class2.new(value: 2)])
    end
  end
  # speculations/FACTORY_FUNCTION.md:169
  context "Behaving like a `Hash`" do
    # speculations/FACTORY_FUNCTION.md:175
    def extract_value(value:, **others)
    [value, others]
    end
    # speculations/FACTORY_FUNCTION.md:181
    let(:my_class) { DataClass(value: 1, base: 2) }
    it "we can pass it as keyword arguments (speculations/FACTORY_FUNCTION.md:186)" do
      expect(extract_value(**my_class.new)).to eq([1, base: 2])
    end
  end
  # speculations/FACTORY_FUNCTION.md:190
  context "Constraints" do
    # speculations/FACTORY_FUNCTION.md:195
    let :switch do
    DataClass(on: false).with_constraint(on: -> { [false, true].member? _1 })
    end
    it "boolean values are acceptable (speculations/FACTORY_FUNCTION.md:202)" do
      expect{ switch.new }.not_to raise_error
      expect(switch.new.merge(on: true).on).to eq(true)
    end
    it "we can neither construct or merge with non boolean values (speculations/FACTORY_FUNCTION.md:208)" do
      expect{ switch.new(on: nil) }
      .to raise_error(Lab42::DataClass::ConstraintError, "value nil is not allowed for attribute :on")
      expect{ switch.new.merge(on: 42) }
      .to raise_error(Lab42::DataClass::ConstraintError, "value 42 is not allowed for attribute :on")
    end
    it "therefore defaultless attributes cannot have a constraint that is violated by a nil value (speculations/FACTORY_FUNCTION.md:216)" do
      error_head = "constraint error during validation of default value of attribute :value"
      error_body = "  undefined method `>' for nil:NilClass"
      error_message = "constraint error during validation of default value of attribute :value\n  undefined method '>' for nil"

      expect{ DataClass(value: nil).with_constraint(value: -> { _1 > 0 }) }
      .to raise_error(Lab42::DataClass::ConstraintError, /#{error_message}/)
    end
    it "defining constraints for undefined attributes is not the best of ideas (speculations/FACTORY_FUNCTION.md:226)" do
      expect { DataClass(a: 1).with_constraint(b: -> {true}) }
      .to raise_error(Lab42::DataClass::UndefinedAttributeError, "constraints cannot be defined for undefined attributes [:b]")
    end
    # speculations/FACTORY_FUNCTION.md:231
    context "Convenience Constraints" do
      # speculations/FACTORY_FUNCTION.md:237
      let(:constraint_error) { Lab42::DataClass::ConstraintError }
      let(:positive) { DataClass(:value) }
      it "a first implementation of `Positive` (speculations/FACTORY_FUNCTION.md:247)" do
        positive_by_symbol = positive.with_constraint(value: :positive?)

        expect(positive_by_symbol.new(value: 1).value).to eq(1)
        expect{positive_by_symbol.new(value: 0)}.to raise_error(constraint_error)
      end
      it "we can implement a different form of `Positive` (speculations/FACTORY_FUNCTION.md:258)" do
        positive_by_ary = positive.with_constraint(value: [:>, 0])

        expect(positive_by_ary.new(value: 1).value).to eq(1)
        expect{positive_by_ary.new(value: 0)}.to raise_error(constraint_error)
      end
      it "this works with a `Set` (speculations/FACTORY_FUNCTION.md:270)" do
        positive_by_set = positive.with_constraint(value: Set.new([*1..10]))

        expect(positive_by_set.new(value: 1).value).to eq(1)
        expect{positive_by_set.new(value: 0)}.to raise_error(constraint_error)
      end
      it "also with a `Range` (speculations/FACTORY_FUNCTION.md:278)" do
        positive_by_range = positive.with_constraint(value: 1..Float::INFINITY)

        expect(positive_by_range.new(value: 1).value).to eq(1)
        expect{positive_by_range.new(value: 0)}.to raise_error(constraint_error)
      end
      it "we can also have a regex based constraint (speculations/FACTORY_FUNCTION.md:290)" do
        vowel = DataClass(:word).with_constraint(word: /[aeiou]/)

        expect(vowel.new(word: "alpha").word).to eq("alpha")
        expect{vowel.new(word: "krk")}.to raise_error(constraint_error)
      end
      it "we can use the class as a constraint (speculations/FACTORY_FUNCTION.md:302)" do
        container = DataClass(:value).with_constraint(value: String)

        expect(container.new(value: "42")[:value]).to eq("42")
        expect{ container.new(value: 42) }.to raise_error(constraint_error, "value 42 is not allowed for attribute :value")
      end
      it "we can also use instance methods to implement our `Positive` (speculations/FACTORY_FUNCTION.md:313)" do
        positive_by_instance_method = positive.with_constraint(value: Integer.instance_method(:positive?))

        expect(positive_by_instance_method.new(value: 1).value).to eq(1)
        expect{positive_by_instance_method.new(value: 0)}.to raise_error(constraint_error)
      end
      it "we can use methods to implement it (speculations/FACTORY_FUNCTION.md:321)" do
        positive_by_method = positive.with_constraint(value: 0.method(:<))

        expect(positive_by_method.new(value: 1).value).to eq(1)
        expect{positive_by_method.new(value: 0)}.to raise_error(constraint_error)
      end
    end
    # speculations/FACTORY_FUNCTION.md:328
    context "Global Constraints aka __Validations__" do
      # speculations/FACTORY_FUNCTION.md:334
      let(:point) { DataClass(:x, :y).validate{ |point| point.x > point.y } }
      let(:validation_error) { Lab42::DataClass::ValidationError }
      it "we will get a `ValidationError` if we construct a point left of the main diagonal (speculations/FACTORY_FUNCTION.md:340)" do
        expect{ point.new(x: 0, y: 1) }
        .to raise_error(validation_error)
      end
      it "as validation might need more than the default values we will not execute them at compile time (speculations/FACTORY_FUNCTION.md:346)" do
        expect{ DataClass(x: 0, y: 0).validate{ |inst| inst.x > inst.y } }
        .to_not raise_error
      end
      it "we can name validations to get better error messages (speculations/FACTORY_FUNCTION.md:352)" do
        better_point = DataClass(:x, :y).validate(:too_left){ |point| point.x > point.y }
        ok_point     = better_point.new(x: 1, y: 0)
        expect{ ok_point.merge(y: 1) }
        .to raise_error(validation_error, "too_left")
      end
      it "remark how bad unnamed validation errors might be (speculations/FACTORY_FUNCTION.md:360)" do
        error_message_rgx = %r{
        \#<Proc:0x[0-9a-f]+ \s .* spec/speculations/speculations/FACTORY_FUNCTION_spec\.rb: \d+ > \z
        }x
        expect{ point.new(x: 0, y: 1) }
        .to raise_error(validation_error, error_message_rgx)
      end
    end
    # speculations/FACTORY_FUNCTION.md:368
    context "Derived Attributes" do
      # speculations/FACTORY_FUNCTION.md:373
      let(:pythagoras) { DataClass(:a, :b).derive(:c){ Math.sqrt(_1.a**2 + _1.b**2)} }
      it "the hypotenuse is derived (speculations/FACTORY_FUNCTION.md:378)" do
        expect(pythagoras.new(a: 3.0, b: 4.0)[:c]).to eq(5.0)
      end
    end
  end
  # speculations/FACTORY_FUNCTION.md:381
  context "Usage with `extend`" do
    # speculations/FACTORY_FUNCTION.md:387
    let :my_class do
    Class.new do
    extend Lab42::DataClass
    attributes :age, member: false
    constraint :member, Set.new([false, true])
    validate(:too_young_for_member) { |instance| !(instance.member && instance.age < 18) }
    end
    end
    let(:constraint_error) { Lab42::DataClass::ConstraintError }
    let(:validation_error) { Lab42::DataClass::ValidationError }
    let(:my_instance) { my_class.new(age: 42) }
    let(:my_vip)      { my_instance.merge(member: true) }
    it "we can observe that instances of such a class (speculations/FACTORY_FUNCTION.md:403)" do
      expect(my_instance.to_h).to eq(age: 42, member: false)
      expect(my_vip.to_h).to eq(age: 42, member: true)
      expect(my_instance.member).to be_falsy
    end
    it "we will get constraint errors if applicable (speculations/FACTORY_FUNCTION.md:410)" do
      expect{my_instance.merge(member: nil)}
      .to raise_error(constraint_error)
    end
    it "of course validations still work too (speculations/FACTORY_FUNCTION.md:416)" do
      expect{ my_vip.merge(age: 17) }
      .to raise_error(validation_error, "too_young_for_member")
    end
  end
end
