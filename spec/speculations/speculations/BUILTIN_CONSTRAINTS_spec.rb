# DO NOT EDIT!!!
# This file was generated from "speculations/BUILTIN_CONSTRAINTS.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/BUILTIN_CONSTRAINTS.md" do
  # speculations/BUILTIN_CONSTRAINTS.md:2
  context "Builtin Constraints" do
    # speculations/BUILTIN_CONSTRAINTS.md:5
    require "lab42/data_class/builtin_constraints"

    let(:constraint_error) { Lab42::DataClass::ConstraintError }
    # speculations/BUILTIN_CONSTRAINTS.md:13
    context "`All?`" do
      # speculations/BUILTIN_CONSTRAINTS.md:18
      let(:listy) { DataClass(value: []).with_constraint(value: All?(:odd?)) }
      it "we are ok if we obey ;) (speculations/BUILTIN_CONSTRAINTS.md:22)" do
        expect(listy.new.merge(value: [1, 3]).value).to eq([1, 3])
      end
      it "beware of evens (speculations/BUILTIN_CONSTRAINTS.md:27)" do
        expect{ listy.new(value: [2]) }
        .to raise_error(constraint_error)
      end
    end
    # speculations/BUILTIN_CONSTRAINTS.md:32
    context "`Any?`" do
      # speculations/BUILTIN_CONSTRAINTS.md:39
      let(:hashy) { DataClass(:value).with_constraint(value: Any?{|(_,v)| v == 42}) }
      it "we need a value of 42, of course (speculations/BUILTIN_CONSTRAINTS.md:44)" do
        expect(hashy.new(value: {a: 42}).value[:a]).to eq(42)
      end
      it "if not, beware (speculations/BUILTIN_CONSTRAINTS.md:49)" do
        expect{ hashy.new(value: {a: 41, b: 43}) }
        .to raise_error(constraint_error)
      end
    end
    # speculations/BUILTIN_CONSTRAINTS.md:54
    context "`PairOf(fst, snd)`" do
      # speculations/BUILTIN_CONSTRAINTS.md:59
      let(:my_pair){ DataClass(:pair).with_constraint(pair: PairOf(Symbol, [:>, 0])) }
      it "let us comply with that (speculations/BUILTIN_CONSTRAINTS.md:64)" do
        expect(my_pair.new(pair: Pair(:alpha, 42)).pair.second).to eq(42)
      end
      it "there are multiple ways to violate this contract (speculations/BUILTIN_CONSTRAINTS.md:69)" do
        not_a_pair = Triple(:hello, 42, 42)
        not_a_sym = Pair("hello", 1)
        not_positive = Pair(:hello, 0)

        [not_a_pair, not_a_sym, not_positive].each do |culprit|
        expect{my_pair.new(pair: culprit)}
        .to raise_error(constraint_error)
        end
      end
    end
    # speculations/BUILTIN_CONSTRAINTS.md:80
    context "`TripleOf(fst, snd, trd)`" do
      # speculations/BUILTIN_CONSTRAINTS.md:85
      let(:my_triple) { DataClass(:triple).with_constraint(triple: TripleOf(String, String, String)) }
      it "strings it shall be (speculations/BUILTIN_CONSTRAINTS.md:90)" do
        expect{ my_triple.new(triple: Triple("a", "b", "c")) }.not_to raise_error
      end
      it "else (speculations/BUILTIN_CONSTRAINTS.md:95)" do
        [
        Triple("a", "b", 3),
        Triple("a", 2, "c"),
        Triple(1, "b", "c")
        ].each do |culprit|
        expect{my_triple.new(triple: culprit)}
        .to raise_error(constraint_error)
        end


      end
    end
    # speculations/BUILTIN_CONSTRAINTS.md:111
    context "NilOr(constraint)" do
    end
  end
end