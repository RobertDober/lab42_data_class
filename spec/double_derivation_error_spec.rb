# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  describe Lab42::DataClass::DuplicateDefinitionError do
    it "raises if we define the same derived attribute twice" do
      expect do
        DataClass().derive(:a){}.derive(:a){}
      end
        .to raise_error(described_class)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
