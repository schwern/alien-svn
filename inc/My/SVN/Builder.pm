package My::SVN::Builder;

use File::Basename;

use base 'Alien::Base::ModuleBuild';

sub alien_check_installed_version {
   my $self = shift;

   my $version = eval { reqiure SVN::Core; SVN::Core->VERSION; };

   return unless defined $version;

   return $version;
}

sub alien_check_built_version {
   my $self = shift;

   my $libdir = 'subversion/bindings/swig/perl/native';
   require lib;
   lib->import($libdir);

   my $version = eval { require SVN::Core; SVN::Core->VERSION; };

   lib->unimport($libdir);

   return $version || 'unknown';
}

sub ACTION_distmeta {
    my $self = shift;

    $self->depends_on('alien_code');

    my %provides;
    for my $pm ($self->rscan_dir($self->alien_temp_dir, qr/\.pm$/)) {
        my $module = 'SVN::' . basename($pm, ".pm");

        $provides{$module} = { file => $pm };
    }

    $provides{"SVN::Core"}{version}  = $self->config_data('version');
    $provides{"Alien::SVN"} = {
        version => $self->config_data('version').'.0',
        file    => 'lib/Alien/SVN.pm'
    };

    $self->meta_merge({ provides => \%provides, });
}


my %build_to_makemaker = (
   # Some names they have in common
   map {lc($_) => $_} qw(DESTDIR PREFIX INSTALL_BASE UNINST INSTALLDIRS),
);

my %translate_values = (
    installdirs     => {
        core    => "perl",
        site    => 'site',
        vendor  => 'vendor'
    }
);

sub _makemaker_args {
    my $self = shift;

    my $props = $self->{properties};
    my %mm_args;

    for my $key (keys %build_to_makemaker) {
        next unless defined $props->{$key};
        my $value = $props->{$key};
        $value = $translate_values{$key}{$value} if $translate_values{$key};

        $mm_args{$build_to_makemaker{$key}} = $value;
    }

    return map { "$_=$mm_args{$_}" } keys %mm_args;
}

sub _default_configure_args {
    my $self = shift;

    my $props = $self->{properties};
    my $prefix = $props->{install_base} ||
                 $props->{prefix} ||
                 $Config{siteprefix};
    my %args = (
        '--prefix' => $prefix,
        '--libdir' => File::Spec->catdir(
            $self->install_destination('arch'), 'Alien', 'SVN'
        ),
    );

    return join ' ', map { "$_=$args{$_}" } sort keys %args;
}


1;

