/*
    Time specifications grammar in EBNF-G4
    Copyright (C) 2017  Anton Antonov

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Written by Anton Antonov,
	antononcube @@@ gmail ... com,
	Windermere, Florida, USA.
*/

/*
    # How to use

    1. Install ANTLR (from http://www.antlr.org or https://github.com/antlr .)

    2. Download this grammar file.

    3. In the directory of the grammar file run:

       $> antlr4 TimeSpecificationsGrammar.g4

    4. Compile the generated Java files:

       $> javac TimeSpecificationsGrammar*.java

    5. Try out the grammar:

       $> grun TimeSpecificationsGrammar time_interval -tree
       from monday to friday
       ^D
       (time_interval (time_interval_spec from (time_spec (day_name (day_name_long monday))) to (time_spec (day_name (day_name_long friday)))))

*/

grammar TimeSpecificationsGrammar;

time_interval : time_interval_spec | number_of_time_units | week_of_year | month_of_year ;

time_unit : 'hour' | 'day' | 'week' | 'month' | 'year' | 'lifetime' ;

time_units : 'hours' | 'days' | 'weeks' | 'months' | 'years' | 'lifetimes' ;

number_of_time_units : number time_units | 'a' | 'one' time_unit ;

named_time_intervals : day_name_relative | time_interval_relative | month_name ;

time_interval_relative : 'the'? 'next' | 'last' time_unit | 'few' | number time_units ;

time_interval_spec : 'between' time_spec 'and' time_spec
        | 'from' time_spec 'to' time_spec
        | ( 'in' | 'during' )? named_time_intervals
        | 'between' number 'and' number_of_time_units ;

time_spec : right_now
        | day_name
        | week_number | week_of_year
        | month_name | month_of_year
        | holiday_name | holiday_offset
        | hour_spec ;

right_now : 'now' | 'right' 'now' | 'just' 'now' ;

day_name_relative : 'today' | 'yesterday' | 'tomorrow' | 'the' 'day' 'before' 'yesterday' ;

day_name_long : 'monday' | 'tuesday' | 'wednesday' | 'thursday' | 'friday' | 'saturday' | 'sunday' ;

day_name_long_plurals : 'mondays' | 'tuesdays' | 'wednesdays' | 'thursdays' | 'fridays' | 'saturdays' | 'sundays' ;

day_name_abbr : 'mon' | 'tue' | 'wed' | 'thu' | 'fri' | 'sat' | 'sun' ;

day_name : day_name_long | day_name_abbr | day_name_long_plurals ;

week_number : 'week' week_number_range ;

week_number_range : NUMBER ;

week_of_year : ( 'the' )? 'week' week_number_range 'of' year ;

month_name_long : 'january' | 'february' | 'march' | 'april' | 'may' | 'june' | 'july' | 'august' | 'september' | 'october' | 'november' | 'december' ;


month_name_abbr : 'jan' | 'feb' | 'mar' | 'apr' | 'may' | 'jun' | 'jul' | 'aug' | 'sep' | 'oct' | 'nov' | 'dec' ;

month_name : month_name_long | month_name_abbr ;

month_of_year : month_name ( 'of' )? ( year )? ;

year : 'year' year_number_range | year_number_range ;

year_number_range : YEARNUMBER ;

holiday_name : 'ramadan' | 'christmas' | 'thanksgiving' | 'memorial' 'day' | 'lincoln' 'day' | 'new' 'year' | 'mother' 'day' ;

holiday_offset : number_of_time_units 'before' | 'after' holiday_name ;

hour_spec : NUMBER ( 'am' | 'pm' )? ;

full_date_spec : number month_name | month_name number number ( number 'am' | 'pm' )? ;

number : NUMBER ;

YEARNUMBER : DIGIT DIGIT DIGIT DIGIT ;

HOURNUMBER : DIGIT | ( '0' | '1' ) DIGIT | '2' ( '0' | '1' | '2' ) ;

NUMBER : DIGIT+ ;

DIGIT: '0'..'9' ;


WS : (' '|'\t'|'\n'|'\r')+ -> skip ;