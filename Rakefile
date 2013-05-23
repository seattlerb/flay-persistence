# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.add_include_dirs "../../flay/dev/lib"
Hoe.add_include_dirs "../../ruby_parser/dev/lib"

Hoe.plugin :isolate
Hoe.plugin :seattlerb

Hoe.spec "flay-persistence" do
  developer "Ryan Davis", "ryand-ruby@zenspider.com"
  license "MIT"

  dependency "flay", "~> 2.0" # HACK: should be 2.1
  dependency "RubyInline", "~> 3.12"
end

# vim: syntax=ruby
