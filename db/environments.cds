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
    Environment,
    Version,
    Description,
    Sequence
} from './commonTypes';
using {Fields} from './fields';
using {Checks} from './checks';
using {
    CurrencyConversions,
    UnitConversions
} from './conversions';
using {Partitions} from './partitions';
using {Functions} from './functions';

@assert.unique     : {
    environment : [
        environment,
        version
    ],
    description : [
        description,
        version
    ]
}
@cds.odata.valuelist
@UI.Identification : [
    {Value : environment},
    {Value : version}
]
entity Environments : managed {
    key ID                              : GUID                                  @Common.Text : description  @Common.TextArrangement : #TextOnly;
        environment                     : Environment                           @mandatory;
        @Common.FieldControl :                                                                 version_fc
        @UI.Hidden           :                                                                 version_hidden
        version                         : Version;
        @UI.Hidden
        virtual version_fc              : Integer;
        virtual version_hidden          : Boolean;
        description                     : Description;
        parent                          : Association to one EnvironmentFolders @title       : 'Parent';
        type                            : Association to one EnvironmentTypes   @title       : 'Type';
        fields                          : Association to many Fields
                                              on fields.environment = $self;
        checks                          : Association to many Checks
                                              on checks.environment = $self;
        currencyConversions             : Association to many CurrencyConversions
                                              on currencyConversions.environment = $self;
        unitConversions                 : Association to many UnitConversions
                                              on unitConversions.environment = $self;
        partitions                      : Association to many Partitions
                                              on partitions.environment = $self;
        functions                       : Association to many Functions
                                              on functions.environment = $self;
        virtual semanticaction          : String;
        virtual target                  : String;
        virtual url                     : String;
        @UI.IsImageURL
        virtual icon                    : String;
        virtual functionLinkDescription : String;
}

@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [
    {Value : environment},
    {Value : version}
]
entity EnvironmentFolders as projection on Environments excluding {
    fields,
    checks,
    currencyConversions,
    partitions,
    functions
} where type.code = 'NODE';

type EnvironmentType @mandatory @(assert.range) : String @title : 'Type' enum {
    Folder      = 'NODE';
    Environment = 'ENV_VER';
};

entity EnvironmentTypes : CodeList {
    key code : EnvironmentType default 'ENV_VER';
}
