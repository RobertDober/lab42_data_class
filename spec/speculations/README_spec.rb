# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:15
  context "`DataClass` function" do
    # README.md:18
    let(:my_data_class) { DataClass(:name, email: nil) }
    let(:my_instance) { my_data_class.new(name: "robert") }
    it "we can access its fields (README.md:24)" do
      expect(my_instance.name).to eq("robert")
      expect(my_instance.email).to be_nil
    end
    it "we cannot access undefined fields (README.md:30)" do
      expect{ my_instance.undefined }.to raise_error(NoMethodError)
    end
    it "we need to provide values to fields without defaults (README.md:35)" do
      expect{ my_data_class.new(email: "some@mail.org") }
      .to raise_error(ArgumentError, "missing initializers for [:name]")
    end
    it "we can extract the values (README.md:40)" do
      expect(my_instance.to_h).to eq(name: "robert", email: nil)
    end
    # README.md:44
    context "Immutable" do
      # README.md:47
      let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
      it "we have a new instance with the old instance unchanged (README.md:51)" do
        expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
    end
  end
  # README.md:56
  context "Defining behavior with blocks" do
    # README.md:59
    let :my_data_class do
    DataClass :value, prefix: "<", suffix: ">" do
    def show
    [prefix, value, suffix].join
    end
    end
    end
    let(:my_instance) { my_data_class.new(value: 42) }
    it "I have defined a method on my dataclass (README.md:71)" do
      expect(my_instance.show).to eq("<42>")
    end
  end
  # README.md:74
  context "Making a dataclass from a class" do
    # README.md:77
    class DC
    dataclass x: 1, y: 41
    def sum; x + y end
    end
    it "we can define methods on it (README.md:85)" do
      expect(DC.new.sum).to eq(42)
    end
    it "we have a nice name for our instances (README.md:90)" do
      expect(DC.new.class.name).to eq("DC")
    end
  end
end