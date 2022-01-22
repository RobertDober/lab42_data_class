# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  describe "Immutable" do
    let :immutable do
      DataClass :a do
        def will_raise
          @a += 1
        end
      end
    end
    subject { immutable.new(a: 42) }
    it "cannot be modified" do
      expect{ subject.will_raise }.to raise_error(FrozenError)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
