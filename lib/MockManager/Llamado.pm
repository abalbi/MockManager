package MockManager::Llamado;
sub new {
  my $self = bless({},'MockManager::Llamado');
  shift;
  $self->{mock} = shift;
  $self->{metodo} = shift;
  $self->{retorno} = shift;
  return $self;
}
1;
