# t/mmkr/801.t
use strict;
local $^W = 1;
use Test::More tests => 24;
use_ok( 'ExtUtils::ModuleMaker' );
use_ok( 'ExtUtils::ModuleMaker::Auxiliary', qw(
        _save_pretesting_status
        _restore_pretesting_status
        check_MakefilePL 
    )
);

my $statusref = _save_pretesting_status();

SKIP: {
    eval { require 5.006_001 };
    skip "tests require File::Temp, core with 5.6", 
        (24 - 10) if $@;
    use warnings;
    use_ok( 'File::Temp', qw| tempdir |);

    # Simple tests of modulemaker utility in non-interactive mode

    my $cwd = $statusref->{cwd};
    my ($tdir, $topdir, @pred);

    {
        # test against Testing::Defaults

        $tdir = tempdir( CLEANUP => 1);
        ok(chdir $tdir, 'changed to temp directory for testing');

        ok(! system(qq{$^X -I"$cwd/blib/lib" "$cwd/blib/script/modulemaker" -In EU::MM::Testing::Defaults -a "Module abstract (<= 44 characters) goes here" -u "Hilton Stallone" -p RAMBO -o "Parliamentary Pictures" -w http://parliamentarypictures.com -e hiltons\@parliamentarypictures.com }), 
            "able to call modulemaker utility");

        $topdir = "EU/MM/Testing/Defaults"; 
        ok(-d $topdir, "by default, non-compact top directory created");
        ok(-f "$topdir/$_", "$_ file created")
            for qw| Changes LICENSE MANIFEST Makefile.PL README Todo |;
        ok(-d "$topdir/$_", "$_ directory created")
            for qw| lib t |;
        
        @pred = (
            "EU::MM::Testing::Defaults",
            "lib\/EU\/MM\/Testing\/Defaults\.pm",
            "Hilton\\sStallone",
            "hiltons\@parliamentarypictures\.com",
            "Module\\sabstract\\s\\(<=\\s44\\scharacters\\)\\sgoes\\shere",
        );

        check_MakefilePL($topdir, \@pred);
    }


    ok(chdir $statusref->{cwd},
        "changed back to original directory");
} # end SKIP block

END {
    _restore_pretesting_status($statusref);
}
