# frozen_string_literal: true

class MyDataClass
  dataclass :name, value: 0

  def humanize
    "The #{name} has #{value} but that might double soon"
  end
end

RSpec.describe Lab42::DataClass do
  subject { MyDataClass.new(name: "robert") }
  let(:raoul) { subject.merge(name: "raoul", value: 42) }
  it "has been constructed" do
    expect(subject.humanize).to eq("The robert has 0 but that might double soon")
  end

  it "merges as well as the explicitly constructed" do
    expect(raoul.humanize).to eq("The raoul has 42 but that might double soon")
    expect(subject.to_h).to eq(name: "robert", value: 0)
  end
end
#  SPDX-License-Identifier: Apache-2.0
