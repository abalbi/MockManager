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
#Y m es un MockObjectX
#CUANDO ejecuto mm->agregar([m, 'metodo1','retorno1'])
#Y m->metodo1('param1')
#ENTONCES recibo ningún error "No es separaban parametros"

sub mas_esperados_que_realizados : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  $mm->agregar([$m1,'metodo1','retorno1']);
  throws_ok {$m1->metodo1('param1')} qr/No se esperaban parametros/;
}
1;
__PACKAGE__->new->runtests
