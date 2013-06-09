package Test::MockManager;
use Data::Dumper;
use base qw(Test::Class);
use lib 'lib';
use MockManager;
use Test::More;


sub before : Test(setup)    {
}; 

#Dado el use de MockManager
#Cuando ejecutó MockManager->instancia
#Entonces el método me devuelve una instancia del MockManager
sub singleton : Test(1) {
  isa_ok(MockManager->instancia, 'MockManager');
};

1;
__PACKAGE__->new->runtests
