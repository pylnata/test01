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
    Value,
    Sequence,
    Description,
    Conversion,
} from './commonTypes';
using {environment} from './commonAspects';
using {Fields} from './fields';
using {Connections} from './connections';

@assert.unique     : {
    currencyConversion : [
        environment,
        currencyConversion
    ],
    description        : [
        environment,
        description
    ]
}
@cds.odata.valuelist
@UI.Identification : [{Value : currencyConversion}]
entity CurrencyConversions : managed, environment {
    key ID                      : GUID                                        @Common.Text : description  @Common.TextArrangement : #TextOnly;
        currencyConversion      : Conversion;
        description             : Description;
        category                : Association to one ConversionCategories;
        method                  : Association to one ConversionMethods        @title       : 'Method';
        bidAskType              : Association to one ConversionBidAskTypes    @title       : 'Bid Ask Type';
        marketDataArea          : MarketDataArea;
        type                    : ConversionType;
        lookup                  : Association to one ConversionLookups        @title       : 'Lookup';
        errorHandling           : Association to one ConversionErrorHandlings @title       : 'Error Handling';
        accuracy                : Association to one ConversionAccuracies     @title       : 'Accuracy';
        dateFormat              : Association to one ConversionDateFormats    @title       : 'Date Format';
        steps                   : Association to one ConversionSteps          @title       : 'Steps';
        configurationConnection : Association to one Connections              @title       : 'Configuration Table';
        rateConnection          : Association to one Connections              @title       : 'Rates Table';
        prefactorConnection     : Association to one Connections              @title       : 'Prefactors Table';
}

@assert.unique     : {
    unitConversion : [
        environment,
        unitConversion
    ],
    description    : [
        environment,
        description
    ]
}
@cds.odata.valuelist
@UI.Identification : [{Value : unitConversion}]
entity UnitConversions : managed, environment {
    key ID                  : GUID                                        @Common.Text : description  @Common.TextArrangement : #TextOnly;
        unitConversion      : Conversion;
        description         : Description;
        errorHandling       : Association to one ConversionErrorHandlings @title       : 'Error Handling';
        rateConnection      : Association to one Connections              @title       : 'Rates Table';
        dimensionConnection : Association to one Connections              @title       : 'Dimension Table';
}

type ConversionCategory @(assert.range) : String @title : 'Conversion Category' enum {
    Currency = 'CURRENCY';
    Unit     = 'UNIT';
}

entity ConversionCategories : managed {
    key code : ConversionCategory default 'CURRENCY';
}

type ConversionMethod @(assert.range) : String @title : '' enum {
    Erp     = 'ERP';
    Banking = 'BANKING';
}

entity ConversionMethods : managed {
    key code : Conversion default 'ERP';
}

type ConversionBidAskType @(assert.range) : String @title : '' enum {
    Bid = 'BID';
    Ask = 'ASK';
    Mid = 'MID';
}

entity ConversionBidAskTypes : managed {
    key code : Conversion default 'MID';
}

type ConversionLookup @(assert.range) : String @title : '' enum {
    Regular = 'Regular';
    Reverse = 'Reverse';
}

entity ConversionLookups : managed {
    key code : Conversion default 'Regular';
}

type ConversionErrorHandling @(assert.range) : String @title : '' enum {
    Fail    = 'fail on error';
    ![Null] = 'set to null';
    Keep    = 'keep unconverted';
}

entity ConversionErrorHandlings : managed {
    key code : Conversion default 'fail on error';
}

type ConversionAccuracy @(assert.range) : String @title : '' enum {
    Compatibility = 'compatibility';
    Highest       = 'highest';
}

entity ConversionAccuracies : managed {
    key code : Conversion default '';
}

type ConversionDateFormat @(assert.range) : String @title : '' enum {
    Auto     = 'auto detect';
    Normal   = 'normal';
    Inverted = 'inverted';
}

entity ConversionDateFormats : managed {
    key code : ConversionDateFormat default 'auto detect';
}

type ConversionStep @(assert.range) : String @title : '' enum {
    Shift                      = 'shift';
    Convert                    = 'convert';
    Round                      = 'round';
    ShiftBack                  = 'shift_back';
    ShiftConvert               = 'shift,convert';
    ShiftRound                 = 'shift,round';
    ShiftShiftBack             = 'shift,shift_back';
    ShiftConvertRound          = 'shift,convert,round';
    ShiftConvertShiftBack      = 'shift,convert,shift_back';
    ShiftRoundShiftBack        = 'shift,round,shift_back';
    ShiftConvertRoundShiftBack = 'shift,convert,round,shift_back';
}

entity ConversionSteps : managed {
    key code : ConversionStep default 'shift,convert';
}

type ConversionType : String @title : 'Conversion Type'  @assert.format : '[A-Z,0-9,_]{1,4}';
type MarketDataArea : String @title : 'Market Data Area'  @assert.format : '[A-Z,0-9,_]{1,4}';
