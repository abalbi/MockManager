package Test::MockManager;
use Data::Dumper;
use base qw(Test::Class);
use lib 'lib';
use MockManager;
use MockObjectX;
use Test::More;
use Test::Exception;


sub before : Test(setup)    {
}; 

#Dado el use de MockManager
#Cuando ejecutó MockManager->instancia
#Entonces el método me devuelve una instancia del MockManager
sub singleton : Test(1) {
  isa_ok(MockManager->instancia, 'MockManager');
};

#DADO que mm es una instancia de MockManager
#  Y m es una instancia de MockObjectX
#CUANDO ejecuto mm->agregar([m])
#ENTONCES no recibo ningún error

sub agregar_llamado : Test() {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m = MockObjectX->new();
  lives_ok {$mm->agregar([$m])};
}

1;
__PACKAGE__->new->runtests
