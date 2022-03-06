RSpec.describe Lab42::DataClass::Constraints::Constraint do
  context "protects agains bad functions" do
    it "cannot be constructed with a bad arity (!=1)" do
      expect do
        described_class.new(name: "Bad", function: Set.method(:new))
      end
        .to raise_error(ArgumentError, /\Afunction not a callable with arity 1/)
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
