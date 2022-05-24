using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

using {myCodeList} from './commonAspects';

type GUID : UUID @odata.Type : 'Edm.String'  @UI.Hidden ;
type Environment : String @title : 'Environment'  @assert.format : '[A-Z,0-9,_]{3}';
type Version : String @title : 'Version'  @assert.format : '(^$|[A-Z,0-9,_]{4})';
type Function : String @title : 'Function'  @assert.format : '[A-Z,0-9,_]{1,5}';
type Field : String @title : 'Field'  @assert.format : '[A-Z,0-9,_]{1,30}';
type Partition : String @title : 'Partition'  @assert.format : '[A-Z,0-9,_]{1,20}';
type Description : String @title : 'Description'  @mandatory  @assert.notNull; //  @Core.Immutable woud bring it up in creation popup as well
type Documentation : LargeString @title : 'Documentation';
type Sequence : Integer @title : 'Sequence'  @mandatory  @assert.notNull;
type Rule : String @title : 'Rule'  @assert.format : '[A-Z,0-9,_]{1,5}';
type ParentRule : Rule @title : 'Parent Rule';
type IncludeInputData : Boolean @title : 'Include original Input Data';
type IncludeInitialResult : Boolean @title : 'Include initial Results';

type MessageType @(assert.range) : String(1) @title : 'Message type' enum {
    Info    = 'I';
    Success = 'S';
    Warning = 'W';
    Error   = 'E';
    Abort   = 'A';
}

entity MessageTypes : myCodeList {
    key code : MessageType default 'I';
}

type Check : String @title : 'Check'  @assert.format : '[A-Z,0-9,_]{1,30}';


type Sfield @(assert.range) : String(18) @title : 'Subset' enum {
    Selection        = 'SEL';
    Action           = 'ACTION';
    SelectionFields  = 'SEL_FIELDS';
    ActionFields     = 'ACTION_FIELDS';
    Sender           = 'SENDER_FIELD_MAP';
    SenderRuleAction = 'SRULE_ACTION';
    SenderRule       = 'SRULE_FIELD_MAP';
}

entity Sfields : myCodeList {
    key code : Sfield;
}


// @cds.autoexpose  @readonly
// aspect MasterData {};

type Group @(assert.range) : String(10) @title : 'Grouping' enum {
    Field   = '';
    Group_  = 'GROUP';
    NotUsed = 'NOT USED';
};

entity Groups : myCodeList {
    key code : Group default '';
}

type Order @(assert.range) : String(10) @title : 'Ordering' enum {
    NoOrder    = '';
    Ascending  = 'ASC';
    Descending = 'DESC';
};

entity Orders : myCodeList {
    key code : Order default '';
}

type Sign @(assert.range) : String(1) @title : 'Sign' enum {
    Include = 'I';
    Exclude = 'E';
}

entity Signs : myCodeList {
    key code : Sign default 'I';
}

type Option @(assert.range) : String(2) @title : 'Option' enum {
    /**
     * Value is equal to the value in field LOW
     */
    Equal              = 'EQ';
    /**
     * Value is not equal to the value in field LOW
     */
    NotEqual           = 'NE';
    /**
     * Value is between the value in field LOW and the value in
     * field HIGH (including the boundaries)
     */
    Between            = 'BT';
    /**
     * Value is not between the value in field LOW and the value in
     * field HIGH (including the boundaries)
     */
    NotBetween         = 'NB';
    /**
     * Value is less than or equals the value in field LOW
     */
    LessThanOrEqual    = 'LE';
    /**
     * Value is greater than the value in field LOW
     */
    GreaterThan        = 'GT';
    /**
     * Value is greater than or equals the value in field LOW
     */
    GreaterThanOrEqual = 'GE';
    /**
     * Value is less than the value in field LOW
     */
    LessThan           = 'LT';
    /**
     * Masked input: Find pattern
     */
    ContainsPattern    = 'CP';
    /**
     * Masked input: Reject pattern
     */
    NotContainsPattern = 'NP';
}

entity Options : myCodeList {
    key code : Option default 'EQ';
}

type ResultHandling @(assert.range) : String(10) @title : 'Result Handling' enum {
    IncludeEnrichedData    = 'ENRICHED';
    IncludeAllData         = 'ALL';
    ErrorOnNotEnrichedData = 'ERROR';
    AbortOnNotEnrichedData = 'ABORT';
}

entity ResultHandlings : myCodeList {
    key code : ResultHandling default 'ENRICHED';
}


type RuleState : Boolean @title : 'State';
type Value : String @title : 'Value';
