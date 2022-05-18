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
    Check,
    Sequence,
    MessageTypes,
    Description
} from './commonTypes';
using {
    environment,
    myCodeList
} from './commonAspects';


@assert.unique : {description : [
    environment,
    description,
]}
@assert.integrity
entity Checks : managed, environment {
    key checkId     : Check;
        seq         : Sequence;
        messageType : Association to one MessageTypes;
        category    : Association to CheckCategories;
        description : Description;
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

entity CheckCategories : myCodeList {
    key code : CheckCategory default '';
}
