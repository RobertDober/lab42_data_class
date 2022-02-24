# frozen_string_literal: true

RSpec.describe Lab42::DataClass do
  subject { DataClass(value: "a") }

  context "Convinience Constraints and Default Checks" do
    def self.constraint_ok((constraint_type, constraint))
      it "works with #{constraint_type}" do
        expect(subject.with_constraint(value: constraint).new).to be_kind_of(subject)
      end
    end

    [
      ["Symbols", :length],
      ["Arrays", [:length]],
      ["Regexen", /./],
      ["Sets", Set.new(%w[a])],
      ["Instance Methods", String.instance_method(:length)]
    ].each(&method(:constraint_ok))
  end
end
#  SPDX-License-Identifier: Apache-2.0
