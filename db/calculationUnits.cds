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
    Description,
    Process,
    Activity,
    Report,
    Element,
    Sequence
} from './commonTypes';
using {function} from './commonAspects';

entity CalculationUnits : managed, function {
    key ID        : GUID @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        dummy     : String;
        // processes : Composition of many CUProcessTemplates
        //                 on processes.CU = $self;
}

// entity CUs : managed, function {
//     key ID        : GUID @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
//         dummy     : String;
//         processes : Composition of many CUProcessTemplates
// }

// entity CUProcessTemplates : managed, function {
//         CU          : Association to one CUs;
//     key ID          : GUID;
//         process     : Process;
//         sequence    : Sequence default 10;
//         type        : Association to one ProcessTypes;
//         description : Description;
//         activities: 

// }

// entity ProcessTypes : CodeList {
//     key code : ProcessType default 'Simulation';

// }

// type ProcessType @(assert.range) : String @title : 'Conversion Category' enum {
//     Run        = 'RUN';
//     Simulation = 'Simulation';
// }
