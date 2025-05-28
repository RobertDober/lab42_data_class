# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
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
    it "we can also update values with a block (README.md:102)" do
      new_instance = simple_instance.update(:b) { it.succ }
      expect(new_instance.to_h).to eq(a: 1, b: 3)
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
    it "if we want to create a new instance with values from the old we can use the parameterless form (README.md:109)" do
      new_instance = simple_instance.update do
      { a: it.a.succ, b: it.b.pred }
      end
      expect(new_instance.to_h).to eq(a: 2, b: 1)
      expect(simple_instance.to_h).to eq(a: 1, b: 2)
    end
  end
  # README.md:118
  context "`DataClass` function" do
    # README.md:127
    context "Just Attributes" do
      # README.md:133
      let(:my_data_class) { DataClass(:name, email: nil) }
      let(:my_instance) { my_data_class.new(name: "robert") }
      it "we can access its fields (README.md:139)" do
        expect(my_instance.name).to eq("robert")
        expect(my_instance[:email]).to be_nil
      end
      it "we cannot access undefined fields (README.md:145)" do
        expect{ my_instance.undefined }.to raise_error(NoMethodError)
      end
      it "this is even true for the `[]` syntax (README.md:150)" do
        expect{ my_instance[:undefined] }.to raise_error(KeyError)
      end
      it "we need to provide values to fields without defaults (README.md:155)" do
        expect{ my_data_class.new(email: "some@mail.org") }
        .to raise_error(ArgumentError, "missing initializers for [:name]")
      end
      it "we can extract the values (README.md:160)" do
        expect(my_instance.to_h).to eq(name: "robert", email: nil)
      end
      # README.md:164
      context "Immutable → self" do
        it "`my_instance` is frozen: (README.md:167)" do
          expect(my_instance).to be_frozen
        end
        it "we cannot even mute `my_instance`  by means of metaprogramming (README.md:171)" do
          expect{ my_instance.instance_variable_set("@x", nil) }.to raise_error(FrozenError)
        end
      end
      # README.md:175
      context "Immutable → Cloning" do
        # README.md:178
        let(:other_instance) { my_instance.merge(email: "robert@mail.provider") }
        it "we have a new instance with the old instance unchanged (README.md:182)" do
          expect(other_instance.to_h).to eq(name: "robert", email: "robert@mail.provider")
          expect(my_instance.to_h).to eq(name: "robert", email: nil)
        end
        it "the new instance is frozen again (README.md:187)" do
          expect(other_instance).to be_frozen
        end
      end
    end
  end
  # README.md:196
  context "`Pair` and `Triple`" do
    # README.md:206
    context "Constructor functions" do
      # README.md:209
      let(:token) { Pair("12", 12) }
      let(:node)  { Triple("42", 4, 2) }
      it "we can access their elements (README.md:215)" do
        expect(token.first).to eq("12")
        expect(token.second).to eq(12)
        expect(node.first).to eq("42")
        expect(node.second).to eq(4)
        expect(node.third).to eq(2)
      end
      it "we can treat them like _Indexable_ (README.md:224)" do
        expect(token[1]).to eq(12)
        expect(token[-2]).to eq("12")
        expect(node[2]).to eq(2)
      end
      it "convert them to arrays of course (README.md:231)" do
        expect(token.to_a).to eq(["12", 12])
        expect(node.to_a).to eq(["42", 4, 2])
      end
      it "they behave like arrays in pattern matching too (README.md:237)" do
        token => [str, int]
        node  => [root, lft, rgt]
        expect(str).to eq("12")
        expect(int).to eq(12)
        expect(root).to eq("42")
        expect(lft).to eq(4)
        expect(rgt).to eq(2)
      end
      it "of course the factory functions are equivalent to the constructors (README.md:248)" do
        expect(token).to eq(Lab42::Pair.new("12", 12))
        expect(node).to eq(Lab42::Triple.new("42", 4, 2))
      end
      # README.md:253
      context "Pseudo Assignments" do
        # README.md:258
        let(:original) { Pair(1, 1) }
        # README.md:263
        let(:xyz) { Triple(1, 1, 1) }
        it " (README.md:268)" do
          second = original.set_first(2)
          third  = second.set_second(2)
          expect(original).to eq( Pair(1, 1) )
          expect(second).to eq(Pair(2, 1))
          expect(third).to eq(Pair(2, 2))
        end
        it "also (README.md:277)" do
          second = xyz.set_first(2)
          third  = second.set_second(2)
          fourth = third.set_third(2)
          expect(xyz).to eq(Triple(1, 1, 1))
          expect(second).to eq(Triple(2, 1, 1))
          expect(third).to eq(Triple(2, 2, 1))
          expect(fourth).to eq(Triple(2, 2, 2))
        end
      end
    end
  end
  # README.md:287
  context "`List`" do
    # README.md:292
    let(:three) { List(*%w[a b c]) }
    it "this becomes really a _linked_list_ (README.md:297)" do
      expect(three.car).to eq("a")
      expect(three.cdr).to eq(List(*%w[b c]))
    end
  end
end