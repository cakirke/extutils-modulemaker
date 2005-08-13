package ExtUtils::ModuleMaker::StandardText;
use strict;
local $^W = 1;

my %README_text = (
    eumm_instructions => q~
perl Makefile.PL
make
make test
make install
~,
    mb_instructions => q~
perl Build.PL
./Build
./Build test
./Build install
~,
    readme_top => q~

If this is still here it means the programmer was too lazy to create the readme file.

You can create it now by using the command shown above from this directory.

At the very least you should be able to use this set of instructions
to install the module...

~,
    readme_bottom => q~

If you are on a windows box you should use 'nmake' rather than 'make'.
~,
);

# Usage     : $self->file_text_README within complete_build()
# Purpose   : Build a supporting file
# Returns   : Text of the file being built
# Argument  : n/a
# Throws    : n/a
# Comments  : This method is a likely candidate for alteration in a subclass
sub file_text_README {
    my $self = shift;

    my $build_instructions =
        ( $self->{BUILD_SYSTEM} eq 'ExtUtils::MakeMaker' )
            ? $README_text{eumm_instructions}
            : $README_text{mb_instructions};
    return "pod2text $self->{NAME}.pm > README\n" . 
        $README_text{readme_top} .
	$build_instructions .
        $README_text{readme_bottom};
}

my $Makefile_text = q~

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => '%s',
    VERSION_FROM => '%s', # finds \$VERSION
    AUTHOR       => '%s (%s)',
    ABSTRACT     => '%s',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                    },
);
~;

# Usage     : $self->file_text_Makefile 
# Purpose   : Build a supporting file
# Returns   : Text of the file being built
# Argument  : n/a
# Throws    : n/a
# Comments  : This method is a likely candidate for alteration in a subclass
sub file_text_Makefile {
    my $self = shift;
#    my $page = sprintf $self->{standard}{Makefile_text},
    my $page = sprintf $Makefile_text,
        map { my $s = $_; $s =~ s{'}{\\'}g; $s; }
    $self->{NAME},
    $self->{FILE},
    $self->{AUTHOR}{NAME},
    $self->{AUTHOR}{EMAIL},
    $self->{ABSTRACT};
    return $page;
}

my %pod_wrapper = (
    head => '

#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!

',
    tail => '

 ====cut

#################### main pod documentation end ###################

',
);

sub pod_wrapper {
    my ( $self, $section ) = @_;
    my ($head, $tail);
    $head = $pod_wrapper{head};
    $tail = $pod_wrapper{tail};
    $tail =~ s/\n ====/\n=/g;
    return join( '', $head, $section, $tail );
}

my $block_new_method = <<'EOFBLOCK';

sub new
{
    my ($class, %parameters) = @_;

    my $self = bless ({}, ref ($class) || $class);

    return $self;
}

EOFBLOCK

# Usage     : $self->block_new_method() within generate_pm_file()
# Purpose   : Build part of a module pm file
# Returns   : Part of the file being built
# Argument  : $module: pointer to the module being built, for the primary
#                      module it is a pointer to $self
# Throws    : n/a
# Comments  : This method is a likely candidate for alteration in a subclass
sub block_new_method {
    my $self = shift;
    $block_new_method;
}