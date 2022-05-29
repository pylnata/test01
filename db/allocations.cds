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
    Description,
    Check,
    Field,
    Function,
    Sequence,
    IncludeInputData,
    IncludeInitialResult,
    ResultHandlings,
    Rule,
    IsActive,
    ParentRule,
} from './commonTypes';
using {
    function,
    keyFunction,
    field,
    formulaOrder,
    selection,
    formulaGroupOrder,
} from './commonAspects';
using {
    Functions,
    FunctionChecks
} from './functions';
using {
    Fields,
    FieldType
} from './fields';
using {Checks} from './checks';

using {
    EnvironmentFunctions,
    EnvironmentFields,
    EnvironmentChecks,
    EnvironmentPartitions
} from './commonEntities';

entity Allocations : managed, function {
    key ID                      : UUID                                              @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type                    : Association to one AllocationTypes                @title       : 'Type';
        valueAdjustment         : Association to one AllocationValueAdjustments     @title       : 'Value Adjustment';
        includeInputData        : IncludeInputData default false;
        resultHandling          : Association to one ResultHandlings                @title       : 'Result Handling';
        includeInitialResult    : IncludeInitialResult default false;
        cycleFlag               : CycleFlag default false;
        cycleMaximum            : CycleMaximum default 0;
        cycleIterationField     : Association to one AllocationCycleIterationFields @title       : 'Cycle Iteration Field';
        cycleAggregation        : Association to one AllocationCycleAggregations    @title       : 'Cycle Aggregation';
        termFlag                : TermFlag default false;
        termIterationField      : Association to one AllocationTermIterationFields  @title       : 'Term Iteration Field';
        termYearField           : Association to one AllocationTermYearFields       @title       : 'Term Year Field';
        termField               : Association to one AllocationTermFields           @title       : 'Term Field';
        termProcessing          : Association to one AllocationTermProcessings      @title       : 'Term Processing';
        termYear                : TermYear;
        termMinimum             : TermMinimum;
        termMaximum             : TermMaximum;
        senderFunction          : Association to one AllocationInputFunctions       @title       : 'Sender Input';
        senderViews             : Composition of many AllocationSenderViews
                                      on senderViews.allocation = $self             @title       : 'Sender View';
        receiverFunction        : Composition of one AllocationInputFunctions       @title       : 'Receiver Input';
        receiverViews           : Composition of many AllocationReceiverViews
                                      on receiverViews.allocation = $self           @title       : 'Receiver View';
        resultFunction          : Composition of one AllocationResultFunctions      @title       : 'Result Model Table';
        earlyExitCheck          : Association to one AllocationEarlyExitChecks      @title       : 'Early Exit Check';
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

@cds.odata.valuelist
entity AllocationInputFunctions         as projection on Functions as F{
    ID,
    function,
    description,
    type
} where (type.code in (
    'MT', 'AL')
    // and F.environment =          in (
    //         select field.ID from AllocationActionFields as L
    //         where
    //             F.environment.ID = L.allocation.environment.ID
    //     )
);

entity AllocationSenderViews : managed, function, formulaOrder {
    key ID         : GUID;
        allocation : Association to one Allocations;
        field      : Association to one Fields @title : 'Field';
        selections : Composition of many AllocationSenderViewSelections
                         on selections.field = $self;
}

entity AllocationSenderViewSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to one AllocationSenderViews;
}

entity AllocationReceiverViews : managed, function, formulaOrder {
    key ID         : GUID;
        allocation : Association to one Allocations;
        field      : Association to one Fields @title : 'Field';
        selections : Composition of many AllocationReceiverViewSelections
                         on selections.field = $self;
}

entity AllocationReceiverViewSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to one AllocationReceiverViews;
}

@cds.odata.valuelist
entity AllocationResultFunctions        as projection on Functions where type.code = 'MT';

entity AllocationOffsets : managed, function {
    key ID          : GUID;
        allocation  : Association to one Allocations @mandatory;
        field       : Association to one Fields      @mandatory;
        offsetField : Association to one Fields      @mandatory;
}

entity AllocationDebitCredits : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @mandatory;
        debitSign  : DebitSign;
        creditSign : CreditSign;
        sequence   : Sequence;
}

entity AllocationChecks : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        check      : Association to one Checks      @title : 'Checks'  @mandatory;
}

type AllocationType @(assert.range) : String(10) @title : 'Type' enum {
    Allocation                          = 'ALLOC';
    OffsetAllocation                    = 'ALLOCO';
    AllocationWithDetailedOffsetRecords = 'ALLOCDO';
}

entity AllocationTypes : CodeList {
    key code : AllocationType default 'ALLOC';
}

type AllocationValueAdjustment @(assert.range) : String(10) @title : 'Value Adjustment' enum {
    NoAdjustment            = '';
    LastRow                 = 'LR';
    BiggestValueRow         = 'BV';
    AbsoluteBiggestValueRow = 'AV';
}

entity AllocationValueAdjustments : CodeList {
    key code : AllocationValueAdjustment default '';
}

type AllocationTermProcessing @(assert.range) : String(10) @title : 'Term Processing' enum {
    None       = '';
    Cumulation = 'CU';
    LastPeriod = 'LP';
}

entity AllocationTermProcessings : CodeList {
    key code : AllocationTermProcessing default '';
}


type AllocationCycleAggregation @(assert.range) : String(10) @title : 'Cycle Aggregation' enum {
    None        = '';
    Aggregation = 'AG';
}

entity AllocationCycleAggregations : CodeList {
    key code : AllocationCycleAggregation default '';
}

