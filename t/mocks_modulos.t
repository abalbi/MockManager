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
  my $self = shift;
  my $mm = MockManager->instancia;
  $mm->agregar(['Modulo','metodo1','retorno1']);
  my $r = Modulo->metodo1;
  is($r, 'retorno1');
}

#DADO que mm es una instancia de MockManager
#Y m es un MockObjectX
#CUANDO ejecuto mm->agregar(['Modulo', 'new',m])
#Y o = Modulo->new
#ENTONCES no recibo ningún error
#Y o es igual a m

sub emular_constructor : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m = MockObjectX->new();
  $mm->agregar(['Modulo','new',$m]);
  my $o = Modulo->new;
  is($m,$o);
}
1;
__PACKAGE__->new->runtests
