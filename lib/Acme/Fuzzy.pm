package Acme::Fuzzy;

use strict;
use warnings;
our $VERSION = '0.01';
use Carp ();
use Text::Soundex ();
use List::MoreUtils ();
use Class::Inspector;

sub import {
    package UNIVERSAL;
    our $AUTOLOAD;
    no strict 'refs';
    *UNIVERSAL::AUTOLOAD = sub {
        my $auto = $UNIVERSAL::AUTOLOAD;
        return if $auto =~ /::DESTROY$/;

        if ($auto =~ /^(.+)::([^:]+)$/) {
            my ($klass, $meth) = ($1, $2);

            # generate soundex
            my $klass_soundex = Text::Soundex::soundex($klass);
            my $meth_soundex = Text::Soundex::soundex($meth);

            # search class
            for my $target_class (Acme::Fuzzy::_packages()) {
                my $target_class_soundex = Text::Soundex::soundex($target_class);
                if ($klass_soundex eq $target_class_soundex) {
                    if ($target_class->can($meth)) {
                        return $target_class->$meth(@_);
                    } else {
                        # search method
                        for my $target_meth (@{ Class::Inspector->functions($target_class) }) {
                            my $target_meth_soundex = Text::Soundex::soundex($target_meth);
                            if ($meth_soundex eq $target_meth_soundex) {
                                if ($target_class->can($target_meth)) {
                                    return $target_class->$target_meth(@_);
                                }
                            }
                        }
                    }
                }
            }
            Carp::croak "no method found: $auto";
        } else {
            Carp::croak "invalid method call: $auto";
        }
    };
}

sub _packages {
    return
      reverse
      map  { $_->[0] }
      sort { $a->[1] <=> $b->[1] }
      map  { [ $_, length($_) ] }
      List::MoreUtils::uniq( map { s/::$//; $_ } _find( \%::, '' ) );
}

sub _find {
    my ( $href, $current ) = @_;

    my @keys   = keys %$href;
    my @names  = grep { /::$/ } @keys;
    my $ignore = ( scalar @keys == scalar @names ) ? 0 : 1;

    my @found;
    foreach my $name (@names) {
        next if $name =~ /^main/;
        my $child = "$current$name";
        push @found, $child unless $ignore;
        push @found, _find( $href->{"$name"}, $child );
    }
    if ( !@names and @keys and $current ) {
        push @found, $current;
    }

    return @found;
}


1;
__END__

=head1 NAME

Acme::Fuzzy -

=head1 SYNOPSIS

  use Acme::Fuzzy;

=head1 DESCRIPTION

Acme::Fuzzy is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom jsdfkla gmail fsadkjl comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
