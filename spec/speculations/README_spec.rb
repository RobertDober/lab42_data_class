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
  # README.md:108
  context "Making a dataclass from a class" do
    # README.md:111
    class DC
    dataclass x: 1, y: 41
    def sum; x + y end
    end
    it "we can define methods on it (README.md:119)" do
      expect(DC.new.sum).to eq(42)
    end
    it "we have a nice name for our instances (README.md:124)" do
      expect(DC.new.class.name).to eq("DC")
    end
  end
  # README.md:128
  context "Equality" do
    # README.md:131
    let(:data_class) { DataClass :a }
    let(:instance1) { data_class.new(a: 1) }
    let(:instance2) { data_class.new(a: 1) }
    it "they are equal in the sense of `==` and `eql?` (README.md:137)" do
      expect(instance1).to eq(instance2)
      expect(instance2).to eq(instance1)
      expect(instance1 == instance2).to be_truthy
      expect(instance2 == instance1).to be_truthy
    end
    it "not in the sense of `equal?`, of course (README.md:144)" do
      expect(instance1).not_to be_equal(instance2)
      expect(instance2).not_to be_equal(instance1)
    end
    it "we still get frozen instances (README.md:152)" do
      expect(instance1).to be_frozen
    end
  end
end