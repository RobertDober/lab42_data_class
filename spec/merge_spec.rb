# frozen_string_literal: true

RSpec.describe "merging" do
  let(:my_class) { DataClass(:a) }
  describe "still same class" do
    let(:instance1) { my_class.new(a: 1) }
    it "when merged" do
      expect(instance1.merge(a: 2)).to be_a(my_class)
    end
  end

  describe "can be compared" do
    let(:instance1) { my_class.new(a: 1) }
    let(:instance2) { my_class.new(a: 2) }
    it "when merged" do
      expect(instance1.merge(a: 2)).to eq(instance2)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
