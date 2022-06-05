using {
    Environments as environments,
                    Environment,
                    Description
} from '../db/environments';

@path : 'service/environment'
service EnvironmentService {
    @odata.draft.enabled
    entity Environments as projection on environments order by
        environment,
        version;

    @title : 'Create Folder'
    action createFolder();

}
