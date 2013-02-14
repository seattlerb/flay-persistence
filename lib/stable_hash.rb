$: << "../../RubyInline/dev/lib"
require "rubygems"
require "inline"
require "sexp"

class Sexp # :nodoc:
  begin
    names = %w(alias and arglist args array attrasgn attrset back_ref
               begin block block_pass break call case cdecl class colon2
               colon3 const cvar cvasgn cvdecl defined defn defs dot2
               dot3 dregx dregx_once dstr dsym dxstr ensure evstr false
               flip2 flip3 for gasgn gvar hash iasgn if iter ivar lasgn
               lit lvar masgn match match2 match3 module next nil not
               nth_ref op_asgn op_asgn1 op_asgn2 op_asgn_and op_asgn_or or
               postexe redo resbody rescue retry return sclass self
               splat str super svalue to_ary true undef until valias
               when while xstr yield zsuper)

    ##
    # All ruby_parser nodes in an index hash. Used by jenkins algorithm.

    NODE_NAMES = Hash[names.each_with_index.map {|n, i| [n.to_sym, i] }]

    ##
    # Calculate the jenkins hash and memoize it.

    def stable_hash
      @stable_hash ||= self._stable_hash
    end

    inline :C do |b|
      raise CompilationError if ENV["PURE_RUBY"]

      b.alias_type_converter "unsigned int", "uint32_t"
      b.map_ruby_const "Sexp", "NODE_NAMES"
      b.add_id :grep

      b.prefix <<-C
        static uint32_t jenkins(VALUE sexp) {
          // http://www.burtleburtle.net/bob/hash/doobs.html
          // http://en.wikipedia.org/wiki/Jenkins_hash_function

          uint32_t hash = 0;
          VALUE n;
          size_t max, i;

          n = rb_hash_lookup(cNODE_NAMES, rb_ary_entry(sexp, 0));

          if (! RTEST(n)) {
            rb_p(sexp);
            rb_raise(rb_eStandardError, "bad lookup");
          }

          hash += FI\X2INT(n);
          hash += hash << 10;
          hash ^= hash >>  6;

          for (i = 0; i < RARRAY_LEN(sexp); i++) {
            VALUE obj = RARRAY_PTR(sexp)[i];
            if (CLASS_OF(obj) == cSexp) {
              hash += jenkins(obj);
              hash += hash << 10;
              hash ^= hash >>  6;
            }
          }

          hash += hash << 3;
          hash ^= hash >> 11;
          hash += hash << 15;

          return hash;
        }
      C

      b.c <<-C
        uint32_t _stable_hash() {
          return jenkins(self);
        }
      C
    end
  rescue CompilationError
    MAX_INT32 = 2 ** 32 - 1 # :nodoc:

    def _stable_hash # :nodoc: see above
      hash = 0

      n = NODE_NAMES.fetch first

      hash += n          & MAX_INT32
      hash += hash << 10 & MAX_INT32
      hash ^= hash >>  6 & MAX_INT32

      each do |o|
        next unless Sexp === o
        hash = hash + o.stable_hash  & MAX_INT32
        hash = (hash + (hash << 10)) & MAX_INT32
        hash = (hash ^ (hash >>  6)) & MAX_INT32
      end

      hash = (hash + (hash <<  3)) & MAX_INT32
      hash = (hash ^ (hash >> 11)) & MAX_INT32
      hash = (hash + (hash << 15)) & MAX_INT32

      hash
    end
  end
end
