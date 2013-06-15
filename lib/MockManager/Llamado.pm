package MockManager::Llamado;
use Data::Dumper;
sub new {
  my $self = bless({},'MockManager::Llamado');
  shift;
  $self->{mock} = shift;
  die "No se puede crear un MockManager::Llamado sin un MockObjectX definido" if not $self->{mock};
  $self->{metodo} = shift;
  $self->{retorno} = shift;
  $self->{params} = [@_];
  $self->{ejecutado} = 0;
  return $self;
}

sub ejecutado {
  my $self = shift;
  my $boo = shift;
  $self->{ejecutado} = 1 if $boo;
  return $self->{ejecutado};
}

sub mock {
  my $self = shift;
  return $self->{mock};
}

sub metodo {
  my $self = shift;
  return $self->{metodo};
}

sub retorno {
  my $self = shift;
  return $self->{retorno};
}

sub params {
  my $self = shift;
  return $self->{params};
}
1;
