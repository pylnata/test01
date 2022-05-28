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


// @assert.unique : {
//     function    : [
//         environment,
//         function,
//     ],
//     description : [
//         environment,
//         description,
//     ]
// }

@cds.odata.valuelist
@UI.Identification : [{Value : function}]
entity Functions : managed, environment {
    key ID                    : GUID @Common.Text : description  @Common.TextArrangement : #TextOnly;
        function              : Function;
        sequence              : Sequence;
        parentFunction        : Association to one ParentFunctions;
        type                  : Association to one FunctionTypes;
        processingType        : Association to one ProcessingTypes;
        businessEventType     : Association to one BusinessEventTypes;
        partition             : Association to one Partitions;
        parentCalculationUnit : Association to one ParentCalculationUnits;
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
entity ParentFunctions        as projection on Functions where(
       type.code = 'CU'
    or type.code = 'DS'
);

@cds.autoexpose  @readonly
@title : 'Result Model Table'
entity ResultModelTables      as projection on Functions where type.code = 'MT';

type FunctionType @(assert.range) : String(10) @title : 'Type' enum {
    Allocation      = 'AL';
    CalculationUnit = 'CU';
    Description     = 'DS';
    ModelTable      = 'MT';
};


entity FunctionTypes : CodeList {
    key code : FunctionType default 'MT';
};


entity ParentCalculationUnits as projection on Functions where type.code = 'CU';

type ProcessingType @(assert.range) : String(10) @title : 'Processing Type' enum {
    subFunction = '';
    Executable  = 'NW';
};

entity ProcessingTypes : CodeList {
    key code : ProcessingType default '';
}

type BusinessEventType @(assert.range) : String(10) @title : 'Business Event Management Type' enum {
    Logging    = '';
    Correction = 'CORRECT';
};

entity BusinessEventTypes : CodeList {
    key code : BusinessEventType default '';
}