entity AllocationSelectionFields : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @title : 'Field'  @mandatory;
}

entity AllocationActionFields : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @title : 'Field'  @mandatory;
}

entity AllocationReceiverSelectionFields : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @title : 'Field'  @mandatory;
}

entity AllocationReceiverActionFields : managed, function {
    key ID         : GUID;
        allocation : Association to one Allocations @mandatory;
        field      : Association to one Fields      @title : 'Field'  @mandatory;
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

@cds.autoexpose
@cds.odata.valuelist
entity AllocationTermIterationFields    as projection on Fields where(
        class.code = ''
    and type.code  = 'KYF'
);

@cds.autoexpose
@cds.odata.valuelist
entity AllocationTermYearFields         as projection on Fields where(
        class.code =  ''
    and type.code  =  'CHA'
    and dataLength >= 4
);

@cds.autoexpose
@cds.odata.valuelist
entity AllocationTermFields             as projection on Fields where(
        class.code =  ''
    and type.code  =  'CHA'
    and dataLength >= 4
);

type TermField : Field @title : 'Term Field';
type TermYear : String @title : 'Term Year';
type TermMinimum : String @title : 'Term Minimum';
type TermMaximum : String @title : 'Term Maximum';

@cds.autoexpose
@cds.odata.valuelist
entity AllocationEarlyExitChecks        as projection on Checks;

@cds.autoexpose
@cds.odata.valuelist
entity AllocationRules : managed, function {
    key ID                : GUID;
        allocation        : Association to one Allocations;
        sequence          : Sequence;
        rule              : Rule;
        description       : Description;
        isActive          : IsActive default true;
        type              : Association to one AllocationRuleTypes;
        senderRule        : Association to one AllocationSenderRules            @title : 'Sender Rule';
        senderShare       : SenderShare default 100;
        senderValueFields : Composition of many AllocationRuleSenderValueFields
                                on senderValueFields.rule = $self               @mandatory;
        method            : Association to one AllocationRuleMethods            @title : 'Mapping Method';
        senderViews       : Composition of many AllocationRuleSenderViews
                                on senderViews.rule = $self                     @title : 'Sender View';
        distributionBase  : DistributionBase;
        parentRule        : Association to one AllocationRules                  @title : 'Parent';
        receiverRule      : Association to one AllocationReceiverRules          @title : 'Receiver Rule';
        scale             : Association to one AllocationRuleScales             @title : 'Scale';
        driverResultField : Association to one AllocationRuleDriverResultFields @title : 'Driver Field';
}

entity AllocationRuleSenderValueFields : managed, function {
    key ID    : GUID;
        rule  : Association to one AllocationRules;
        field : Association to one AllocationActionFields @mandatory;
}

entity AllocationRuleSenderViews : managed, function, formulaGroupOrder {
    key ID         : GUID;
        rule       : Association to one AllocationRules @mandatory;
        field      : Association to one Fields          @title : 'Field'  @mandatory;
        selections : Composition of many AllocationRuleSenderFieldSelections
                         on selections.field = $self;
}

entity AllocationRuleSenderFieldSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to AllocationRuleSenderViews @mandatory;
}

entity AllocationRuleReceiverViews : managed, function, formulaGroupOrder {
    key ID         : GUID;
        rule       : Association to one AllocationRules @mandatory;
        field      : Association to one Fields          @title : 'Field'  @mandatory;
        selections : Composition of many AllocationRuleReceiverFieldSelections
                         on selections.field = $self;
}

entity AllocationRuleReceiverFieldSelections : managed, function, selection {
    key ID    : GUID;
        field : Association to AllocationRuleReceiverViews @mandatory;
}

type AllocationRuleType @(assert.range) : String(10) @title : 'Rule Type' enum {
    Direct           = 'DIRECT';
    Indirect         = 'INDIRECT';
    IndirectDetailed = 'INDIRECTD';
}

entity AllocationRuleTypes : CodeList {
    key code : AllocationRuleType default 'DIRECT';
}


type AllocationRuleMethod @(assert.range) : String(10) @title : 'Mapping' enum {
    Precise   = 'PR';
    Imprecise = 'IM';
}

entity AllocationRuleMethods : CodeList {
    key code : AllocationRuleMethod default 'PR';
}


type AllocationSenderRule @(assert.range) : String(10) @title : 'Sender Rule' enum {
    PostedAmounts = 'POST_AM';
}

entity AllocationSenderRules : CodeList {
    key code : AllocationSenderRule default 'POST_AM';
}


type AllocationReceiverRule @(assert.range) : String(10) @title : 'Receiver Rule' enum {
    VariablePortions    = 'VAR_POR';
    VariablePercentages = 'VAR_PER';
    VariableFactors     = 'VAR_FCT';
    VariableEven        = 'VAR_EVEN';
}

entity AllocationReceiverRules : CodeList {
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

entity AllocationRuleScales : CodeList {
    key code : AllocationRuleScale default '';
}

@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [{Value : field}]
entity AllocationRuleDriverResultFields as projection on Fields as F where(
        class.code =  ''
    and type.code  =  'KYF'
    and ID         in (
            select field.ID from AllocationActionFields as L
            where
                F.environment.ID = L.allocation.environment.ID
        )
    );

@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [{Value : field}]
entity AllocationCycleIterationFields   as projection on Fields as F where(
        class.code =  ''
    and type.code  =  'KYF'
    and ID         in (
            select field.ID from AllocationActionFields as L
            where
                F.environment.ID = L.allocation.environment.ID
        )
    );
