# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:62
  DataClass = Lab42::DataClass
  # README.md:66
  context "Data Classes" do
    # README.md:71
    class SimpleDataClass
    extend DataClass
    attributes :a, :b
    end
    # README.md:79
    let(:simple_instance) { SimpleDataClass.new(a: 1, b: 2) }
    it "we access the fields (README.md:84)" do
      expect(simple_instance.a).to eq(1)
      expect(simple_instance.b).to eq(2)
    end
    it "we convert to a hash (README.md:90)" do
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
    it "we can derive new instances (README.md:95)" do
      new_instance = simple_instance.merge(b: 3)
      expect(new_instance.to_h).to eq(a: 1, b: 3)
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
  end
  # README.md:103
  context "`DataClass` function" do
    # README.md:112
    context "Just Attributes" do
      # README.md:118
      let(:my_data_class) { DataClass(:name, email: nil) }
      let(:my_instance) { my_data_class.new(name: "robert") }
      it "we can access its fields (README.md:124)" do
        expect(my_instance.name).to eq("robert")
        expect(my_instance[:email]).to be_nil
      end
      it "we cannot access undefined fields (README.md:130)" do
        expect{ my_instance.undefined }.to raise_error(NoMethodError)
      end
      it "this is even true for the `[]` syntax (README.md:135)" do
        expect{ my_instance[:undefined] }.to raise_error(KeyError)
      end
      it "we need to provide values to fields without defaults (README.md:140)" do
        expect{ my_data_class.new(email: "some@mail.org") }
        .to raise_error(ArgumentError, "missing initializers for [:name]")
      end
      it "we can extract the values (README.md:145)" do
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      # README.md:149
      context "Immutable → self" do
        it "`my_instance` is frozen: (README.md:152)" do
          expect(my_instance).to be_frozen
        end
        it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:156)" do
          expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
        end
      end
      # README.md:160
      context "Immutable → Cloning" do
        # README.md:163
        let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
        it "we have a new instance with the old instance unchanged (README.md:167)" do
          expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
          expect(my_instance.to_h).to eq(name: "robert", email: nil)
        end
        it "the new instance is frozen again (README.md:172)" do
          expect(other_instance).to be_frozen
        end
      end
    end
  end
  # README.md:181
  context "`Pair` and `Triple`" do
    # README.md:191
    context "Constructor functions" do
      # README.md:194
      let(:token) { Pair("12", 12) }
      let(:node)  { Triple("42", 4, 2) }
      it "we can access their elements (README.md:200)" do
        expect(token.first).to eq("12")
        expect(token.second).to eq(12)
        expect(node.first).to eq("42")
        expect(node.second).to eq(4)
        expect(node.third).to eq(2)
      end
      it "we can treat them like _Indexable_ (README.md:209)" do
        expect(token[1]).to eq(12)
        expect(token[-2]).to eq("12")
        expect(node[2]).to eq(2)
      end
      it "convert them to arrays of course (README.md:216)" do
        expect(token.to_a).to eq(["12", 12])
        expect(node.to_a).to eq(["42", 4, 2])
      end
      it "they behave like arrays in pattern matching too (README.md:222)" do
        token => [str, int]
        node  => [root, lft, rgt]
        expect(str).to eq("12")
        expect(int).to eq(12)
        expect(root).to eq("42")
        expect(lft).to eq(4)
        expect(rgt).to eq(2)
      end
      it "of course the factory functions are equivalent to the constructors (README.md:233)" do
        expect(token).to eq(Lab42::Pair.new("12", 12))
        expect(node).to eq(Lab42::Triple.new("42", 4, 2))
      end
    end
  end
  # README.md:238
  context "`List`" do
    # README.md:243
    let(:three) { List(*%w[a b c]) }
    it "this becomes really a _linked_list_ (README.md:248)" do
      expect(three.car).to eq("a")
      expect(three.cdr).to eq(List(*%w[b c]))
    end
  end
end