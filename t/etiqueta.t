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
#CUANDO ejecuto mm->etiqueta(m, 'objeto1')
#Y ejecuto mm->agregar(['objeto1', 'metodo1','retorno1'])
#Y r = m->metodo1
#ENTONCES r = 'retorno1'
sub etiqueta_desde_manager : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  $mm->etiqueta($m1,'objeto1');
  $mm->agregar(['objeto1','metodo1','retorno1']);
  my $r = $m1->metodo1();
  is($r,'retorno1');
}

1;
__PACKAGE__->new->runtests
