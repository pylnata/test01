using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

@cds.odata.valuelist
entity Environments : managed {
    key ID          : UUID @UI.Hidden  @odata.Type : 'Edm.String';
        environment : String ;
        version     : String;
        description : String;
        Checks      : Composition of many Checks
                          on Checks.Environment = $self;
        Fields      : Composition of many Fields
                          on Fields.Environment = $self;
        Functions   : Composition of many Functions
                          on Functions.Environment = $self;
}

@cds.odata.valuelist
entity Fields : managed {
    key ID          : UUID                        @UI.Hidden  @odata.Type : 'Edm.String';
        field       : String;
        type        : String;
        description : String;
        Environment : Association to Environments @mandatory;

}

@cds.odata.valuelist
entity Checks : managed {
    key ID          : UUID                        @odata.Type : 'Edm.String';
        check       : String;
        type        : String;
        description : String;
        Environment : Association to Environments @mandatory;

}

@cds.odata.valuelist
entity Functions : managed {
    key ID          : UUID                            @UI.Hidden  @odata.Type : 'Edm.String';
        function    : String;
        description : String;
        type        : String;
        Environment : Association to one Environments @mandatory;
        ModelTable  : Association to one ModelTables
                          on ModelTable.ID = ID;
        Allocation  : Association to one Allocations
                          on Allocation.ID = ID;
}

entity ModelTables : managed {
    key ID          : UUID                            @odata.Type : 'Edm.String';
        type        : String;
        Environment : Association to one Environments @mandatory;
        Function    : Association to one Functions    @mandatory;
        Fields      : Composition of many ModelTableFields
                          on Fields.ModelTable = $self;
}

entity ModelTableFields : managed {
    key ID          : UUID                            @odata.Type : 'Edm.String';
        Environment : Association to one Environments @mandatory;
        Function    : Association to one Functions    @mandatory;
        ModelTable  : Association to one ModelTables  @mandatory;
        Field       : Association to one Fields       @mandatory;
}

@cds.odata.valuelist
entity InputFunctions as projection on Functions where type = 'MT';

@cds.odata.valuelist
entity Allocations : managed {
    key ID                      : UUID                            @UI.Hidden  @odata.Type : 'Edm.String';
        type                    : String;
        Environment             : Association to one Environments @mandatory;
        Function                : Association to one Functions    @mandatory;
        SenderFunction          : Association to one InputFunctions;
        ReceiverFunction        : Association to one InputFunctions;
        SenderSelectionFields   : Composition of many AllocationSenderSelectionFields
                                      on SenderSelectionFields.Allocation = $self;
        SenderActionFields      : Composition of many AllocationSenderActionFields
                                      on SenderActionFields.Allocation = $self;
        ReceiverSelectionFields : Composition of many AllocationReceiverSelectionFields
                                      on ReceiverSelectionFields.Allocation = $self;
        ReceiverActionFields    : Composition of many AllocationReceiverActionFields
                                      on ReceiverActionFields.Allocation = $self;
        AllocationRules         : Composition of many AllocationRules
                                      on AllocationRules.Allocation = $self;
        Checks                  : Composition of many AllocationChecks
                                      on Checks.Allocation = $self;

}

entity AllocationSenderSelectionFields : managed {
    key ID         : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        Allocation : Association to one Allocations @mandatory;
        Field      : Association to one Fields      @mandatory;
}

entity AllocationSenderActionFields : managed {
    key ID         : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        Allocation : Association to one Allocations @mandatory;
        Field      : Association to one Fields      @mandatory;
}

entity AllocationReceiverSelectionFields : managed {
    key ID         : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        Allocation : Association to one Allocations @mandatory;
        Field      : Association to one Fields      @mandatory;
}

entity AllocationReceiverActionFields : managed {
    key ID         : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        Allocation : Association to one Allocations @mandatory;
        Field      : Association to one Fields      @mandatory;
}

entity AllocationRules : managed {
    key ID             : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        type           : String;
        Allocation     : Association to one Allocations @mandatory;
        DriverField    : Association to one Fields;
        SenderFields   : Composition of many AllocationRuleSenderFields
                             on SenderFields.Rule = $self;
        ReceiverFields : Composition of many AllocationRuleReceiverFields
                             on ReceiverFields.Rule = $self;
}

entity AllocationRuleSenderFields : managed {
    key ID          : UUID                               @UI.Hidden  @odata.Type : 'Edm.String';
        formula     : String;
        group_      : String;
        aggregation : String;
        Rule        : Association to one AllocationRules @mandatory;
        Field       : Association to one Fields          @mandatory;
        Selections  : Composition of many AllocationRuleSenderFieldSelections
                          on Selections.Field = $self;
}

entity AllocationRuleSenderFieldSelections : managed {
    key ID    : UUID                                          @UI.Hidden  @odata.Type : 'Edm.String';
        sign  : String;
        opt   : String;
        low   : String;
        high  : String;
        Field : Association to one AllocationRuleSenderFields @mandatory;
}

entity AllocationRuleReceiverFields : managed {
    key ID          : UUID                               @UI.Hidden  @odata.Type : 'Edm.String';
        formula     : String;
        group_      : String;
        aggregation : String;
        Rule        : Association to one AllocationRules @mandatory;
        Field       : Association to one Fields          @mandatory;
        Selections  : Composition of many AllocationRuleReceiverFieldSelections
                          on Selections.Field = $self;
}

entity AllocationRuleReceiverFieldSelections : managed {
    key ID    : UUID                                            @UI.Hidden  @odata.Type : 'Edm.String';
        sign  : String;
        opt   : String;
        low   : String;
        high  : String;
        Field : Association to one AllocationRuleReceiverFields @mandatory;
}

entity AllocationChecks : managed {
    key ID         : UUID                           @UI.Hidden  @odata.Type : 'Edm.String';
        Allocation : Association to one Allocations @mandatory;
        Check      : Association to one Checks      @mandatory;
}
