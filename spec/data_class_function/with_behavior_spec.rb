# frozen_string_literal: true
#
RSpec.describe Lab42::DataClass do
  describe "a data class with behavior" do
    subject do
      DataClass a: 0 do
        def inc
          merge(a: a.succ)
        end
      end.new
    end
    let(:almost) { subject.merge(a: 41) }

    it "can be constructed by default" do
      expect(subject.a).to be_zero
    end

    it "has behavior" do
      expect(subject.inc.to_h).to eq(a: 1)
    end

    it "can be constructed with an explicit value" do
      expect(almost.a).to eq(41)
    end

    it "inherits the behavior" do
      expect(almost.inc.to_h).to eq(a: 42)
    end

    it "does not change the subject" do
      almost
      expect(subject.a).to be_zero
    end
  end
end
#  SPDX-License-Identifier: Apache-2.0
