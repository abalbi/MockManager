package MockManager;
use MockObjectX;

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
  my (@llamadas) = @_;
  push @{$self->{llamadas}}, @llamadas;
}

sub llamadas {
  my $self = $MockManager::instancia;
  return scalar @{$self->{llamadas}}
}
1;
