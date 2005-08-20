# t/02_bad constructor.t

# use Test::More tests => 37;
use Test::More tests => 34;
use strict;

BEGIN { use_ok( 'ExtUtils::ModuleMaker' ); }

use lib ("./t/testlib");

SKIP: {
    eval { require 5.006_001 };
    skip "failsafe requires File::Temp, core with Perl 5.6", 36 if $@;
    use warnings;
    use _Auxiliary qw(
        failsafe
    );


    ###########################################################################

    failsafe([ 'NAME' ], "^Must be hash or balanced list of key-value pairs:",
        "Constructor correctly failed due to odd number of arguments"
    );

    failsafe( [ 'NAME' => 'Jim', 'ABSTRACT' ], 
        "^Must be hash or balanced list of key-value pairs:",
        "Constructor correctly failed due to odd number of arguments"
    );

    failsafe( [
        'ABSTRACT' => 'The quick brown fox jumps over the lazy dog',
    ], 
        "^NAME is required",
        "Constructor correctly failed due to lack of NAME for module"
    );

    failsafe( [
        'NAME' => 'My::B!ad::Module',
    ], 
        "^Module NAME contains illegal characters",
        "Constructor correctly failed due to illegal characters in module name"
    );

    failsafe( [
        'NAME' => "My'BadModule",
    ], 
        "^Module NAME contains illegal characters",
        "Perl 4-style single-quote path separators no longer supported"
    );

    failsafe( [
        'NAME'     => 'ABC::XYZ',
        'ABSTRACT' => '123456789012345678901234567890123456789012345',
    ], 
        "^ABSTRACTs are limited to 44 characters",
        "Constructor correctly failed due to ABSTRACT > 44 characters"
    );

    failsafe( [
        'NAME'     => 'ABC::DEF',
#        'AUTHOR'   => { 
#                        NAME   => 'James E Keenan',
#                        CPANID => 'ABCDEFGHIJ',
#           },
        'AUTHOR'   => 'James E Keenan',
        'CPANID'   => 'ABCDEFGHIJ',
    ], 
        "^CPAN IDs are 3-9 characters",
        "Constructor correctly failed due to CPANID > 9 characters"
    );

    failsafe( [
        'NAME'     => 'ABC::XYZ',
#        'AUTHOR'   => { 
#                        NAME   => 'James E Keenan',
#                        CPANID => 'AB',
#           },
        'AUTHOR'   => 'James E Keenan',
        'CPANID'   => 'AB',
    ], 
        "^CPAN IDs are 3-9 characters",
        "Constructor correctly failed due to CPANID < 3 characters"
    );

#    failsafe( [
#        'NAME'     => 'ABC::XYZ',
#        'CPANID'   => 'JKEENAN',
#    ], 
#        "^CPANID improper top-level key",
#        "Constructor correctly failed; argument must be in 2nd-level hash"
#    );

    failsafe( [
        'NAME'     => 'ABC::XYZ',
#        'AUTHOR'   => { 
#                        NAME   => 'James E Keenan',
#                        EMAIL  => 'jkeenancpan.org',
#           },
        'AUTHOR'   => 'James E Keenan',
        'EMAIL'    => 'jkeenancpan.org',
    ], 
        "^EMAIL addresses need to have an at sign",
        "Constructor correctly failed; e-mail must have '\@' sign"
    );

    failsafe( [
        'NAME'     => 'ABC::XYZ',
#        'AUTHOR'   => { 
#                        AUTHOR  => 'James E Keenan',
#                        WEBSITE => 'ftp://ftp.perl.org',
#           },
        'AUTHOR'   => 'James E Keenan',
        'WEBSITE'   => 'ftp://ftp.perl.org',
    ], 
        "^WEBSITEs should start with an \"http:\" or \"https:\"",
        "Constructor correctly failed; websites start 'http' or 'https'"
    );

    failsafe( [
        'NAME'     => 'ABC::XYZ',
        'LICENSE'  => 'dka;fkkj3o9jflvbkja0 lkasd;ldfkJKD38kdd;llk45',
    ], 
        "^LICENSE is not recognized",
        "Constructor correctly failed due to unrecognized LICENSE"
    );

} # end SKIP block

