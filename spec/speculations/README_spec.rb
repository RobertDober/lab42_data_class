# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:41
  context "`DataClass`" do
    # README.md:44
    context "`DataClass` function" do
      # README.md:47
      let(:my_data_class) { DataClass(:name, email: nil) }
      let(:my_instance) { my_data_class.new(name: "robert") }
      it "we can access its fields (README.md:53)" do
        expect(my_instance.name).to eq("robert")
        expect(my_instance.email).to be_nil
      end
      it "we cannot access undefined fields (README.md:59)" do
        expect{ my_instance.undefined }.to raise_error(NoMethodError)
      end
      it "we need to provide values to fields without defaults (README.md:64)" do
        expect{ my_data_class.new(email: "some@mail.org") }
        .to raise_error(ArgumentError, "missing initializers for [:name]")
      end
      it "we can extract the values (README.md:69)" do
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      # README.md:73
      context "Immutable → self" do
        it "`my_instance` is frozen: (README.md:76)" do
          expect(my_instance).to be_frozen
        end
        it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:80)" do
          expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
        end
      end
      # README.md:84
      context "Immutable → Cloning" do
        # README.md:87
        let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
        it "we have a new instance with the old instance unchanged (README.md:91)" do
          expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
          expect(my_instance.to_h).to eq(name: "robert", email: nil)
        end
        it "the new instance is frozen again (README.md:96)" do
          expect(other_instance).to be_frozen
        end
      end
    end
    # README.md:100
    context "Defining behavior with blocks" do
      # README.md:103
      let :my_data_class do
      DataClass :value, prefix: "<", suffix: ">" do
      def show
      [prefix, value, suffix].join
      end
      end
      end
      let(:my_instance) { my_data_class.new(value: 42) }
      it "I have defined a method on my dataclass (README.md:115)" do
        expect(my_instance.show).to eq("<42>")
      end
    end
    # README.md:119
    context "Equality" do
      # README.md:122
      let(:data_class) { DataClass :a }
      let(:instance1) { data_class.new(a: 1) }
      let(:instance2) { data_class.new(a: 1) }
      it "they are equal in the sense of `==` and `eql?` (README.md:128)" do
        expect(instance1).to eq(instance2)
        expect(instance2).to eq(instance1)
        expect(instance1 == instance2).to be_truthy
        expect(instance2 == instance1).to be_truthy
      end
      it "not in the sense of `equal?`, of course (README.md:135)" do
        expect(instance1).not_to be_equal(instance2)
        expect(instance2).not_to be_equal(instance1)
      end
      # README.md:140
      context "Immutability of `dataclass` modified classes" do
        it "we still get frozen instances (README.md:143)" do
          expect(instance1).to be_frozen
        end
      end
    end
    # README.md:147
    context "Inheritance" do
      # README.md:155
      let :token do
      ->(*a, **k) do
      DataClass(*a, **(k.merge(text: "")))
      end
      end
      it "we have reused the `token` successfully (README.md:164)" do
        empty = token.()
        integer = token.(:value)
        boolean = token.(value: false)

        expect(empty.new.to_h).to eq(text: "")
        expect(integer.new(value: -1).to_h).to eq(text: "", value: -1)
        expect(boolean.new.value).to eq(false)
      end
      # README.md:174
      context "Mixing in a module can be used of course" do
        # README.md:177
        module Humanize
        def humanize
        "my value is #{value}"
        end
        end

        let(:class_level) { DataClass(value: 1).include(Humanize) }
        it "we can access the included method (README.md:188)" do
          expect(class_level.new.humanize).to eq("my value is 1")
        end
      end
    end
    # README.md:192
    context "Pattern Matching" do
      # README.md:197
      let(:numbers) { DataClass(:name, values: []) }
      let(:odds) { numbers.new(name: "odds", values: (1..4).map{ _1 + _1 + 1}) }
      let(:evens) { numbers.new(name: "evens", values: (1..4).map{ _1 + _1}) }
      it "we can match accordingly (README.md:204)" do
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
      it "in `in` expressions (README.md:219)" do
        evens => {values: [_, second, *]}
        expect(second).to eq(4)
      end
      # README.md:224
      context "In Case Statements" do
        # README.md:227
        let(:box) { DataClass content: nil }
        it "we can also use it in a case statement (README.md:232)" do
          value = case box.new
          when box
          42
          else
          0
          end
          expect(value).to eq(42)
        end
        it "all the associated methods (README.md:243)" do
          expect(box.new).to be_a(box)
          expect(box === box.new).to be_truthy
        end
      end
    end
    # README.md:248
    context "Behaving like a `Proc`" do
      # README.md:253
      let(:class1) { DataClass :value }
      let(:class2) { DataClass :value }
      # README.md:259
      let(:list) {[class1.new(value: 1), class2.new(value: 2), class1.new(value: 3)]}
      it "we can filter (README.md:264)" do
        expect(list.filter(&class2)).to eq([class2.new(value: 2)])
      end
    end
    # README.md:268
    context "Behaving like a `Hash`" do
      # README.md:274
      def extract_value(value:, **others)
      [value, others]
      end
      # README.md:280
      let(:my_class) { DataClass(value: 1, base: 2) }
      it "we can pass it as keyword arguments (README.md:285)" do
        expect(extract_value(**my_class.new)).to eq([1, base: 2])
      end
    end
    # README.md:289
    context "Constraints" do
      # README.md:294
      let :switch do
      DataClass(on: false).with_constraint(on: -> { [false, true].member? _1 })
      end
      it "boolean values are acceptable (README.md:301)" do
        expect{ switch.new }.not_to raise_error
        expect(switch.new.merge(on: true).on).to eq(true)
      end
      it "we can neither construct or merge with non boolean values (README.md:307)" do
        expect{ switch.new(on: nil) }
        .to raise_error(Lab42::DataClass::ConstraintError, "value nil is not allowed for attribute :on")
        expect{ switch.new.merge(on: 42) }
        .to raise_error(Lab42::DataClass::ConstraintError, "value 42 is not allowed for attribute :on")
      end
      it "therefore defaultless attributes cannot have a constraint that is violated by a nil value (README.md:315)" do
        error_head = "constraint error during validation of default value of attribute :value"
        error_body = "  undefined method `>' for nil:NilClass"
        error_message = [error_head, error_body].join("\n")

        expect{ DataClass(value: nil).with_constraint(value: -> { _1 > 0 }) }
        .to raise_error(Lab42::DataClass::ConstraintError, /#{error_message}/)
      end
      it "defining constraints for undefined attributes is not the best of ideas (README.md:325)" do
        expect { DataClass(a: 1).with_constraint(b: -> {true}) }
        .to raise_error(ArgumentError, "constraints cannot be defined for undefined attributes [:b]")
      end
      # README.md:331
      context "Convenience Constraints" do
        # README.md:337
        let(:constraint_error) { Lab42::DataClass::ConstraintError }
        let(:positive) { DataClass(:value) }
        it "a first implementation of `Positive` (README.md:347)" do
          positive_by_symbol = positive.with_constraint(value: :positive?)

          expect(positive_by_symbol.new(value: 1).value).to eq(1)
          expect{positive_by_symbol.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can implement a different form of `Positive` (README.md:358)" do
          positive_by_ary = positive.with_constraint(value: [:>, 0])

          expect(positive_by_ary.new(value: 1).value).to eq(1)
          expect{positive_by_ary.new(value: 0)}.to raise_error(constraint_error)
        end
        it "this works with a `Set` (README.md:370)" do
          positive_by_set = positive.with_constraint(value: Set.new([*1..10]))

          expect(positive_by_set.new(value: 1).value).to eq(1)
          expect{positive_by_set.new(value: 0)}.to raise_error(constraint_error)
        end
        it "also with a `Range` (README.md:378)" do
          positive_by_range = positive.with_constraint(value: 1..Float::INFINITY)

          expect(positive_by_range.new(value: 1).value).to eq(1)
          expect{positive_by_range.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can also have a regex based constraint (README.md:390)" do
          vowel = DataClass(:word).with_constraint(word: /[aeiou]/)

          expect(vowel.new(word: "alpha").word).to eq("alpha")
          expect{vowel.new(word: "krk")}.to raise_error(constraint_error)
        end
        it "we can also use instance methods to implement our `Positive` (README.md:401)" do
          positive_by_instance_method = positive.with_constraint(value: Fixnum.instance_method(:positive?))

          expect(positive_by_instance_method.new(value: 1).value).to eq(1)
          expect{positive_by_instance_method.new(value: 0)}.to raise_error(constraint_error)
        end
        it "we can use methods to implement it (README.md:409)" do
          positive_by_method = positive.with_constraint(value: 0.method(:<))

          expect(positive_by_method.new(value: 1).value).to eq(1)
          expect{positive_by_method.new(value: 0)}.to raise_error(constraint_error)
        end
      end
      # README.md:416
      context "Global Constraints aka __Validations__" do
        # README.md:422
        let(:point) { DataClass(:x, :y).validate{ |point| point.x > point.y } }
        let(:validation_error) { Lab42::DataClass::ValidationError }
        it "we will get a `ValidationError` if we construct a point left of the main diagonal (README.md:428)" do
          expect{ point.new(x: 0, y: 1) }
          .to raise_error(validation_error)
        end
        it "as validation might need more than the default values we will not execute them at compile time (README.md:434)" do
          expect{ DataClass(x: 0, y: 0).validate{ |inst| inst.x > inst.y } }
          .to_not raise_error
        end
        it "we can name validations to get better error messages (README.md:440)" do
          better_point = DataClass(:x, :y).validate(:too_left){ |point| point.x > point.y }
          ok_point     = better_point.new(x: 1, y: 0)
          expect{ ok_point.merge(y: 1) }
          .to raise_error(validation_error, "too_left")
        end
        it "remark how bad unnamed validation errors might be (README.md:448)" do
          error_message_rgx = %r{
          \#<Proc:0x[0-9a-f]+ \s .* spec/speculations/README_spec\.rb: \d+ > \z
          }x
          expect{ point.new(x: 0, y: 1) }
          .to raise_error(validation_error, error_message_rgx)
        end
      end
    end
    # README.md:456
    # context "Usage with `extend`" do
    #   # README.md:462
    #   let :my_class do
    #   Class.new do
    #   extend Lab42::DataClass
    #   attributes :age, member: false
    #   end
    #   end
    #   it "we can observe that instances of such a class (README.md:472)" do
    #     my_instance = my_class.new(age: 42)
    #     my_vip = my_instance.merge(member: true)

    #     expect(my_instance.to_h).to eq(age: 42, member: false)
    #     expect(my_vip.to_h).to eq(age: 42, member: true)
    #   end
    # end
  end
  # README.md:481
  context "`Pair` and `Triple`" do
    # README.md:491
    context "Constructor functions" do
      # README.md:494
      let(:token) { Pair("12", 12) }
      let(:node)  { Triple("42", 4, 2) }
      it "we can access their elements (README.md:500)" do
        expect(token.first).to eq("12")
        expect(token.second).to eq(12)
        expect(node.first).to eq("42")
        expect(node.second).to eq(4)
        expect(node.third).to eq(2)
      end
      it "we can treat them like _Indexable_ (README.md:509)" do
        expect(token[1]).to eq(12)
        expect(token[-2]).to eq("12")
        expect(node[2]).to eq(2)
      end
      it "convert them to arrays of course (README.md:516)" do
        expect(token.to_a).to eq(["12", 12])
        expect(node.to_a).to eq(["42", 4, 2])
      end
      it "they behave like arrays in pattern matching too (README.md:522)" do
        token => [str, int]
        node  => [root, lft, rgt]
        expect(str).to eq("12")
        expect(int).to eq(12)
        expect(root).to eq("42")
        expect(lft).to eq(4)
        expect(rgt).to eq(2)
      end
      it "of course the factory functions are equivalent to the constructors (README.md:533)" do
        expect(token).to eq(Lab42::Pair.new("12", 12))
        expect(node).to eq(Lab42::Triple.new("42", 4, 2))
      end
    end
  end
end
