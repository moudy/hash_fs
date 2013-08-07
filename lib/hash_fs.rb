require "hash_fs/version"

class HashFS
  DEFAULTS = {
    include_root: true,
    ingnore_hidden: true,
    ignores: []
  }

  def initialize(root, options = {})
    @root, @options = root, DEFAULTS.dup.merge(options)
  end

  def to_hash(options = {})
    result = directory_hash(@root)
    @options[:include_root] ? result : result[root]
  end

  private

  def directory_hash(path, name = nil)
    data = {}
    data[name || path] = children = []

    Dir.foreach(path) do |entry|
      next if ignore?(entry)

      full_path = File.join(path, entry)

      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        children << entry
      end
    end

    data
  end

  def ignore?(entry)
    return true if (entry == '..' || entry == '.')
    return true if @options[:ingnore_hidden] && (/^\./ =~ entry)

   @options[:ignores].any? do |ignore|
      ignore =~ entry
    end
  end

end
