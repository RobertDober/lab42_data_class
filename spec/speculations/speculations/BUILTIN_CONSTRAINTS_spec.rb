# DO NOT EDIT!!!
# This file was generated from "speculations/BUILTIN_CONSTRAINTS.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/BUILTIN_CONSTRAINTS.md" do
  # speculations/BUILTIN_CONSTRAINTS.md:2
  context "Builtin Constraints" do
    # speculations/BUILTIN_CONSTRAINTS.md:6
    require "lab42/data_class/builtin_constraints"

    let(:constraint_error) { Lab42::DataClass::ConstraintError }
    it "surprisingly (speculations/BUILTIN_CONSTRAINTS.md:18)" do
      bad_constraint = DataClass(:value).with_constraint(value: NilOr{Set.new(%w[x y z])})
      expect{ bad_constraint.new(value: "a") }.not_to raise_error # BUT SHOULD
    end
    it "the following (useless complicated) works: (speculations/BUILTIN_CONSTRAINTS.md:24)" do
      complicated_constraint = DataClass(:value).with_constraint(value: NilOr{ Set.new(%w[x y z]).member? _1 })
      expect{ complicated_constraint.new(value: "a") }.to raise_error(constraint_error) # BUT SHOULD
    end
    # speculations/BUILTIN_CONSTRAINTS.md:262
    context "String Constraints" do
      # speculations/BUILTIN_CONSTRAINTS.md:265
      let(:starts) { StartsWith("<") }
      let(:ends)   { EndsWith(">") }
      let(:container) { Contains("div") }
      it "we can check (speculations/BUILTIN_CONSTRAINTS.md:272)" do
        expect(starts.("<hello")).to be_truthy
        expect(starts.("<")).to be_truthy
        expect(starts.(" ")).to be_falsy
        expect(starts.("")).to be_falsy
        expect(starts.(" <@")).to be_falsy
      end
      it "also (speculations/BUILTIN_CONSTRAINTS.md:281)" do
        expect(ends.(">")).to be_truthy
        expect(ends.("<hello>")).to be_truthy
        expect(ends.("")).to be_falsy
        expect(ends.("> ")).to be_falsy
      end
      it "eventually (speculations/BUILTIN_CONSTRAINTS.md:289)" do
        expect(container.("div")).to be_truthy
        expect(container.("some <div>")).to be_truthy
        expect(container.("some <dv>")).to be_falsy
        expect(container.("")).to be_falsy
      end
      # speculations/BUILTIN_CONSTRAINTS.md:31
      context "`All?(constraint)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:36
        let(:listy) { DataClass(value: []).with_constraint(value: All?(:odd?)) }
        it "we are ok if we obey ;) (speculations/BUILTIN_CONSTRAINTS.md:40)" do
          expect(listy.new.merge(value: [1, 3]).value).to eq([1, 3])
        end
        it "beware of evens (speculations/BUILTIN_CONSTRAINTS.md:45)" do
          expect{ listy.new(value: [2]) }
          .to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:50
      context "`Any?(constraint)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:57
        let(:hashy) { DataClass(:value).with_constraint(value: Any?{|(_,v)| v == 42}) }
        it "we need a value of 42, of course (speculations/BUILTIN_CONSTRAINTS.md:62)" do
          expect(hashy.new(value: {a: 42}).value[:a]).to eq(42)
        end
        it "if not, beware (speculations/BUILTIN_CONSTRAINTS.md:67)" do
          expect{ hashy.new(value: {a: 41, b: 43}) }
          .to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:72
      context "`ListOf(constraint)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:79
        let(:evens) { DataClass(list: Nil, name: "myself").with_constraint(list: ListOf(:even?)) }
        # speculations/BUILTIN_CONSTRAINTS.md:84
        let(:fours) { evens.new(list: List(*(1..3).map{ _1 * 4 })) }
        it "we can just add a new element to such a list (speculations/BUILTIN_CONSTRAINTS.md:89)" do
          with_0 = fours.set(:list).cons(0)
          expect(with_0.list.car).to eq(0)
          expect(with_0.list.cadr).to eq(4)
          expect(with_0.list.caddr).to eq(8)
        end
        it "we can remove it (speculations/BUILTIN_CONSTRAINTS.md:97)" do
          without_4 = fours.set(:list).cdr
          expect(without_4.list.car).to eq(8)
          expect(without_4.list.cadr).to eq(12)
          expect(without_4.list.cddr).to eq(Nil)
        end
        it "we cannot call the setter for a different attribute (speculations/BUILTIN_CONSTRAINTS.md:105)" do
          expect do
          fours.set(:name)
          end
          .to raise_error(Lab42::DataClass::UndefinedSetterError)
        end
        it "a list with an odd will just not do (speculations/BUILTIN_CONSTRAINTS.md:113)" do
          expect do
          evens.new(list: List(*0..2))
          end
          .to raise_error(constraint_error)
        end
        it "nor will an array (speculations/BUILTIN_CONSTRAINTS.md:122)" do
          expect do
          evens.new(list: [0, 2])
          end
          .to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:130
      context "`PairOf(fst, snd)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:135
        let(:my_pair){ DataClass(:pair).with_constraint(pair: PairOf(Symbol, [:>, 0])) }
        it "let us comply with that (speculations/BUILTIN_CONSTRAINTS.md:140)" do
          expect(my_pair.new(pair: Pair(:alpha, 42)).pair.second).to eq(42)
        end
        it "there are multiple ways to violate this contract (speculations/BUILTIN_CONSTRAINTS.md:145)" do
          not_a_pair = Triple(:hello, 42, 42)
          not_a_sym = Pair("hello", 1)
          not_positive = Pair(:hello, 0)

          [not_a_pair, not_a_sym, not_positive].each do |culprit|
          expect{my_pair.new(pair: culprit)}
          .to raise_error(constraint_error)
          end
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:158
      context "`TripleOf(fst, snd, trd)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:163
        let(:my_triple) { DataClass(:triple).with_constraint(triple: TripleOf(String, String, String)) }
        it "strings it shall be (speculations/BUILTIN_CONSTRAINTS.md:168)" do
          expect{ my_triple.new(triple: Triple("a", "b", "c")) }.not_to raise_error
        end
        it "else (speculations/BUILTIN_CONSTRAINTS.md:173)" do
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
      # speculations/BUILTIN_CONSTRAINTS.md:190
      context "NilOr(constraint)" do
        # speculations/BUILTIN_CONSTRAINTS.md:196
        let(:maybe) { DataClass(number: nil).with_constraint(number: NilOr(Fixnum)) }
        it "we get (speculations/BUILTIN_CONSTRAINTS.md:204)" do
          expect(maybe.new.number).to be_nil
          expect(maybe.new(number: 42).number).to eq(42)
          expect{ maybe.new(number: false) }.to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:210
      context "`Not(constraint)`" do
        it "therefore (speculations/BUILTIN_CONSTRAINTS.md:215)" do
          negator = DataClass(:consonant).with_constraint(consonant: Not(Set.new(%w[a e i o u])))
          expect(negator.new(consonant: "b").consonant).to eq("b")
          expect{ negator.new(consonant: "a") }.to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:220
      context "`Choice(*constraints)`" do
        # speculations/BUILTIN_CONSTRAINTS.md:223
        let(:key_constraint) { Choice(String, Symbol) }
        let(:entry) { DataClass(:value).with_constraint(value: PairOf(key_constraint, Anything)) }
        it "the following holds: (speculations/BUILTIN_CONSTRAINTS.md:229)" do
          entry.new(value: Pair("hello", "world"))
          entry.new(value: Pair(:hello, 42))
        end
        it "indeed: (speculations/BUILTIN_CONSTRAINTS.md:235)" do
          expect{ entry.new(value: Pair(42, "hello")) }.to raise_error(constraint_error)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:239
      context "`Lambda(arity)`" do
        it "we see that the following callables are compliant (speculations/BUILTIN_CONSTRAINTS.md:244)" do
          callable1 = Lambda(1)
          compliants = [
          -> { _1 },
          1.method(:+) ]
          non_compliants = [
          -> { nil },
          42,
          Set.method(:new) # arity -1
          ]
          compliants.each do |compliant|
          expect(callable1.(compliant)).to be_truthy
          end
          non_compliants.each do |culprit|
          expect(callable1.(culprit)).to be_falsy
          end
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:299
      context "`Anything`" do
        it "we see (speculations/BUILTIN_CONSTRAINTS.md:304)" do
          expect(Anything.(nil)).to eq(true)
          expect(Anything.(42)).to eq(true)
          expect(Anything.(BasicObject.new)).to eq(true)
          expect(Anything.(self)).to eq(true)
        end
      end
      # speculations/BUILTIN_CONSTRAINTS.md:311
      context "`Boolean`" do
        it "it is true for exactly two values (speculations/BUILTIN_CONSTRAINTS.md:316)" do
          expect(Boolean.(true)).to eq(true)
          expect(Boolean.(false)).to eq(true)
          expect(Boolean.(nil)).to eq(false)
          expect(Boolean.(42)).to eq(false)
          expect(Boolean.([])).to eq(false)
          expect(Boolean.([false])).to eq(false)

        end
      end
    end
  end
end