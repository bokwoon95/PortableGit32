package URI::mms;

use strict;
use warnings;

our $VERSION = '1.73';
$VERSION = eval $VERSION;

use parent 'URI::http';

sub default_port { 1755 }

1;
