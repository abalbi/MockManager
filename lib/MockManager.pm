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
    if(ref($self->{mocks}) ne 'HASH') {
      $self->{mocks} = {};
    }
    $self->{mocks}->{$llamado->mock} = $llamado->mock;
  }
}

sub llamados {
  my $self = $MockManager::instancia;
  return $self->{llamados};
}

sub mocks {
  my $self = $MockManager::instancia;
  return $self->{mocks};
}

sub construido {
  my $self = shift;
  my $boo = shift;
  $self->{construido} = 1 if $boo;
  return $self->{construido};
}

sub construir_fixture {
  my $self = $MockManager::instancia;
  return if $self->construido;
  foreach my $mock (values %{$self->mocks}) {
    my %reg_temp;
    foreach my $llamado (@{$self->llamados}) {
      if($mock eq $llamado->mock) {
        $reg_temp{$llamado->metodo} = [] if not $reg_temp{$llamado->metodo};
        push @{$reg_temp{$llamado->metodo}}, $llamado->retorno;
      }
    }
    foreach my $metodo (keys %reg_temp) {
      $mock->set_series($metodo, @{$reg_temp{$metodo}});
    }
  }
  $self->construido(1);
}
1;
