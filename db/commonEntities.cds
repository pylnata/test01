using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';


using {Environments} from './environments';
using {Functions} from './functions';
using {Fields} from './fields';
using {Checks} from './checks';
using {Partitions} from './partitions';
using {GUID} from './commonTypes';

entity ConnectionEnvironments : managed {
    key connection  : Integer;
        environment : GUID;
}

entity EnvironmentFunctions  as projection on Functions;
entity EnvironmentFields     as projection on Fields;
entity EnvironmentChecks     as projection on Checks;
entity EnvironmentPartitions as projection on Partitions;

annotate sap.common.CodeList with @UI.TextArrangement : #TextOnly;