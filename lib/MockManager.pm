package MockManager;
use strict;
use Data::Dumper;
use MockObjectX;
use MockManager::Llamado;

our $instancia = MockManager->new;

sub instancia {
  return $MockManager::instancia;
}

sub new {
  return bless({
    mocks => {},
    llamados => [],
    construido => 0,
    cuenta => 0
  },'MockManager');
}

sub limpiar {
  $MockManager::instancia = MockManager->new;
}

sub agregar {
  my $self = $MockManager::instancia;
  shift;
  my (@llamados) = @_;
  foreach my $args (@llamados) {
    my $mock = $args->[0];
    my $metodo = $args->[1];
    my $retorno = $args->[2];
    if(ref($mock)) {
      $self->registrar_mock($mock);
    } else {
      my $modulo = $mock;
      $mock = $self->mocks->{$modulo};
      if(not $mock){
        $mock = $self->registrar_mock($modulo);
      }
      eval {
        my $estatico = $metodo;
        if($metodo eq '__new__') {
          $estatico = 'new';
        }
        no strict 'refs';
        no warnings 'redefine', 'prototype';
        *{"$modulo\:\:$estatico"} = sub {
          my $self = $MockManager::instancia;
          my $modulo = shift;
          return $self->mocks->{$modulo}->$metodo;
        };
      };
    }
    my $llamado = MockManager::Llamado->new($mock, $metodo, $retorno);
    push @{$self->llamados}, $llamado;
  }
}

sub mocks {
  my $self = $MockManager::instancia;
  if(ref($self->{mocks}) ne 'HASH') {
    $self->{mocks} = {};
  }
  return $self->{mocks};
}

sub registrar_mock {
  my $self = $MockManager::instancia;
  shift;
  my $mock = shift;
  my $key = "$mock";
  if(not ref($mock)) {
    $mock = MockObjectX->new();
    delete $self->mocks->{$mock};
  }
  $self->mocks->{$key} = $mock;
  return $mock;
}

sub llamados {
  my $self = $MockManager::instancia;
  return $self->{llamados};
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
