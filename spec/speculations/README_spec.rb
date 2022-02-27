# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:63
  DataClass = Lab42::DataClass
  # README.md:67
  context "Data Classes" do
    # README.md:72
    class SimpleDataClass
    extend DataClass
    attributes :a, :b
    end
    # README.md:80
    let(:simple_instance) { SimpleDataClass.new(a: 1, b: 2) }
    it "we access the fields (README.md:85)" do
      expect(simple_instance.a).to eq(1)
      expect(simple_instance.b).to eq(2)
    end
    it "we convert to a hash (README.md:91)" do
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
    it "we can derive new instances (README.md:96)" do
      new_instance = simple_instance.merge(b: 3)
      expect(new_instance.to_h).to eq(a: 1, b: 3)
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
    # README.md:104
    context "`DataClass` function" do
      # README.md:107
      let(:my_data_class) { DataClass(:name, email: nil) }
      let(:my_instance) { my_data_class.new(name: "robert") }
      it "we can access its fields (README.md:113)" do
        expect(my_instance.name).to eq("robert")
        expect(my_instance.email).to be_nil
      end
      it "we cannot access undefined fields (README.md:119)" do
        expect{ my_instance.undefined }.to raise_error(NoMethodError)
      end
      it "we need to provide values to fields without defaults (README.md:124)" do
        expect{ my_data_class.new(email: "some@mail.org") }
        .to raise_error(ArgumentError, "missing initializers for [:name]")
      end
      it "we can extract the values (README.md:129)" do
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      # README.md:133
      context "Immutable → self" do
        it "`my_instance` is frozen: (README.md:136)" do
          expect(my_instance).to be_frozen
        end
        it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:140)" do
          expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
        end
      end
      # README.md:144
      context "Immutable → Cloning" do
        # README.md:147
        let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
        it "we have a new instance with the old instance unchanged (README.md:151)" do
          expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
          expect(my_instance.to_h).to eq(name: "robert", email: nil)
        end
        it "the new instance is frozen again (README.md:156)" do
          expect(other_instance).to be_frozen
        end
      end
    end
    # README.md:160
    context "Defining behavior with blocks" do
      # README.md:163
      let :my_data_class do
      DataClass :value, prefix: "<", suffix: ">" do
      def show
      [prefix, value, suffix].join
      end
      end
      end
      let(:my_instance) { my_data_class.new(value: 42) }
      it "I have defined a method on my dataclass (README.md:175)" do
        expect(my_instance.show).to eq("<42>")
      end
    end
    # README.md:179
    context "Equality" do
      # README.md:182
      let(:data_class) { DataClass :a }
      let(:instance1) { data_class.new(a: 1) }
      let(:instance2) { data_class.new(a: 1) }
      it "they are equal in the sense of `==` and `eql?` (README.md:188)" do
        expect(instance1).to eq(instance2)
        expect(instance2).to eq(instance1)
        expect(instance1 == instance2).to be_truthy
        expect(instance2 == instance1).to be_truthy
      end
      it "not in the sense of `equal?`, of course (README.md:195)" do
        expect(instance1).not_to be_equal(instance2)
        expect(instance2).not_to be_equal(instance1)
      end
      # README.md:200
      context "Immutability of `dataclass` modified classes" do
        it "we still get frozen instances (README.md:203)" do
          expect(instance1).to be_frozen
        end
      end
      # README.md:208
      context "Inheritance with `DataClass` factory" do
        # README.md:216
        let :token do
        ->(*a, **k) do
        DataClass(*a, **(k.merge(text: "")))
        end
        end
        it "we have reused the `token` successfully (README.md:225)" do
          empty = token.()
          integer = token.(:value)
          boolean = token.(value: false)

          expect(empty.new.to_h).to eq(text: "")
          expect(integer.new(value: -1).to_h).to eq(text: "", value: -1)
          expect(boolean.new.value).to eq(false)
        end
      end
      # README.md:235
      context "Mixing in a module can be used of course" do
        # README.md:238
        module Humanize
        def humanize
        "my value is #{value}"
        end
        end

        let(:class_level) { DataClass(value: 1).include(Humanize) }
        it "we can access the included method (README.md:249)" do
          expect(class_level.new.humanize).to eq("my value is 1")
        end
      end
    end
    # README.md:253
    context "Pattern Matching" do
      # README.md:258
      let(:numbers) { DataClass(:name, values: []) }
      let(:odds) { numbers.new(name: "odds", values: (1..4).map{ _1 + _1 + 1}) }
      let(:evens) { numbers.new(name: "evens", values: (1..4).map{ _1 + _1}) }
      it "we can match accordingly (README.md:265)" do
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
      it "in `in` expressions (README.md:280)" do
        evens => {values: [_, second, *]}
        expect(second).to eq(4)
      end
      # README.md:285
      context "In Case Statements" do
        # README.md:288
        let(:box) { DataClass content: nil }
        it "we can also use it in a case statement (README.md:293)" do
          value = case box.new
          when box
          42
          else
          0
          end
          expect(value).to eq(42)
        end
        it "all the associated methods (README.md:304)" do
          expect(box.new).to be_a(box)
          expect(box === box.new).to be_truthy
        end
      end
    end
    # README.md:309
    context "Behaving like a `Proc`" do
      # README.md:314
      let(:class1) { DataClass :value }
      let(:class2) { DataClass :value }
      # README.md:320
      let(:list) {[class1.new(value: 1), class2.new(value: 2), class1.new(value: 3)]}
      it "we can filter (README.md:325)" do
        expect(list.filter(&class2)).to eq([class2.new(value: 2)])
      end
    end
    # README.md:329
    context "Behaving like a `Hash`" do
      # README.md:335
      def extract_value(value:, **others)
      [value, others]
      end
      # README.md:341
      let(:my_class) { DataClass(value: 1, base: 2) }
      it "we can pass it as keyword arguments (README.md:346)" do
        expect(extract_value(**my_class.new)).to eq([1, base: 2])
      end
    end
    # README.md:350
    context "Constraints" do
      # README.md:355
      let :switch do
      DataClass(on: false).with_constraint(on: -> { [false, true].member? _1 })
      end
      it "boolean values are acceptable (README.md:362)" do
        expect{ switch.new }.not_to raise_error
        expect(switch.new.merge(on: true).on).to eq(true)
      end
      it "we can neither construct or merge with non boolean values (README.md:368)" do
        expect{ switch.new(on: nil) }
        .to raise_error(Lab42::DataClass::ConstraintError, "value nil is not allowed for attribute :on")
        expect{ switch.new.merge(on: 42) }
        .to raise_error(Lab42::DataClass::ConstraintError, "value 42 is not allowed for attribute :on")
      end
      it "therefore defaultless attributes cannot have a constraint that is violated by a nil value (README.md:376)" do
        error_head = "constraint error during validation of default value of attribute :value"
        error_body = "  undefined method `>' for nil:NilClass"
        error_message = [error_head, error_body].join("\n")

        expect{ DataClass(value: nil).with_constraint(value: -> { _1 > 0 }) }
        .to raise_error(Lab42::DataClass::ConstraintError, /#{error_message}/)
      end
      it "defining constraints for undefined attributes is not the best of ideas (README.md:386)" do
        expect { DataClass(a: 1).with_constraint(b: -> {true}) }
        .to raise_error(ArgumentError, "constraints cannot be defined for undefined attributes [:b]")
      end
      # README.md:392
      context "Convenience Constraints" do
        # README.md:398
        let(:constraint_error) { Lab42::DataClass::ConstraintError }
        let(:positive) { DataClass(:value) }
        it "a first implementation of `Positive` (README.md:408)" do
          positive_by_symbol = positive.with_constraint(value: :positive?)

          expect(positive_by_symbol.new(value: 1).value).to eq(1)
          expect{positive_by_symbol.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can implement a different form of `Positive` (README.md:419)" do
          positive_by_ary = positive.with_constraint(value: [:>, 0])

          expect(positive_by_ary.new(value: 1).value).to eq(1)
          expect{positive_by_ary.new(value: 0)}.to raise_error(constraint_error)
        end
        it "this works with a `Set` (README.md:431)" do
          positive_by_set = positive.with_constraint(value: Set.new([*1..10]))

          expect(positive_by_set.new(value: 1).value).to eq(1)
          expect{positive_by_set.new(value: 0)}.to raise_error(constraint_error)
        end
        it "also with a `Range` (README.md:439)" do
          positive_by_range = positive.with_constraint(value: 1..Float::INFINITY)

          expect(positive_by_range.new(value: 1).value).to eq(1)
          expect{positive_by_range.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can also have a regex based constraint (README.md:451)" do
          vowel = DataClass(:word).with_constraint(word: /[aeiou]/)

          expect(vowel.new(word: "alpha").word).to eq("alpha")
          expect{vowel.new(word: "krk")}.to raise_error(constraint_error)
        end
        it "we can also use instance methods to implement our `Positive` (README.md:462)" do
          positive_by_instance_method = positive.with_constraint(value: Fixnum.instance_method(:positive?))

          expect(positive_by_instance_method.new(value: 1).value).to eq(1)
          expect{positive_by_instance_method.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can use methods to implement it (README.md:470)" do
          positive_by_method = positive.with_constraint(value: 0.method(:<))

          expect(positive_by_method.new(value: 1).value).to eq(1)
          expect{positive_by_method.new(value: 0)}.to raise_error(constraint_error)
        end
      end
      # README.md:477
      context "Global Constraints aka __Validations__" do
        # README.md:483
        let(:point) { DataClass(:x, :y).validate{ |point| point.x > point.y } }
        let(:validation_error) { Lab42::DataClass::ValidationError }
        it "we will get a `ValidationError` if we construct a point left of the main diagonal (README.md:489)" do
          expect{ point.new(x: 0, y: 1) }
          .to raise_error(validation_error)
        end
        it "as validation might need more than the default values we will not execute them at compile time (README.md:495)" do
          expect{ DataClass(x: 0, y: 0).validate{ |inst| inst.x > inst.y } }
          .to_not raise_error
        end
        it "we can name validations to get better error messages (README.md:501)" do
          better_point = DataClass(:x, :y).validate(:too_left){ |point| point.x > point.y }
          ok_point     = better_point.new(x: 1, y: 0)
          expect{ ok_point.merge(y: 1) }
          .to raise_error(validation_error, "too_left")
        end
        it "remark how bad unnamed validation errors might be (README.md:509)" do
          error_message_rgx = %r{
          \#<Proc:0x[0-9a-f]+ \s .* spec/speculations/README_spec\.rb: \d+ > \z
          }x
          expect{ point.new(x: 0, y: 1) }
          .to raise_error(validation_error, error_message_rgx)
        end
      end
    end
    # README.md:517
    context "Usage with `extend`" do
      # README.md:523
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
      it "we can observe that instances of such a class (README.md:539)" do
        expect(my_instance.to_h).to eq(age: 42, member: false)
        expect(my_vip.to_h).to eq(age: 42, member: true)
        expect(my_instance.member).to be_falsy
      end
      it "we will get constraint errors if applicable (README.md:546)" do
        expect{my_instance.merge(member: nil)}
        .to raise_error(constraint_error)
      end
      it "of course validations still work too (README.md:552)" do
        expect{ my_vip.merge(age: 17) }
        .to raise_error(validation_error, "too_young_for_member")
      end
    end
  end
  # README.md:558
  context "`Pair` and `Triple`" do
    # README.md:568
    context "Constructor functions" do
      # README.md:571
      let(:token) { Pair("12", 12) }
      let(:node)  { Triple("42", 4, 2) }
      it "we can access their elements (README.md:577)" do
        expect(token.first).to eq("12")
        expect(token.second).to eq(12)
        expect(node.first).to eq("42")
        expect(node.second).to eq(4)
        expect(node.third).to eq(2)
      end
      it "we can treat them like _Indexable_ (README.md:586)" do
        expect(token[1]).to eq(12)
        expect(token[-2]).to eq("12")
        expect(node[2]).to eq(2)
      end
      it "convert them to arrays of course (README.md:593)" do
        expect(token.to_a).to eq(["12", 12])
        expect(node.to_a).to eq(["42", 4, 2])
      end
      it "they behave like arrays in pattern matching too (README.md:599)" do
        token => [str, int]
        node  => [root, lft, rgt]
        expect(str).to eq("12")
        expect(int).to eq(12)
        expect(root).to eq("42")
        expect(lft).to eq(4)
        expect(rgt).to eq(2)
      end
      it "of course the factory functions are equivalent to the constructors (README.md:610)" do
        expect(token).to eq(Lab42::Pair.new("12", 12))
        expect(node).to eq(Lab42::Triple.new("42", 4, 2))
      end
    end
  end
end