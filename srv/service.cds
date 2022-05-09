using {
    Environments as environments,
    Fields       as fields,
    Functions    as functions,
    ModelTables  as modelTables,
    Allocations  as allocations
} from '../db/schema';

@path : 'service/modeling'
service ModelingService {

    @odata.draft.enabled
    entity Environments as projection on environments;
    entity Fields       as projection on fields;
    entity Functions    as projection on functions;
    @odata.draft.enabled
    entity ModelTables  as projection on modelTables;
    @odata.draft.enabled
    entity Allocations  as projection on allocations;

}
