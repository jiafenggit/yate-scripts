#!/usr/bin/perl

# This script shortens the SIP registration interval for NATed SIP
# devices so that NAT bindings are refreshed more frequently (this
# helps avoid unreachable NATed phones).

use strict;
use warnings;
use lib '/usr/share/yate/scripts';
use Yate;

my $SHORT_REGISTER_INTERVAL = 180;  # seconds

sub OnUserRegister($) {
  my $yate = shift;
  if (defined $yate->param('reg_nat_addr')) {
    if ($yate->param('expires') > $SHORT_REGISTER_INTERVAL) {
      $yate->output('Lowering registration expire');
      $yate->param('expires', $SHORT_REGISTER_INTERVAL);
    }
  }

  return 0;
}


my $yate = new Yate();
# Use a priority higher than the regfile module
$yate->install('user.register', \&OnUserRegister, 90);
$yate->listen();
