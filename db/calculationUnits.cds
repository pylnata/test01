using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

using {GUID} from './commonTypes';
using {function} from './commonAspects';

entity CalculationUnits : managed, function {
    key ID : GUID @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
}
