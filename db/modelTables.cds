using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
    Sequence
} from './commonTypes';

using {
    function,
    field,
    myCodeList
} from './commonAspects';


entity ModelTables : managed, function {
    key ID            : GUID;
        type          : Association to one ModelTableTypes;
        transportData : Boolean;
        connName      : String;
        fields        : Composition of many ModelTableFields
                            on fields.modelTable = $self;
}


entity ModelTableFields : managed, field {
    key ID         : GUID;
        modelTable : Association to one ModelTables @mandatory;
// sequence : Sequence;
}

type ModelTableType @(assert.range) : String(10) enum {
    Environment = 'ENV';
    DataLake    = 'ENVDL';
    HANA        = 'HANA';
    OData       = 'ODATA';
}

entity ModelTableTypes : myCodeList {
    key code : ModelTableType default 'ENV';
}