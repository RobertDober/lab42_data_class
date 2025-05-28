# frozen_string_literal: true

RSpec.describe "updating" do

  describe "update a value" do
    let(:my_class) { DataClass(a: 1) }

    let(:instance1) { my_class.new }
    let!(:instance2) { instance1.update(:a){ nil } }
    let!(:instance3) { instance1.update(:a){ it.succ } }

    it "when updated it is still an immutable instance iof my_class" do
      expect(instance1).to be_a(my_class)
      expect(instance1.a).to eq(1)
    end

    it "the update has generated new values" do
      expect(instance2).to be_a(my_class)
      expect(instance2.a).to be_nil
    end

    it "can use the old value when updating" do
      expect(instance3).to be_a(my_class)
      expect(instance3.a).to eq(2)
    end
  end

  describe "can return an instance with access to all values" do
    let :my_class do
      DataClass(a: 1, b: 2) do
        def sum = a + b
      end
    end
    let(:instance1) { my_class.new }
    let! :instance2 do
      instance1.update do
        {a: it.b, b: it.sum }
      end
    end

    it "when updated it is still an immutable instance of my_class" do
      expect(instance1).to be_a(my_class)
      expect(instance1.to_h).to eq(a: 1, b: 2)
    end

    it "constructs a new instance from the returned hash" do
      expect(instance2).to eq(my_class.new(a: 2, b: 3))
    end

  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
