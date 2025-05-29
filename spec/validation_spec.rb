# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  context "validation" do
    let :my_class do
      DataClass(:a, :b).validate { it.a < it.b }
    end
    it "legal" do
      my_class.new(a: 1, b: 2)
    end

    it "illegal" do
      message = __FILE__ 
      expect { my_class.new(a: 2, b: 2) }
        .to raise_error(Lab42::DataClass::ValidationError, Regexp.compile(Regexp.escape(message) + ':6'))
    end
  end

  context "validation takes place **after** initialisation" do
    let :my_class do
      DataClass(b: []) do
        attr_reader :c
        validate do
          it.b.first == it.c
        end
      end
    end

    it "can be constructed with a block that initialises c and modifies b" do
      instance = my_class.new do
        @c = 1
        @b << @c
      end
      expect(instance.to_h).to eq(b: [1])
      expect(instance.c).to eq(1)
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
