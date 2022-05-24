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
using {Functions} from './functions';

// @assert.unique : {
//     environment : [
//         environment,
//         version
//     ],
//     description : [
//         description,
//         version
//     ]
// }

@cds.odata.valuelist
entity Environments : managed {
    key ID          : GUID;
        environment : Environment;
        version     : Version;
        sequence    : Sequence;
        description : Description;
        parent      : Association to one EnvironmentFolders @title       : 'Parent';
        type        : Association to one EnvironmentTypes   @title       : 'Type';
        fields      : Association to many Fields
                          on fields.environment = $self;
        checks      : Association to many Checks
                          on checks.environment = $self;
        functions   : Association to many Functions
                          on functions.environment = $self;
}

@cds.autoexpose  @readonly
entity EnvironmentFolders as projection on Environments {
    key ID,
        description
} where type.code = 'NODE';

type EnvironmentType @mandatory @(assert.range) : String @title : 'Type' enum {
    Folder      = 'NODE';
    Environment = 'ENV_VER';
};

entity EnvironmentTypes : CodeList {
    key code : EnvironmentType default 'ENV_VER';
}
