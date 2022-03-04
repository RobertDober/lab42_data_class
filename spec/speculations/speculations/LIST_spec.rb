# DO NOT EDIT!!!
# This file was generated from "speculations/LIST.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/LIST.md" do
  # speculations/LIST.md:48
  context "API" do
    # speculations/LIST.md:53
    let(:list) { Lab42::List }
    let(:my_list) { list.cons(42, Nil) }
    # speculations/LIST.md:61
    let(:same_list) { List(42) }
    it "they are actually the same (speculations/LIST.md:66)" do
      expect(my_list).to eq(same_list)
    end
    it "the convenience constructor is actually nothing other than: (speculations/LIST.md:71)" do
      expect(List(1, 2)).to eq(list.new(1, 2))
    end
    it "remark also that the constructor can return `Nil` (speculations/LIST.md:76)" do
      expect(List()).to eq(Nil)
    end
    # speculations/LIST.md:80
    context "Length" do
      it "therefore (speculations/LIST.md:85)" do
        expect(List(*1..100).length).to eq(100)
        expect(Nil.length).to eq(0)
      end
    end
    # speculations/LIST.md:89
    context "PatternMatching" do
      # speculations/LIST.md:94
      let(:for_match) { List(:a, :b) }
      it "we can pattern match as follows: (speculations/LIST.md:98)" do
        for_match => [h, t]
        expect(h).to eq(:a)
        expect(t.car).to eq(:b)
      end
      it "for edge cases we have (speculations/LIST.md:105)" do
        List(1) => [_, t]
        expect(t).to eq(Nil)
      end
      it "`Nil` only matches the empty list (speculations/LIST.md:111)" do
        Nil => []
      end
    end
    # speculations/LIST.md:115
    context "`Enumerable`" do
      # speculations/LIST.md:122
      let(:letters) { %w[alpha beta gamma delta epsilon sita] }
      let(:a_list) { List(*letters) }
      it "we can happily use the `Enumerable` mixin (speculations/LIST.md:128)" do
        expect(a_list.to_a).to eq(letters)
      end
      it "a lazy version might be preferable (speculations/LIST.md:133)" do
        expect(a_list.lazy).to be_kind_of(Enumerator::Lazy) # same as YHS
      end
    end
  end
end