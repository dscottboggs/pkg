require "spec"
require "../src/pkg"

struct ExistenceExpectation
  def match(actual_value : String)
    File.exists? actual_value
  end
  def failure_message(actual_value : String)
    "Expected file #{actual_value} to exist."
  end
  def negative_failure_message(actual_value : String)
    "Expected file #{actual_value} to not exist."
  end
end

def exist
  ExistenceExpectation.new
end

describe "the expectation addition that a file exists" do
  File.new("./some-file", mode: "w").close
  it "exists" do
    "./some-file".should exist
  end
  it "doesn't exist" do
		"./some-nonexistent-file".should_not exist
  end
  # it "intentionaly fails" do
  #   "./some-nonexistent-file".should exist
  # end
end

require "./managers/*"
