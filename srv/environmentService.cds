using {
    Environments as environments,
} from '../db/environments';

@path : 'service/environment'
service EnvironmentService {
    @odata.draft.enabled
    entity Environments as projection on environments;
}
