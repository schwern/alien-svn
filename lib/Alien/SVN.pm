package Alien::SVN;

use version;  our $VERSION = qw(1.7.3);

=head1 NAME

Alien::SVN - A wrapper for installing the SVN Perl bindings

=head1 DESCRIPTION

Alien::SVN is a wrapper to install the Perl bindings for subversion,
also known as L<SVN::Core>.  If your module needs L<SVN::Core> it can
depend on L<Alien::SVN> instead and then the CPAN shell can handle
automatic installation.  This is particularly useful for programs like
SVK.

It comes with a copy of Subversion 1.7.3 which it will compile but
only installs the Perl and Subversion libraries.  B<The subversion
binaries will not be installed>.


=head1 BUGS and FEEDBACK

Alien::SVN only wraps SVN::Core.  We don't work on it.

Bug reports, problems and feedback about Alien::SVN and building
SVN::Core should come to us at E<lt>bug-Alien-SVNE<gt> at
E<lt>rt.cpan.orgE<gt>.  Or use the web interface at
L<http://rt.cpan.org>.

Issues and improvements to SVN::Core should go to the Subversion
project directly.  L<http://subversion.apache.org/issue-tracker.html>

If you're not sure who to report to, you can always report to us and
we'll point you in the right direction.

Report early, report often.

The repository can be found at F<http://github.com/schwern/alien-svn/tree/master>.

=head1 LICENSE

Alien::SVN is copyright 2007-2009 Michael G Schwern E<lt>schwern@pobox.comE<gt>
It is licensed under the same terms as Perl itself.
See L<http://www.perl.com/perl/misc/Artistic.html> for licensing.

This product includes software developed by CollabNet (L<http://www.Collab.Net/>).
Subversion and SVN::Core are copyright (c) 2000-2009 CollabNet L<http://www.colabnet.net>.
All rights reserved.  See L<http://subversion.tigris.org/license-1.html> for licensing.

=cut

1;
