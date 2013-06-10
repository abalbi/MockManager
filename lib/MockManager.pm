package MockManager;
use MockObjectX;

our $instancia = bless({},'MockManager');

sub instancia {
  return $MockManager::instancia;
}

sub agregar {
}
1;
