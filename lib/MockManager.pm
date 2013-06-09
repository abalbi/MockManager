package MockManager;

our $instancia = bless({},'MockManager');

sub instancia {
  return $MockManager::instancia;
}
1;
