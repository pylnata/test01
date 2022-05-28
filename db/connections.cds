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
    Connection,
    Description
} from './commonTypes';
using {
    environment,
} from './commonAspects';


@assert.unique     : {description : [
    environment,
    description,
]}

@cds.odata.valuelist
@UI.Identification : [{Value : connection}]
entity Connections : managed, environment {
    key ID          : GUID @Common.Text : description  @Common.TextArrangement : #TextOnly;
        connection  : Connection;
        description : Description;
}
