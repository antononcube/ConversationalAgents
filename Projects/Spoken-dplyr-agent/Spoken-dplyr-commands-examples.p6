#==============================================================================
#
#   Examples of spoken dplyr commands in Raku Perl 6
#   Copyright (C) 2018  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================
#
#   Note that at this point these Raku Perl 6 files are organized in way
#   that mimics the organization of the Mathematica files in the projects.
#   That is probably not the best way for using the package system of
#   Raku Perl 6.
#
#==============================================================================

use v6;
use lib '.';
use lib '../../../Projects/Spoken-dplyr-agent';
use DataTransformationWorkflowsGrammar;
use Spoken-dplyr-actions;

say "============";
say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("select the variable mass");

say "============";
say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("select mass, height & skin_color");

say "============";
say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("keep only the variables mass & height");

say "============";
say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("mutate mass1 = mass, BMI = dfee");

say "=Actions============";
my $match0 =
DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("select the variables mass, height, skin_color", actions => Spoken-dplyr-actions::Spoken-dplyr-actions.new );
say $match0.made;

say "=Actions============";
my $match1 =
DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("mutate mass1=mass, Height=100", actions => Spoken-dplyr-actions::Spoken-dplyr-actions.new );
say $match1.made;

say "=Actions============";
my $match2 =
DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("group over mass", actions => Spoken-dplyr-actions::Spoken-dplyr-actions.new );
say $match2.made;
