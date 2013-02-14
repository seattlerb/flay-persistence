require "rubygems"
require "flay"

##
# A simple plugin that adds persistence to flay

class Flay::Persistence
  # duh
  VERSION = "1.0.0"
end

class Flay # :nodoc:
  def self.options_persistence op, options # :nodoc:
    op.separator nil
    op.separator "Persistence options:"
    op.separator nil

    options[:redo] = false

    op.on("-r", "--redo", "Rerun a file already in the persistent db") do
      options[:redo] = true
    end

    op.on("-p", "--persistent", "Use a stable hash and persist flay data.") do
      require "stable_hash"

      Sexp.send :alias_method, :old_structural_hash, :structural_hash
      Sexp.send :alias_method, :structural_hash,     :stable_hash
      Flay.send :alias_method, :persist_process,     :process
      Flay.send :alias_method, :process,             :persist_hashes

      options[:persistent] = true
    end
  end

  def merge_hash h # :nodoc:
    h.each do |code, ary|
      self.hashes[code].concat ary
    end
  end

  ##
  # Overrides +process+ when the -p command-line option is used. This
  # loads up the persisted data, runs specified files individually,
  # merges those options with the main flay dataset, and then
  # saves the data back out.
  #
  # NOTE: Currently this is using Marshal because it is cheap and
  # easy. I don't plan for it to stay that way because it will bog
  # down. I'm hoping to get maglev sorted out so this can run on
  # maglev and take advantage of the transparent multi-process
  # persistence.

  def persist_hashes(*args)
    db_path = "flay.db"
    files = {}

    if File.exist? db_path then
      File.open db_path, "rb" do |f|
        files = Marshal.load f
      end
    end

    args.each do |path|
      next if files[path] unless option[:redo]

      initialize self.option
      persist_process path

      files[path] = self.hashes
    end

    initialize self.option

    files.each do |_, subhashes|
      merge_hash subhashes
    end
  ensure
    files.each do |code, hash| # strip default procs for marshal... ugh
      files[code] = {}.merge(hash)
    end

    File.open db_path, "wb" do |f|
      Marshal.dump files, f
    end
  end
end
