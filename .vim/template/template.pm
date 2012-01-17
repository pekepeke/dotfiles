package <+FILENAME_NOEXT+>;

use strict;
use warnings;

use Carp;

our $VERSION = eval '0.001';
 
# use base 'Class::Accessor::Fast';
# __PACKAGE__->mk_accessors(qw());


sub new {
    my $class  = shift;
    my ($arg) = @_;
    my  $self   = {
    };
    bless $self, $class;
}

if ($0 eq __FILE__) {
}

1;
__END__

=head1 NAME

    <+FILENAME+> - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

<+AUTHOR+> <<+EMAIL+>>
