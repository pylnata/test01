using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

entity Environments : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        environment : String;
        version     : String;
        description : String;
        Checks      : Composition of many Checks
                          on Checks.Environment = $self;
        Fields      : Composition of many Fields
                          on Fields.Environment = $self;
        Functions   : Composition of many Functions
                          on Functions.Environment = $self;
}

entity Fields : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        field       : String;
        type        : String;
        description : String;
        Environment : Association to Environments;

}

entity Checks : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        check       : String;
        type        : String;
        description : String;
        Environment : Association to Environments;

}

entity Functions : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        function    : String;
        description : String;
        type        : String;
        Environment : Association to one Environments;
        ModelTable  : Association to one ModelTables
                          on ModelTable.ID = ID;
        Allocation  : Association to one Allocations
                          on Allocation.ID = ID;
}

entity FunctionChecks : managed {
    key ID       : UUID @odata.Type : 'Edm.String';
        Function : Association to one Functions;
        Field    : Association to one Fields;
}

entity FunctionFields : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        formula     : String;
        group_      : String;
        aggregation : String;
        Function    : Association to one Functions;
        Field       : Association to one Fields;
        Selections  : Association to many FunctionFieldSelections
                          on Selections.FunctionField = $self;
}

entity FunctionFieldSelections : managed {
    key ID            : UUID @odata.Type : 'Edm.String';
        sign          : String;
        opt           : String;
        low           : String;
        high          : String;
        FunctionField : Association to one FunctionFields;
}

entity ModelTables : managed {
    key ID          : UUID @odata.Type : 'Edm.String';
        type        : String;
        Environment : Association to one Environments;
        Function    : Association to one Functions;
        Fields      : Composition of many ModelTableFields
                          on Fields.ModelTable = $self;
}

entity ModelTableFields : managed {
    key ID         : UUID @odata.Type : 'Edm.String';
        field      : Association to one Fields;
        ModelTable : Association to one ModelTables;
}

entity InputFunctions as projection on Functions where type = 'MT';

entity Allocations : managed {
    key ID               : UUID                         @odata.Type : 'Edm.String';
        type             : String;
        Function         : Association to one Functions @mandatory;
        SenderFunction   : Association to one InputFunctions;
        ReceiverFunction : Association to one InputFunctions;
        DriverField      : Association to one Fields;
        Checks           : Association to many FunctionChecks
                               on Checks.Function.ID = ID;

}
