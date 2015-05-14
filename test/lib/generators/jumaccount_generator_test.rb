require 'test_helper'
require 'generators/jumaccount/jumaccount_generator'

class JumaccountGeneratorTest < Rails::Generators::TestCase
  tests JumaccountGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
