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
    functionField,
    selection,
    formulaOrderAggregation,
    myCodeList
} from './commonAspects';
using {
    Functions,
    FunctionFields,
    FunctionChecks
} from './functions';
using {Fields} from './fields';
using {Checks} from './checks';


entity Allocations : managed, function {
    key ID                         : GUID;
        type                       : Association to one AllocationTypes               @title : 'Type';
        valueAdjustment            : Association to one AllocationValueAdjustments    @title : 'Value Adjustment';
        includeInputData           : IncludeInputData default false;
        resultHandling             : Association to one ResultHandlings               @title : 'Result Handling';
        includeInitialResult       : IncludeInitialResult default false;
        cycleFlag                  : CycleFlag default false;
        cycleMaximum               : CycleMaximum default 0;
        cycleIterationField        : Association to one Fields                        @title : 'Cycle Iteration Field';
        cycleAggregation           : Association to one AllocationCycleAggregations   @title : 'Cycle Aggregation';
        termFlag                   : TermFlag default false;
        termIterationField         : Association to one AllocationTermIterationFields @title : 'Term Iteration Field';
        termYearField              : Association to one AllocationTermYearFields      @title : 'Term Year Field';
        termField                  : Association to one AllocationTermFields          @title : 'Term Field';
        termProcessing             : Association to one AllocationTermProcessings     @title : 'Term Processing';
        termYear                   : TermYear;
        termMinimum                : TermMinimum;
        termMaximum                : TermMaximum;
        senderInputFunction        : Association to one SenderInputFunctions          @title : 'Sender Input Function';
        receiverInputFunction      : Association to one ReceiverInputFunctions        @title : 'Receiver Input Function';
        ResultFunction             : Association to one ResultFunctions               @title : 'Result Model Table';
        earlyExitCheck             : Association to one EarlyExitChecks               @title : 'Early Exit Check';
        senderFunctionSelections   : Composition of many FunctionFields;
        receiverFunctionSelections : Composition of many FunctionFields;
        selectionFields            : Composition of many FunctionFields;
        actionFields               : Composition of many FunctionFields;
        rSelectionFields           : Composition of many FunctionFields;
        rActionFields              : Composition of many FunctionFields;
        rules                      : Composition of many AllocationRules;
        offsets                    : Composition of many AllocationOffsets;
        debitCredits               : Composition of many AllocationDebitCredits;
        checks                     : Composition of many FunctionChecks;
}

entity AllocationRules : managed, function {
    key ID               : GUID;
        rule             : Rule;
        sequence         : Sequence;
        type             : Association to one AllocationRuleTypes;
        alMethod         : Association to one AllocationRuleMethods;
        ruleState        : RuleState default true;
        parentRule       : Association to one ParentAllocationRules;
        senderRule       : Association to one AllocationSenderRules;
        receiverRule     : Association to one AllocationReceiverRules;
        distributionBase : DistributionBase;
        scale            : Association to one AllocationRuleScales;
        senderShare      : SenderShare default 100;
        driverField      : Association to one DriverFields;
        allocation       : Association to one Allocations;
        fields           : Association to many AllocationRuleFields;
}

entity AllocationRuleFields : managed, functionField, formulaOrderAggregation {
    key ID         : GUID;
        rule       : Association to one AllocationRules @mandatory;
        Selections : Association to many AllocationRuleFieldSelections;
}

entity AllocationRuleFieldSelections : managed, functionField, selection {
    key ID    : GUID;
        field : Association to AllocationRuleFields @mandatory;
}

entity AllocationOffsets : managed, function {
    key ID          : GUID;
        field       : Association to one Fields;
        offsetField : Association to one Fields;
}

entity AllocationDebitCredits : managed, function {
    key ID         : GUID;
        field      : Association to one Fields;
        debitSign  : DebitSign;
        creditSign : CreditSign;
        sequence   : Sequence;
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

entity SenderInputFunctions          as projection on Functions;
entity ReceiverInputFunctions        as projection on Functions;
entity ResultFunctions               as projection on Functions;
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
entity ParentAllocationRules         as projection on AllocationRules;
entity DriverFields                  as projection on Fields;
