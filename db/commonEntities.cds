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

// !! Uncommenting the 4 entities below and commenting the 4 above, will make cds lint crash

// entity EnvironmentFunctions  as projection on Functions where environment.ID in (
//         select environment from ConnectionEnvironments
//         where
//             connection = $session.environment_ID
//     );

// entity EnvironmentFields     as projection on Fields where environment.ID in (
//         select environment from ConnectionEnvironments
//         where
//             connection = $session.environment_ID
//     );

// entity EnvironmentChecks     as projection on Checks where environment.ID in (
//         select environment from ConnectionEnvironments
//         where
//             connection = $session.environment_ID
//     );

// entity EnvironmentPartitions as projection on Partitions where environment.ID in (
//         select environment from ConnectionEnvironments
//         where
//             connection = $session.environment_ID
//     );
