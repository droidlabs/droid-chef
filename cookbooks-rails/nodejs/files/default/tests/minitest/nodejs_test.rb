require "minitest/autorun"

describe_recipe "nodejs::default" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "packages" do
    it "installs the nodejs dependency packages" do
      if node["platform"] == "ubuntu"
        package("libssl-dev").must_be_installed
      end
    end
  end

  describe "files" do
    it "creates the node binary file" do
      file("#{node["nodejs"]["dir"]}/bin/node").must_exist
    end

    it "creates the npm binary file" do
      file("#{node["nodejs"]["dir"]}/bin/npm").must_exist
    end
  end
end
