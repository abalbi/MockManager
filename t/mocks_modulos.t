package Test::MockManager;
use Data::Dumper;
use base qw(Test::Class);
use lib 'lib';
use MockManager;
use MockObjectX;
use Test::More;
use Test::Exception;


sub before : Test(setup) {
  MockManager->limpiar;
}; 


#DADO que mm es una instancia de MockManager
#CUANDO ejecuto mm->agregar(['Modulo', 'metodo1','retorno1'])
#Y r = Modulo->retorno1
#ENTONCES no recibo ningún error
#Y r es igual a 'retorno1'

sub agregar_llamado_estatico : Test(1) {
}

1;
__PACKAGE__->new->runtests
