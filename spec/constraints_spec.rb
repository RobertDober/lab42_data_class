# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  describe "some constraint errors, not covered by the speculations" do
    let(:klass) { DataClass(a: 1).with_constraint(a: -> {_1 > 0}) }

    it "checks runtime errors" do
      expect{ klass.new(a: nil) }
        .to raise_error(described_class::ConstraintError, /constraint error during validation of attribute :a/)
    end

    it "checks for default values" do
      expect do
        DataClass(a: -1).with_constraint(a: -> {_1 > 0})
      end
        .to raise_error(described_class::ConstraintError, "default value -1 is not allowed for attribute :a")
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
