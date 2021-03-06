package Inventory::Command::Lookup;

use strict;
use warnings;

use Inventory;

use IO::Handle;

class Inventory::Command::Lookup {
    is => 'Inventory::Command',
    doc => 'Show details about an item',
    has => [
        bare_args => {
           is_optional => 1,
           shell_args_position => 1,
       },
    ],
};
 
sub execute {
    my $self = shift;

    my $key = $self->bare_args();

    my $prompted = 0;
    unless ($key) {
        STDOUT->autoflush(1);
        $prompted = 1;
        print "SKU, barcode or partial description: " unless ($ENV{'INVENTORY_TEST'});
        $key = <STDIN>;
        return 1 unless $key;

        chomp($key);
        $key =~ s/^\s+|\s+$//;
        return 1 unless $key;
    }

    my @items = Inventory::Item->get(sku => $key);
    push @items, Inventory::Item->get(barcode => $key);
    push @items, Inventory::Item->get('desc like' => "\%$key\%"); 

    unless (@items) {
        $self->status_message("No matching items");
        return;
    }

    my %printed;
    foreach my $item ( @items ) {
        next if ($printed{$item->id}++);

        $self->status_message(
            sprintf("Item: barcode %s sku %s count %d\n\t%s\n\n",
                $item->barcode, $item->sku, $item->count, $item->desc)
        );
    }

    return 1;
}

1;   
