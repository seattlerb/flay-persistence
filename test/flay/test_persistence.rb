require "minitest/autorun"
require "flay"
# require "flay_persistence" -- loaded by plugin system

module TestFlay; end

class TestFlay::TestPersistence < Minitest::Test
  def test_ARGH
    persist = ENV["P"]

    skip "Array#hash is buggy on 1.8" if RUBY_VERSION < "1.9" and not persist

    opts = persist ? %w[-p] : []
    opts = Flay.parse_options opts
    flay = Flay.new opts

    # from array_bare_hash_labels and proc_args_0 in pt_testcase.rb:

    sexp = s(:block,
             s(:hash,
               s(:str),
               s(:str),
               s(:str),
               s(:call,
                 s(:lit),
                 s(:call, s(:lit), s(:lit)),
                 s(:call,
                   s(:lit),
                   s(:call, s(:lit), s(:lit)),
                   s(:call, s(:lit), s(:lit))))),
             s(:hash,
               s(:str),
               s(:str),
               s(:str),
               s(:call,
                 s(:lit),
                 s(:call, s(:lit), s(:nil), s(:lit)),
                 s(:lit),
                 s(:call,
                   s(:lit),
                   s(:call, s(:lit), s(:nil), s(:lit)),
                   s(:lit),
                   s(:call, s(:lit), s(:lit))))))

    flay.process_sexp sexp

    expect = [[:call], [:hash], [:hash]]
    actual = flay.hashes.values.map { |ss| ss.map(&:first) }

    assert_equal expect, actual.sort_by { |a| a.first.to_s }
  end
end
