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
    Sequence,
    Connection,
} from './commonTypes';

using {
    function,
    field,
} from './commonAspects';


entity ModelTables : managed, function {
    key ID            : GUID                               @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type          : Association to one ModelTableTypes @title       : 'Type';
        transportData : TransportData default false;
        connection    : Connection;
        fields        : Composition of many ModelTableFields
                            on fields.modelTable = $self;
}


entity ModelTableFields : managed, field {
    key ID         : GUID;
        modelTable : Association to one ModelTables @mandatory;
        sequence   : Sequence default 10;
}

type ModelTableType @(assert.range) : String(10) enum {
    Environment = 'ENV';
    DataLake    = 'ENVDL';
    HANA        = 'HANA';
    OData       = 'ODATA';
}

entity ModelTableTypes : CodeList {
    key code : ModelTableType default 'ENV';
}

type TransportData : Boolean @title : 'Transport Data';
