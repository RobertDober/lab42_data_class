# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:34
  context "`DataClass` function" do
    # README.md:37
    let(:my_data_class) { DataClass(:name, email: nil) }
    let(:my_instance) { my_data_class.new(name: "robert") }
    it "we can access its fields (README.md:43)" do
      expect(my_instance.name).to eq("robert")
      expect(my_instance.email).to be_nil
    end
    it "we cannot access undefined fields (README.md:49)" do
      expect{ my_instance.undefined }.to raise_error(NoMethodError)
    end
    it "we need to provide values to fields without defaults (README.md:54)" do
      expect{ my_data_class.new(email: "some@mail.org") }
      .to raise_error(ArgumentError, "missing initializers for [:name]")
    end
    it "we can extract the values (README.md:59)" do
      expect(my_instance.to_h).to eq(name: "robert", email: nil)
    end
    # README.md:63
    context "Immutable → self" do
      it "`my_instance` is frozen: (README.md:66)" do
        expect(my_instance).to be_frozen
      end
      it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:70)" do
        expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
      end
    end
    # README.md:74
    context "Immutable → Cloning" do
      # README.md:77
      let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
      it "we have a new instance with the old instance unchanged (README.md:81)" do
        expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      it "the new instance is frozen again (README.md:86)" do
        expect(other_instance).to be_frozen
      end
    end
  end
  # README.md:90
  context "Defining behavior with blocks" do
    # README.md:93
    let :my_data_class do
    DataClass :value, prefix: "<", suffix: ">" do
    def show
    [prefix, value, suffix].join
    end
    end
    end
    let(:my_instance) { my_data_class.new(value: 42) }
    it "I have defined a method on my dataclass (README.md:105)" do
      expect(my_instance.show).to eq("<42>")
    end
  end
  # README.md:109
  context "Equality" do
    # README.md:112
    let(:data_class) { DataClass :a }
    let(:instance1) { data_class.new(a: 1) }
    let(:instance2) { data_class.new(a: 1) }
    it "they are equal in the sense of `==` and `eql?` (README.md:118)" do
      expect(instance1).to eq(instance2)
      expect(instance2).to eq(instance1)
      expect(instance1 == instance2).to be_truthy
      expect(instance2 == instance1).to be_truthy
    end
    it "not in the sense of `equal?`, of course (README.md:125)" do
      expect(instance1).not_to be_equal(instance2)
      expect(instance2).not_to be_equal(instance1)
    end
    # README.md:130
    context "Immutability of `dataclass` modified classes" do
      it "we still get frozen instances (README.md:133)" do
        expect(instance1).to be_frozen
      end
    end
  end
  # README.md:137
  context "Inheritance" do
    # README.md:145
    let :token do
    ->(*a, **k) do
    DataClass(*a, **(k.merge(text: "")))
    end
    end
    it "we have reused the `token` successfully (README.md:154)" do
      empty = token.()
      integer = token.(:value)
      boolean = token.(value: false)
      
      expect(empty.new.to_h).to eq(text: "")
      expect(integer.new(value: -1).to_h).to eq(text: "", value: -1)
      expect(boolean.new.value).to eq(false)
    end
    # README.md:164
    context "Mixing in a module can be used of course" do
      # README.md:167
      module Humanize
      def humanize
      "my value is #{value}"
      end
      end
      
      let(:class_level) { DataClass(value: 1).include(Humanize) }
      it "we can access the included method (README.md:178)" do
        expect(class_level.new.humanize).to eq("my value is 1")
      end
    end
  end
  # README.md:182
  context "Pattern Matching" do
    # README.md:187
    let(:numbers) { DataClass(:name, values: []) }
    let(:odds) { numbers.new(name: "odds", values: (1..4).map{ _1 + _1 + 1}) }
    let(:evens) { numbers.new(name: "evens", values: (1..4).map{ _1 + _1}) }
    it "we can match accordingly (README.md:194)" do
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
    it "in `in` expressions (README.md:209)" do
      evens => {values: [_, second, *]}
      expect(second).to eq(4)
    end
    # README.md:214
    context "In Case Statements" do
      # README.md:217
      let(:box) { DataClass content: nil }
      it "we can also use it in a case statement (README.md:222)" do
        value = case box.new
        when box
        42
        else
        0
        end
        expect(value).to eq(42)
      end
      it "all the associated methods (README.md:233)" do
        expect(box.new).to be_a(box)
        expect(box === box.new).to be_truthy
      end
    end
  end
  # README.md:238
  context "Behaving like a `Proc`" do
    # README.md:243
    let(:class1) { DataClass :value }
    let(:class2) { DataClass :value }
    # README.md:249
    let(:list) {[class1.new(value: 1), class2.new(value: 2), class1.new(value: 3)]}
    it "we can filter (README.md:254)" do
      expect(list.filter(&class2)).to eq([class2.new(value: 2)])
    end
  end
  # README.md:258
  context "Behaving like a `Hash`" do
    # README.md:264
    def extract_value(value:, **others)
    [value, others]
    end
    # README.md:270
    let(:my_class) { DataClass(value: 1, base: 2) }
    it "we can pass it as keyword arguments (README.md:275)" do
      expect(extract_value(**my_class.new)).to eq([1, base: 2])
    end
  end
end