RSpec.describe Lab42::DataClass do
  require 'lab42/data_class/builtin_constraints'
  context "all frozen" do
    let :one do
      Class.new do
        extend Lab42::DataClass

        attributes :name, children: Nil
        constraint :children, ListOf(Numeric)
      end
    end
    let(:i1) { one.new(name: "") }
    let(:two) { DataClass(:id, atts: List()).with_constraint(atts: ListOf(String)) }
    let(:i2) { two.new(id: 2) }

    it "one's are frozen" do
      expect(i1.name).to be_frozen
      expect(i1.children).to be_frozen
    end

    it "two's are frozen" do
      expect(i2.id).to be_frozen
      expect(i2.atts).to be_frozen
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
