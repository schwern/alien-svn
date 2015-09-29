#!/usr/bin/perl -w

use strict;

use lib 'inc';
use My::SVN::Builder;

use Config;

my $build = My::SVN::Builder->new(
    module_name     => 'Alien::SVN',
    dist_author     => 'Michael G Schwern <schwern@pobox.com>',

    # perl for Alien::SVN, Apache for subversion and SVN::* modules.
    license         => 'open_source',

    requires        => {
        perl                    => '5.8.0',
        version                 => '0.70',
        'Alien::Base'           => '0.020',
    },
    build_requires      => {
        'ExtUtils::MakeMaker'   => '6.31',   # for INSTALL_BASE
        'Module::Build'         => '0.28',
        'Test::More'            => '0.40',
    },
    configure_requires  => {
        'Alien::Base'           => '0.020',
        'Module::Build'         => '0.28',
    },

    alien_repository => {
        protocol => 'local',
        location => 'src',
    },

    alien_helper => {
        nativedir => '"subversion/bindings/swig/perl/native"',
        make => '$self->notes("your_make")',
        configure_args => '$self->notes("configure_args")',
        mm_args => 'join(" ", $self->_makemaker_args())',
    },

    alien_build_commands => [
        '%c --enable-shared %{configure_args} PERL=%x',
        '%{make}',
        '%{make} swig-pl',
        'cd %{nativedir} && %x Makefile.PL %{mm_args}',
        '%{make} swig-pl-lib',
    ],

    alien_test_commands => [
        '%{make} check-swig-pl',
    ],

    alien_install_commands => [
        '%{make} install-lib',
        '%{make} install-swig-pl-lib',
        '%{make} -C %{nativedir} install',
    ],

    no_index => {
        directory => [qw(inc src)]
    },

    meta_merge => {
        resources => {
            license     => ['http://dev.perl.org/licenses/'],
            bugtracker  => 'https://github.com/evalEmpire/Alien-SVN/issues',
            repository  => 'https://github.com/evalEmpire/Alien-SVN/',
        },
    },
    
    create_readme => 1,
);
$build->create_build_script;

print <<'END';

---------------------------------------------------------------------
This module will build Subversion and install its libraries and Perl
bindings for you.

It requires a C compiler and make.
END

my $make = $build->prompt(
    "Which make should I use to build Subversion?",
    $Config{make}
);
$build->notes('your_make', $make);

my $configure_args = $build->prompt(
    "\n\nWould you like to pass any arguments to configure?",
    $build->_default_configure_args
);

$build->notes("configure_args", $configure_args);
