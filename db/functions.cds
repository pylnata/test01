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
    Function,
    Sequence,
    Sfield,
    Description,
    Documentation
} from './commonTypes';
using {
    environment,
    field,
    function,
} from './commonAspects';
using {Fields} from './fields';
using {Checks} from './checks';
using {Partitions} from './partitions';
using {Allocations} from './allocations';
using {CalculationUnits} from './calculationUnits';
using {ModelTables} from './modelTables';


@assert.unique     : {
    function    : [
        environment,
        function,
    ],
    description : [
        environment,
        description,
    ]
}
@cds.odata.valuelist
@UI.Identification : [{Value : function}]
entity Functions : managed, environment {
    key ID                    : GUID                                              @Common.Text : description  @Common.TextArrangement : #TextOnly;
        function              : Function;
        sequence              : Sequence default 10;
        parent                : Association to one FunctionParents                @title       : 'Parent';
        type                  : Association to one FunctionTypes                  @title       : 'Type';
        processingType        : Association to one FunctionProcessingTypes        @title       : 'Processing Type';
        businessEventType     : Association to one FunctionBusinessEventTypes     @title       : 'Business Event Type';
        partition             : Association to one Partitions                     @title       : 'Partition';
        parentCalculationUnit : Association to one FunctionParentCalculationUnits @title       : 'Parent Calculation Unit';
        description           : Description;
        documentation         : Documentation;
// Allocation            : Association to one Allocations;
// Description           : Association to one Descriptions;
// ModelTable            : Association to one ModelTables;
}

aspect FunctionChecks : managed, function {
    key ID : GUID;
    check  : Association to one Checks;
}

@cds.autoexpose  @readonly
@title : 'Parent Function'
entity FunctionParents                as projection on Functions where(
       type.code = 'CU'
    or type.code = 'DS'
);

@cds.autoexpose  @readonly
@title : 'Result Model Table'
entity ResultModelTables              as projection on Functions where type.code = 'MT';

type FunctionType @(assert.range) : String(10) @title : 'Type' enum {
    Allocation      = 'AL';
    CalculationUnit = 'CU';
    Description     = 'DS';
    ModelTable      = 'MT';
};


entity FunctionTypes : CodeList {
    key code : FunctionType default 'MT';
};


entity FunctionParentCalculationUnits as projection on Functions where type.code = 'CU';

type ProcessingType @(assert.range) : String(10) @title : 'Processing Type' enum {
    subFunction = '';
    Executable  = 'NW';
};

entity FunctionProcessingTypes : CodeList {
    key code : ProcessingType default '';
}

type BusinessEventType @(assert.range) : String(10) @title : 'Business Event Management Type' enum {
    Logging    = '';
    Correction = 'CORRECT';
};

entity FunctionBusinessEventTypes : CodeList {
    key code : BusinessEventType default '';
}
