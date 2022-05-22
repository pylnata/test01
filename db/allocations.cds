using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
    Check,
    Field,
    Function,
    Sequence,
    IncludeInputData,
    IncludeInitialResult,
    ResultHandlings,
    Rule,
    RuleState,
    ParentRule,
} from './commonTypes';
using {
    function,
    keyFunction,
    field,
    formulaOrder,
    selection,
    formulaGroupOrder,
    myCodeList
} from './commonAspects';
using {
    Functions,
    FunctionChecks
} from './functions';
using {Fields} from './fields';
using {Checks} from './checks';

using {
    EnvironmentFunctions,
    EnvironmentFields,
    EnvironmentChecks,
    EnvironmentPartitions
} from './commonEntities';

entity Allocations : managed, function {
    key ID                      : UUID;
        type                    : Association to one AllocationTypes               @title : 'Type';
        valueAdjustment         : Association to one AllocationValueAdjustments    @title : 'Value Adjustment';
        includeInputData        : IncludeInputData default false;
        resultHandling          : Association to one ResultHandlings               @title : 'Result Handling';
        includeInitialResult    : IncludeInitialResult default false;
        cycleFlag               : CycleFlag default false;
        cycleMaximum            : CycleMaximum default 0;
        cycleIterationField     : Association to one Fields                        @title : 'Cycle Iteration Field';
        cycleAggregation        : Association to one AllocationCycleAggregations   @title : 'Cycle Aggregation';
        termFlag                : TermFlag default false;
        termIterationField      : Association to one AllocationTermIterationFields @title : 'Term Iteration Field';
        termYearField           : Association to one AllocationTermYearFields      @title : 'Term Year Field';
        termField               : Association to one AllocationTermFields          @title : 'Term Field';
        termProcessing          : Association to one AllocationTermProcessings     @title : 'Term Processing';
        termYear                : TermYear;
        termMinimum             : TermMinimum;
        termMaximum             : TermMaximum;
        senderFunction          : Association to one InputFunctions                @title : 'Sender Input';
        senderViews             : Composition of many SenderViews
                                      on senderViews.allocation = $self            @title : 'Sender View';
        receiverFunction        : Association to one InputFunctions                @title : 'Receiver Input';
        receiverViews           : Composition of many ReceiverViews
                                      on receiverViews.allocation = $self          @title : 'Receiver View';
        resultFunction          : Association to one ResultFunctions               @title : 'Result Model Table';
        earlyExitCheck          : Association to one EarlyExitChecks               @title : 'Early Exit Check';
        selectionFields         : Composition of many AllocationSelectionFields
                                      on selectionFields.allocation = $self;
        actionFields            : Composition of many AllocationActionFields
                                      on actionFields.allocation = $self;
        receiverSelectionFields : Composition of many AllocationReceiverSelectionFields
                                      on receiverSelectionFields.allocation = $self;
        receiverActionFields    : Composition of many AllocationReceiverActionFields
                                      on receiverActionFields.allocation = $self;
        rules                   : Composition of many AllocationRules
                                      on rules.allocation = $self;
        offsets                 : Composition of many AllocationOffsets
                                      on offsets.allocation = $self;
        debitCredits            : Composition of many AllocationDebitCredits
                                      on debitCredits.allocation = $self;
        checks                  : Composition of many AllocationChecks
                                      on checks.allocation = $self;
}

entity InputFunctions                as projection on Functions where type.code in (
    'MT', 'AL');

entity SenderViews : managed, function, formulaOrder {
    key ID         : GUID;
        allocation : Association to one Allocations;
        field      : Association to one Fields @title : 'Field';
        selections : Composition of many SenderViewSelections
                         on selections.field = $self;
}

entity SenderViewSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to one SenderViews;
}

entity ReceiverViews : managed, function, formulaOrder {
    key ID         : GUID;
        allocation : Association to one Allocations;
        field      : Association to one Fields @title : 'Field';
        selections : Composition of many ReceiverViewSelections
                         on selections.field = $self;
}

entity ReceiverViewSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to one ReceiverViews;
}

entity ResultFunctions               as projection on Functions where type.code = 'MT';

entity AllocationOffsets : managed {
    key ID          : GUID;
        allocation  : Association to one Allocations @mandatory;
        field       : Association to one Fields      @mandatory;
        offsetField : Association to one Fields      @mandatory;
}

entity AllocationDebitCredits : managed {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
        debitSign  : DebitSign;
        creditSign : CreditSign;
        sequence   : Sequence;
}

entity AllocationChecks : managed {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        check      : Association to one Checks      @mandatory;
}

type AllocationType @(assert.range) : String(10) @title : 'Type' enum {
    Allocation                          = 'ALLOC';
    OffsetAllocation                    = 'ALLOCO';
    AllocationWithDetailedOffsetRecords = 'ALLOCDO';
}

entity AllocationTypes : myCodeList {
    key code : AllocationType default 'ALLOC';
}

type AllocationValueAdjustment @(assert.range) : String(10) @title : 'Value Adjustment' enum {
    NoAdjustment            = '';
    LastRow                 = 'LR';
    BiggestValueRow         = 'BV';
    AbsoluteBiggestValueRow = 'AV';
}

