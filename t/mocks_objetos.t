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

#Dado que mm es una instancia de MockManager
#Y m es una instancia de MockObjectX
#CUANDO ejecuto mm->agregar([m, 'metodo1','retorno1'])
#Y r = m->retorno1
#ENTONCES no recibo ningún error
#Y r es igual a 'retorno1'

sub agregar_llamado_con_metodo : Test(1){
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  $mm->agregar([$m1,'metodo1','retorno1']);
  my $r = $m1->metodo1;
  is($r,'retorno1');
}

#DADO el uso de MockManager::Llamado
#CUANDO MockManager::Llamado->new
#ENTONCES recibo un error que dice "No se puede crear un MockManager::Llamado sin un MockObjectX definido"

sub crear_llamado_sin_mock : Test(1) {
  my $self = shift;
  throws_ok {MockManager::Llamado->new} qr/No se puede crear un MockManager::Llamado sin un MockObjectX definido/;
}

# DADO que mm es una instancia de MockManager
#  Y m1 es una instancia de MockObjectX
#  Y m2 es una instancia de MockObjectX
#  Y mm->agregar([m1, 'metodo1','retorno1'],[m2, 'metodo2','retorno2'])
# CUANDO r = m2->metodo2
# ENTONCES recibo un error "Se esperaba el llamado de m1->metodo1 : 'retorno1'

sub llamados_en_orden : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  my $m2 = MockObjectX->new();
  $mm->agregar([$m1,'metodo1','retorno1'], [$m2,'metodo2','retorno2']);
  throws_ok {$m2->metodo2} qr/Se esperaba el llamado de .+ -> metodo1 : 'retorno1'/;
}

# DADO que mm es una instancia de MockManager
#  Y m1 es una instancia de MockObjectX
#  Y mm->agregar([m1, 'metodo1','retorno1'],[m1, 'metodo2','retorno2'])
# CUANDO r = m1->metodo2
# ENTONCES recibo un error "Se esperaba el llamado de m1->metodo1 : 'retorno1'

sub llamados_en_orden : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new('m1');
  $mm->agregar([$m1,'metodo1','retorno1'], [$m1,'metodo2','retorno2']);
  throws_ok {$m1->metodo2} qr/Se esperaba el llamado de m1 -> metodo1 : 'retorno1'/;
}

# DADO que mm es una instancia de MockManager
# CUANDO m = MockObjectX->new
# ENTONCES mm->mocks->[0] es igual m

sub autoregistrar_mocks : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  is($mm->mocks->{$m1}, $m1);
}

#DADO que mm es una instancia de MockManager
#Y m1 es una instancia de MockObjectX
#Y m2 es una instancia de MockObjectX
#Y mm->agregar([m1, 'metodo1','retorno1'],[m2, 'metodo2','retorno2'])
#CUANDO r = m1->metodo1
#  Y mm->terminar
#ENTONCES recibo un error 'No se realizaron todas las ejecuciones esperadas'

sub mas_esperados_que_realizados : Test(1) {
  my $self = shift;
  my $mm = MockManager->instancia;
  my $m1 = MockObjectX->new();
  my $m2 = MockObjectX->new();
  $mm->agregar([$m1,'metodo1','retorno1'], [$m2,'metodo2','retorno2']);
  throws_ok {$mm->terminar} qr/No se realizaron todas las ejecuciones esperadas/;
}
1;
__PACKAGE__->new->runtests
