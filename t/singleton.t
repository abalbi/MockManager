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

sub agregar_llamado : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m = MockObjectX->new();
  lives_ok {$mm->agregar([$m])};
}

#Dado que mm es una instancia de MockManager
#Y m1 y m2 son instancias de MockObjectX
#Cuando ejecuto mm->agregar([m1],[m2])
#ENTONCES no recibo ningún error
#

sub agregar_llamados : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  my $m2 = MockObjectX->new();
  lives_ok {$mm->agregar([$m1],[$m2])};
}

#ado que mm es una instancia de MockManager
#Y m es una instancia de MockObjectX
#Y se ejecuto mm->agregar(m)
#CUANDO ejecutó c = mm->llamados
#ENTONCES no recibo ningún error
#Y c es igual a 1

sub cantidad_llamados : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  $mm->agregar([$m1]);
  my $c = scalar @{MockManager->llamados};
  is($c,1); 
}

#Dado que mm es una instancia de MockManager
#Y m es una instancia de MockObjectX
#Y se ejecuto mm->agregar(m)
#CUANDO ejecutó ll = mm->llamados->[0]
#ENTONCES ll es una instancia de MockManager::Llamado

sub acceder_a_un_llamado : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  $mm->agregar([$m1]);
  my $ll = $mm->llamados->[0];
  isa_ok($ll,'MockManager::Llamado');
}

1;
__PACKAGE__->new->runtests
