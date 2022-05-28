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
    Check,
    Sequence,
    MessageTypes,
    Description
} from './commonTypes';
using {
    environment,
    selection,
} from './commonAspects';

using {Fields} from './fields';

@assert.unique : {description : [
    environment,
    description,
]}
@cds.odata.valuelist
@UI.Identification : [{Value : check}]
entity Checks : managed, environment {
    key ID          : GUID @Common.Text : description  @Common.TextArrangement : #TextOnly;
        check       : Check;
        messageType : Association to one MessageTypes;
        category    : Association to CheckCategories;
        description : Description;
        fields      : Composition of many CheckFields
                          on fields.check = $self;
}

entity CheckFields : managed {
    key ID         : GUID;
        check      : Association to one Checks @mandatory;
        field      : Association to one Fields @mandatory;
        selections : Composition of many CheckSelections
                         on selections.field = $self;
}

entity CheckSelections : managed, selection {
    key ID    : GUID;
        field : Association to one CheckFields;

}

type CheckCategory @(assert.range) : String(10) @title : 'Check Category' enum {
    /**
     * Including Check
     */
    Including           = '';
    /**
     * Excluding Check
     */
    Excluding           = 'EX';
    /**
     * Master Data Check
     */
    MasterData          = 'MD';
    /**
     * Master Data or Initial Value Check
     */
    MasterDataOrInitial = 'MDI';
}

entity CheckCategories : CodeList {
    key code : CheckCategory default '';
}
