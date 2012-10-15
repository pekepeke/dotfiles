use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my %opts;
GetOptions(\%opts, qw(
    help|h=s
));
