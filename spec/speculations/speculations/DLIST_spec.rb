# DO NOT EDIT!!!
# This file was generated from "speculations/DLIST.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate rake task
# YOU HAVE BEEN WARNED
RSpec.describe "speculations/DLIST.md" do
  # speculations/DLIST.md:1
  context "`DList`" do
    it "we can use the convenience function as much as the constructor (speculations/DLIST.md:4)" do
      expect(DList(1, 2)).to eq(Lab42::DList.new(1, 2))
    end
  end
end
