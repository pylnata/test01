using {Environments as environments} from '../db/environments';
using {Fields as fields} from '../db/fields';
using {Checks as checks} from '../db/fields';
using {CurrencyConversions as currencyConversions} from '../db/fields';
using {UnitConversions as unitConversions} from '../db/fields';
using {Partitions as partitions} from '../db/fields';
using {Functions as functions} from '../db/functions';
using {Allocations as allocations} from '../db/allocations';
using {ModelTables as modelTables} from '../db/modelTables';
using {CalculationUnits as calculationUnits} from '../db/calculationUnits';

@path : 'service/modeling'
service ModelingService {

    @odata.draft.enabled  @readonly
    entity Environments      as projection on environments;

    @odata.draft.enabled
    entity Fields        as projection on fields;

    @odata.draft.enabled
    entity Checks        as projection on checks;

    @odata.draft.enabled
    entity CurrencyConversions        as projection on currencyConversions;

    @odata.draft.enabled
    entity UnitConversions        as projection on unitConversions;

    @odata.draft.enabled
    entity Partitions        as projection on partitions;

    @odata.draft.enabled
    entity Functions        as projection on functions actions {
        @title : 'Activate'
        action activate();
    };

    @odata.draft.enabled
    entity Allocations      as projection on allocations actions {
        @title : 'Activate'
        action activate();
    };
    @odata.draft.enabled
    entity CalculationUnits as projection on calculationUnits;

    @odata.draft.enabled
    entity ModelTables      as projection on modelTables;

}
