# DO NOT EDIT!!!
# This file was generated from "speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md" do
  # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:4
  require "lab42/data_class/builtin_constraints"
  let(:constraint_error) { Lab42::DataClass::ConstraintError }
  # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:8
  context "`ListOf(constraint)`" do
    # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:12
    let(:evens) { DataClass(list: Nil, name: "myself").with_constraint(list: ListOf(:even?)) }
    let(:fours) { evens.new(list: List(*(1..3).map{ _1 * 4 })) }
    it "we can just add a new element to such a list (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:18)" do
      with_0 = fours.set(:list).cons(0)
      expect(with_0.list.car).to eq(0)
      expect(with_0.list.cadr).to eq(4)
      expect(with_0.list.caddr).to eq(8)
    end
    it "we can remove it (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:26)" do
      without_4 = fours.set(:list).cdr
      expect(without_4.list.car).to eq(8)
      expect(without_4.list.cadr).to eq(12)
      expect(without_4.list.cddr).to eq(Nil)
    end
    it "we cannot call the setter for a different attribute (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:34)" do
      expect do
      fours.set(:name)
      end
      .to raise_error(Lab42::DataClass::UndefinedSetterError)

    end
  end
  # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:42
  context "`PairOf(left_constraint, right_constraint)`" do
    # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:45
    let(:pairs) { DataClass(:entry).with_constraint(entry: PairOf(Symbol, Fixnum)) }
    let(:instance) { pairs.new(entry: Pair(:a, 1)) }
    it "we can just create a new instance with a new first element of the pair (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:51)" do
      expect(instance.set(:entry).first_element(:b).entry).to eq(Pair(:b, 1))
    end
    it "with the second (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:56)" do
      expect(instance.set(:entry).second_element(2).entry).to eq(Pair(:a, 2))
    end
    it "the constraints are still validated for the changing value (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:61)" do
      expect do
      instance.set(:entry).second_element(:b)
      end
      .to raise_error(constraint_error)
    end
  end
  # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:68
  context "`TripleOf(first_constraint, second_constraint, third_constraint)`" do
    # speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:71
    let(:triple) { DataClass(:value).with_constraint(value: TripleOf(Symbol, Fixnum, String)) }
    let(:instance) { triple.new(value: Triple(:a, 1, "hello")) }
    it "we can just create a new instance with a new first element of the triple (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:77)" do
      expect(instance.set(:value).first_element(:b).value).to eq(Triple(:b, 1, "hello"))
    end
    it "with the second (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:82)" do
      expect(instance.set(:value).second_element(2).value).to eq(Triple(:a, 2, "hello"))
    end
    it "even the third (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:87)" do
      expect(instance.set(:value).third_element("world").value).to eq(Triple(:a, 1, "world"))
    end
    it "the constraints are still validated for the changing value (speculations/ATTRIBUTE_SETTING_CONSTRAINTS.md:92)" do
      expect do
      instance.set(:value).second_element(:b)
      end
      .to raise_error(constraint_error)
      expect do
      instance.set(:value).third_element(42)
      end
      .to raise_error(constraint_error)
    end
  end
end