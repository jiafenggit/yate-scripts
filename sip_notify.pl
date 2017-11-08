#!/usr/bin/perl

# Some SIP devices (Linksys/Cisco devices) send NOTIFY requests to
# keep NAT bindings active. This script sends responses to such
# requests.

use strict;
use warnings;
use lib '/usr/share/yate/scripts';
use Yate;

sub OnSipNotify($) {
  my $yate = shift;
  my $event = $yate->param('sip_event');

  if ($event eq 'keep-alive') {
    $yate->param('code', 200);
    return 1;
  }

  $yate->output('Unsupported event ' . $event);
  $yate->param('code', 489);
  $yate->param('osip_Allow-Events', 'keep-alive');
  return 1;
}


my $yate = new Yate();
$yate->install('sip.notify', \&OnSipNotify);
$yate->listen();
