package MockManager;
use Data::Dumper;
use MockObjectX;
use TinyMockerX;
use MockManager::Llamado;

our $instancia = MockManager->new;

sub instancia {
  return $MockManager::instancia;
}

sub limpiar {
  $MockManager::instancia = MockManager->new;
}

sub new {
  return bless({
    mocks => {},
    llamados => [],
    construido => 0,
    cuenta => 0
  },'MockManager');
}

sub registrar_mock {
  my $self = $MockManager::instancia;
  shift;
  my $mock = shift;
  if(ref($self->{mocks}) ne 'HASH') {
    $self->{mocks} = {};
  }
  $self->{mocks}->{$mock} = $mock;
}

sub agregar {
  my $self = $MockManager::instancia;
  shift;
  my (@llamados) = @_;
  foreach my $args (@llamados) {
    if(ref($args->[0])) {
      my $llamado = MockManager::Llamado->new(@{$args});
      push @{$self->{llamados}}, $llamado;
      $self->registrar_mock($llamado->mock);
    } else {
      
    }
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

sub validar_llamada {
  my $self = $MockManager::instancia;
  shift;
  my $mock = shift;
  my $metodo = shift;
  my $retorno = shift;
  my $llamado = $self->llamados->[$self->{cuenta}];
  if (not ($llamado->mock eq $mock)) {
    die "Se esperaba el llamado de ".$llamado->mock." -> ".$llamado->metodo." : '".$llamado->retorno."'"; 
  }
  $self->{cuenta}++;
}

sub terminar {
  my $self = $MockManager::instancia;
  die "No se realizaron todas las ejecuciones esperadas" if $self->{cuenta} != scalar @{$self->llamados};
}
1;
