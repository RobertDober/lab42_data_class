# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  let(:undefined_attribute_error) { Lab42::DataClass::UndefinedAttributeError }
  context "undefined attribute in a constraint" do
    it "should give a readable error message" do
      expected_error_message =
        "constraints cannot be defined for undefined attributes [:not_a_member]"
      expect do
        Class.new do
          extend Lab42::DataClass
          constraint :not_a_member
        end
      end
        .to raise_error(undefined_attribute_error, expected_error_message)
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
