package MockManager;
use Data::Dumper;
use MockObjectX;
use MockManager::Llamado;

our $instancia = bless({},'MockManager');

sub instancia {
  return $MockManager::instancia;
}

sub limpiar {
  $MockManager::instancia = bless({},'MockManager');
}

sub agregar {
  my $self = $MockManager::instancia;
  shift;
  my (@llamados) = @_;
  foreach my $args (@llamados) {
    my $llamado = MockManager::Llamado->new(@{$args});
    push @{$self->{llamados}}, $llamado;
  }
}

sub llamados {
  my $self = $MockManager::instancia;
  return $self->{llamados};
}
1;
