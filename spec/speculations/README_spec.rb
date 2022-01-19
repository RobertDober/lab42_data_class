# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:15
  class LetterCounter
  dataclass :consonants, :vowels
  end
  let(:counter) {Letter.counter.new(consonants: 0, vowels: 0)}
  it " (README.md:23)" do
    expect(counter.consonants).to be_zero
  end
end