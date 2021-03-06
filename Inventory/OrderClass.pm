package Inventory::OrderClass;

use strict;
use warnings;

use Inventory;
class Inventory::OrderClass {
    type_name => 'order class',
    table_name => 'ORDER_CLASS',
    er_role => 'validation item',
    id_by => [
        order_class_name => { is => 'varchar' },
    ],
    has => [
        name => { is => 'String', is_calculated => 1 },
    ],
    schema_name => 'Inventory',
    data_source => 'Inventory::DataSource::Inventory',
};

sub name {
    my $self = shift;

    my($name) = $self->order_class_name =~ m/::(\w+)$/;
    return lc $name;
}

1;
