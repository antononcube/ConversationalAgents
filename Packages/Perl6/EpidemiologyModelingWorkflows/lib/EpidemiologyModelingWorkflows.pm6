=begin pod

=head1 EpidemiologyModelingWorkflows

C<EpidemiologyModelingWorkflows> package has grammar classes and action classes for the parsing and
interpretation of English natural speech commands that specify epidemiology modeling workflows.

=head1 Synopsis

    use EpidemiologyModelingWorkflows;
    my $rcode = to_ECMMon_R("create with SEI2R; simulate for 240 days; plot results")
    my $wlcode = to_ECMMon_WL("create with SEI2R; simulate for 240 days; plot results");

=end pod

unit module EpidemiologyModelingWorkflows;

use EpidemiologyModelingWorkflows::Grammar;
use EpidemiologyModelingWorkflows::Actions::ECMMon-Py;
use EpidemiologyModelingWorkflows::Actions::ECMMon-R;
use EpidemiologyModelingWorkflows::Actions::ECMMon-WL;

sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto to_ECMMon_Py($) is export {*}

multi to_ECMMon_Py ( Str $command where not has-semicolon($command) ) {

  my $match = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand.parse($command, actions => EpidemiologyModelingWorkflows::Actions::ECMMon-Py );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_ECMMon_Py ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_ECMMon_Py($_) }, @commandLines;

  return @smrLines.join(" \n");
}

#-----------------------------------------------------------
proto to_ECMMon_R($) is export {*}

multi to_ECMMon_R ( Str $command where not has-semicolon($command) ) {

  my $match = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand.parse($command, actions => EpidemiologyModelingWorkflows::Actions::ECMMon-R );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_ECMMon_R ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_ECMMon_R($_) }, @commandLines;

  return @smrLines.join(" %>%\n");
}

#-----------------------------------------------------------
proto to_ECMMon_WL($) is export {*}

multi to_ECMMon_WL ( Str $command where not has-semicolon($command) ) {

  my $match = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand.parse($command, actions => EpidemiologyModelingWorkflows::Actions::ECMMon-WL );
  die 'Cannot parse the given command.' unless $match;
  return $match.made;
}

multi to_ECMMon_WL ( Str $command where has-semicolon($command) ) {

  my @commandLines = $command.trim.split(/ ';' \s* /);

  @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

  my @smrLines =
  map { to_ECMMon_WL($_) }, @commandLines;

  return @smrLines.join(" ==>\n");
}
