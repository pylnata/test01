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
@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [
    {Value : environment},
    {Value : version}
]
entity Environments : managed {
    key ID                     : GUID                                  @Common.Text : description  @Common.TextArrangement : #TextOnly;
        environment            : Environment                           @mandatory;
        version                : Version                               @UI.Hidden   : {$edmJson : {$If : [
            {$Eq : [
                {$Path : 'type_code'},
                'NODE'
            ]},
            true,
            false
        ]}};
        description            : Description;
        parent                 : Association to one EnvironmentFolders @title       : 'Parent';
        type                   : Association to one EnvironmentTypes   @title       : 'Type';
        fields                 : Association to many Fields
                                     on fields.environment = $self;
        checks                 : Association to many Checks
                                     on checks.environment = $self;
        currencyConversions    : Association to many CurrencyConversions
                                     on currencyConversions.environment = $self;
        unitConversions        : Association to many UnitConversions
                                     on unitConversions.environment = $self;
        partitions             : Association to many Partitions
                                     on partitions.environment = $self;
        functions              : Association to many Functions
                                     on functions.environment = $self;
        virtual url            : String;
        virtual icon           : String;
        virtual gotoSubfolders : String                                @title       : 'Go to';
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
