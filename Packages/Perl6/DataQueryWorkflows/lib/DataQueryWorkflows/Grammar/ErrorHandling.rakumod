use v6;

# This role class has common command parts.
role DataQueryWorkflows::Grammar::ErrorHandling {

    # Error message
    # method error($msg) {
    #   my $parsed = self.target.substr(0, self.pos).trim-trailing;
    #   my $context = $parsed.substr($parsed.chars - 15 max 0) ~ '⏏' ~ self.target.substr($parsed.chars, 15);
    #   my $line-no = $parsed.lines.elems;
    #   die "Cannot parse code: $msg\n" ~ "at line $line-no, around " ~ $context.perl ~ "\n(error location indicated by ⏏)\n";
    # }

    method ws() {
      if self.pos > $*HIGHWATER {
        $*HIGHWATER = self.pos;
        $*LASTRULE = callframe(1).code.name;
      }
      callsame;
    }

    method parse($target, |c) {
      my $*HIGHWATER = 0;
      my $*LASTRULE;
      my $match = callsame;
      self.error_msg($target) unless $match;
      return $match;
    }

    method error_msg($target) {
      my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
      my $un-parsed = $target.substr($*HIGHWATER, $target.chars).trim-trailing;
      my $line-no = $parsed.lines.elems;
      my $msg = "Cannot parse the command";
      # say 'un-parsed : ', $un-parsed;
      # say '$*LASTRULE : ', $*LASTRULE;
      $msg ~= "; error in rule $*LASTRULE at line $line-no" if $*LASTRULE;
      $msg ~= "; target '$target' position $*HIGHWATER";
      $msg ~= "; parsed '$parsed', un-parsed '$un-parsed'";
      $msg ~= ' .';
      say $msg;
    }

}
