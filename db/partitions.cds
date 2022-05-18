using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
    Value,
    Sequence,
    Partition
} from './commonTypes';
using {environment} from './commonAspects';
using {Fields} from './fields';

@assert.unique : {
    partition   : [
        environment,
        partition
    ],
    description : [
        environment,
        description
    ]
}
entity Partitions : managed, environment {
    key ID          : GUID;
        partition   : Partition;
        description : String;
        field       : Association to one Fields;
        ranges      : Composition of many PartitionRanges
                          on ranges.partition = $self;
}

entity PartitionRanges : managed, environment {
    key ID           : GUID;
        partition    : Association to one Partitions @mandatory;
        range        : Range;
        sequence     : Sequence;
        level        : Level default 0;
        value        : Value;
        hanaVolumeId : HanaVolumeId default 0;
}

type Range : String @title : 'Range'  @assert.format : '[A-Z,0-9,_]{1,5}';
type Level : Integer @title : 'Level';
type HanaVolumeId : Integer @title : 'HANA Volume ID of Host';
