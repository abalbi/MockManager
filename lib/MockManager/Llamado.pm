package MockManager::Llamado;
sub new {
  my $self = bless({},'MockManager::Llamado');
  shift;
  $self->{mock} = shift;
  $self->{metodo} = shift;
  $self->{retorno} = shift;
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
1;
