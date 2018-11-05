use v6;
use lib '.'; # to search for Hello.pm6 in the current dir
use DPLYRCommand;

say "============";
say DPLYRCommand::DPLYR-command.parse("select the variable mass");

say "============";
say DPLYRCommand::DPLYR-command.parse("select mass, height & skin_color");

say "============";
say DPLYRCommand::DPLYR-command.parse("keep only the variables mass & height");

say "============";
say DPLYRCommand::DPLYR-command.parse("mutate mass1 = mass, BMI = dfee");

say "=Actions============";
my $match0 =
DPLYRCommand::DPLYR-command.parse("select the variables mass, height, skin_color", actions => DPLYRCommand::DPLYR-command-actions.new );
say $match0.made;

say "=Actions============";
my $match1 =
DPLYRCommand::DPLYR-command.parse("mutate mass1=mass, Height=100", actions => DPLYRCommand::DPLYR-command-actions.new );
say $match1.made;

say "=Actions============";
my $match2 =
DPLYRCommand::DPLYR-command.parse("group over mass", actions => DPLYRCommand::DPLYR-command-actions.new );
say $match2.made;
