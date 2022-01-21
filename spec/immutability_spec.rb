# frozen_string_literal: true

class Immutable
  attr_writer :a

  dataclass :a

  def will_raise
    @a += 1
  end
end

RSpec.describe Lab42::DataClass do
  describe Immutable do
    subject { Immutable.new(a: 42) }
    it "cannot be modified" do
      expect{ subject.will_raise }.to raise_error(FrozenError)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
