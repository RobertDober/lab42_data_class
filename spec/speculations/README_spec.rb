# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:64
  DataClass = Lab42::DataClass
  # README.md:68
  context "Data Classes" do
    # README.md:73
    class SimpleDataClass
    extend DataClass
    attributes :a, :b
    end
    # README.md:81
    let(:simple_instance) { SimpleDataClass.new(a: 1, b: 2) }
    it "we access the fields (README.md:86)" do
      expect(simple_instance.a).to eq(1)
      expect(simple_instance.b).to eq(2)
    end
    it "we convert to a hash (README.md:92)" do
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
    it "we can derive new instances (README.md:97)" do
      new_instance = simple_instance.merge(b: 3)
      expect(new_instance.to_h).to eq(a: 1, b: 3)
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
  end
  # README.md:105
  context "`DataClass` function" do
    # README.md:114
    context "Just Attributes" do
      # README.md:120
      let(:my_data_class) { DataClass(:name, email: nil) }
      let(:my_instance) { my_data_class.new(name: "robert") }
      it "we can access its fields (README.md:126)" do
        expect(my_instance.name).to eq("robert")
        expect(my_instance[:email]).to be_nil
      end
      it "we cannot access undefined fields (README.md:132)" do
        expect{ my_instance.undefined }.to raise_error(NoMethodError)
      end
      it "this is even true for the `[]` syntax (README.md:137)" do
        expect{ my_instance[:undefined] }.to raise_error(KeyError)
      end
      it "we need to provide values to fields without defaults (README.md:142)" do
        expect{ my_data_class.new(email: "some@mail.org") }
        .to raise_error(ArgumentError, "missing initializers for [:name]")
      end
      it "we can extract the values (README.md:147)" do
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      # README.md:151
      context "Immutable → self" do
        it "`my_instance` is frozen: (README.md:154)" do
          expect(my_instance).to be_frozen
        end
        it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:158)" do
          expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
        end
      end
      # README.md:162
      context "Immutable → Cloning" do
        # README.md:165
        let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
        it "we have a new instance with the old instance unchanged (README.md:169)" do
          expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
          expect(my_instance.to_h).to eq(name: "robert", email: nil)
        end
        it "the new instance is frozen again (README.md:174)" do
          expect(other_instance).to be_frozen
        end
      end
    end
  end
  # README.md:183
  context "`Pair` and `Triple`" do
    # README.md:193
    context "Constructor functions" do
      # README.md:196
      let(:token) { Pair("12", 12) }
      let(:node)  { Triple("42", 4, 2) }
      it "we can access their elements (README.md:202)" do
        expect(token.first).to eq("12")
        expect(token.second).to eq(12)
        expect(node.first).to eq("42")
        expect(node.second).to eq(4)
        expect(node.third).to eq(2)
      end
      it "we can treat them like _Indexable_ (README.md:211)" do
        expect(token[1]).to eq(12)
        expect(token[-2]).to eq("12")
        expect(node[2]).to eq(2)
      end
      it "convert them to arrays of course (README.md:218)" do
        expect(token.to_a).to eq(["12", 12])
        expect(node.to_a).to eq(["42", 4, 2])
      end
      it "they behave like arrays in pattern matching too (README.md:224)" do
        token => [str, int]
        node  => [root, lft, rgt]
        expect(str).to eq("12")
        expect(int).to eq(12)
        expect(root).to eq("42")
        expect(lft).to eq(4)
        expect(rgt).to eq(2)
      end
      it "of course the factory functions are equivalent to the constructors (README.md:235)" do
        expect(token).to eq(Lab42::Pair.new("12", 12))
        expect(node).to eq(Lab42::Triple.new("42", 4, 2))
      end
    end
  end
end