entity AllocationValueAdjustments : myCodeList {
    key code : AllocationValueAdjustment default '';
}

type AllocationTermProcessing @(assert.range) : String(10) @title : 'Term Processing' enum {
    None       = '';
    Cumulation = 'CU';
    LastPeriod = 'LP';
}

entity AllocationTermProcessings : myCodeList {
    key code : AllocationTermProcessing default '';
}


type AllocationCycleAggregation @(assert.range) : String(10) @title : 'Cycle Aggregation' enum {
    None        = '';
    Aggregation = 'AG';
}

entity AllocationCycleAggregations : myCodeList {
    key code : AllocationCycleAggregation default '';
}

entity AllocationSelectionFields {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
}

entity AllocationActionFields {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
}

entity AllocationReceiverSelectionFields {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
}

entity AllocationReceiverActionFields {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
}

type OffsetField : Field @title : 'Offset Field';
type DistributionBase : String @title : 'Distribution Base';

type SenderShare : Decimal @title : 'Sender Share'  @assert.range : [
    0,
    100
];

type DriverField : Field @title : 'Driver Result Field';
type DebitSign : String @title : 'Debit Sign';
type CreditSign : String @title : 'Credit Sign';
type CycleFlag : Boolean @title : 'Is Cycle';
type CycleMaximum : String @title : 'Cycle Maximum';
type CycleIterationField : Field @title : 'Cycle Iteration Field';
type TermFlag : Boolean @title : 'Is Term';

entity AllocationTermIterationFields as projection on Fields where(
        class.code = ''
    and type.code  = 'KYF'
);

entity AllocationTermYearFields      as projection on Fields where(
        class.code =  ''
    and type.code  =  'CHA'
    and dataLength >= 4
);

@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [{Value : field}]
entity AllocationTermFields          as projection on Fields where(
        class.code =  ''
    and type.code  =  'CHA'
    and dataLength >= 4
);

type TermField : Field @title : 'Term Field';
type TermYear : String @title : 'Term Year';
type TermMinimum : String @title : 'Term Minimum';
type TermMaximum : String @title : 'Term Maximum';
entity EarlyExitChecks               as projection on Checks;

entity AllocationRules : managed {
    key ID               : GUID;
        allocation       : Association to one Allocations;
        rule             : Rule;
        sequence         : Sequence;
        type             : Association to one AllocationRuleTypes;
        alMethod         : Association to one AllocationRuleMethods;
        ruleState        : RuleState default true;
        parentRule       : Association to one AllocationRules            @title : 'Parent';
        senderRule       : Association to one AllocationSenderRules      @title : 'Sender Rule';
        receiverRule     : Association to one AllocationReceiverRules    @title : 'Receiver Rule';
        distributionBase : DistributionBase;
        scale            : Association to one AllocationRuleScales       @title : 'Scale';
        senderShare      : SenderShare default 100;
        driverField      : Association to one AllocationRuleDriverFields @title : 'Driver Field';
        fields           : Association to many AllocationRuleFields
                               on fields.rule = $self;
}

entity AllocationRuleFields : managed, formulaGroupOrder {
    key ID         : GUID;
        rule       : Association to one AllocationRules @mandatory;
        selections : Composition of many AllocationRuleFieldSelections
                         on selections.field = $self;
}

entity AllocationRuleFieldSelections : managed, selection {
    key ID    : GUID;
        field : Association to AllocationRuleFields @mandatory;
}

type AllocationRuleType @(assert.range) : String(10) @title : 'Rule Type' enum {
    Direct           = 'DIRECT';
    Indirect         = 'INDIRECT';
    IndirectDetailed = 'INDIRECTD';
}

entity AllocationRuleTypes : myCodeList {
    key code : AllocationRuleType default 'DIRECT';
}


type AllocationRuleMethod @(assert.range) : String(10) @title : 'Mapping' enum {
    Precise   = 'PR';
    Imprecise = 'IM';
}

entity AllocationRuleMethods : myCodeList {
    key code : AllocationRuleMethod default 'PR';
}


type AllocationSenderRule @(assert.range) : String(10) @title : 'Sender Rule' enum {
    PostedAmounts = 'POST_AM';
}

entity AllocationSenderRules : myCodeList {
    key code : AllocationSenderRule default 'POST_AM';
}


type AllocationReceiverRule @(assert.range) : String(10) @title : 'Receiver Rule' enum {
    VariablePortions    = 'VAR_POR';
    VariablePercentages = 'VAR_PER';
    VariableFactors     = 'VAR_FCT';
    VariableEven        = 'VAR_EVEN';
}

entity AllocationReceiverRules : myCodeList {
    key code : AllocationReceiverRule default 'VAR_POR';
}

type AllocationRuleScale @(assert.range) : String(10) @title : 'Scale' enum {
    NoScale                    = '';
    Standard                   = 'STANDARD';
    AbsoluteValue              = 'ABSOLUTE';
    NegativeToZero             = 'NEG_ZERO';
    SmallestNegativeToZero     = 'SNEG_ZERO';
    SmallestNegativeZeroToZero = 'SNEG_ZEROZ';
}

entity AllocationRuleScales : myCodeList {
    key code : AllocationRuleScale default '';
}

entity AllocationRuleDriverFields    as projection on Fields;
