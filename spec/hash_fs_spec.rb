require_relative './spec_helper'
include FakeFS

describe HashFS do
  before do
    FakeFS.activate!
    FileSystem.clear
  end

  after do
    FakeFS.deactivate!
  end

  describe "created with empty direcory" do
    it "must have the directory as the key and an empty array as the value" do
      root_path = '/my/root_path'
      FileUtils.mkdir_p(root_path)
      h = HashFS.new(root_path)

      h.to_hash.must_equal({ root_path => [] })
    end
  end

  describe "created with files in direcory" do
    before do
      @root_path = '/my/root_path'
      @filename = 'file.txt'

      FileUtils.mkdir_p @root_path
      File.open(File.join(@root_path, @filename), 'w') { |f| f.write "foo" }

      @h = HashFS.new(@root_path)
    end

    it "should list the files in an array" do
      @h.to_hash[@root_path].must_equal [@filename]
    end

    it 'should ingnore hidded filds by default' do
      File.open(File.join(@root_path, '.hidden.txt'), 'w') { |f| f.write "foo" }
      @h.to_hash[@root_path].must_equal [@filename]
    end

  end

end
