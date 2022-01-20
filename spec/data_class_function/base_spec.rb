# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  describe "a data class with only positional params" do
    subject { DataClass(:a, :b) }
    let(:correct_instance) { subject.new(a: 1, b: 2) }

    it "raises an argument error if a key is missing" do
      expect{ subject.new(a: 1) }.to raise_error(ArgumentError, "missing initializers for [:b]")
    end

    it "raises an argument error for spurious keys too" do
      expect{ subject.new(a: 1, b: 2, c: 3) }.to raise_error(ArgumentError, "illegal initializers [:c]")
    end

    it "but if all goes well" do
      expect(correct_instance.a).to eq(1)
      expect(correct_instance.b).to eq(2)
    end
  end

  describe "a data class with default values" do
    subject { DataClass(:a, b: 0, c: nil) }
    let(:correct_instance) { subject.new(a: 1) }

    it "raises an argument error if a key is missing" do
      expect{ subject.new(b: 1) }.to raise_error(ArgumentError, "missing initializers for [:a]")
    end

    it "but if all goes well" do
      expect(correct_instance.a).to eq(1)
      expect(correct_instance.b).to be_zero
      expect(correct_instance.c).to be_nil
    end

    it "can extract values into a hash" do
      expect(correct_instance.to_h).to eq(a: 1, b: 0, c: nil)
    end
  end

  describe "Immutability" do
    subject { DataClass(a: 1, b: 2).new }
    let(:modified) { subject.merge(b: 3) }
    it "creates a new object w/o changing the old one" do
      expect(modified.to_h).to eq(a: 1, b: 3)
      expect(subject.to_h).to eq(a: 1, b: 2)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
