using EnvironmentService as service from '../../srv/environmentService';
using from '../../db/environments';

annotate service.Environments with @(UI.LineItem : [
    {
        $Type : 'UI.DataField',
        Value : environment,
    },
    {
        $Type : 'UI.DataField',
        Value : version,
    },
    {
        $Type          : 'UI.DataFieldWithIntentBasedNavigation',
        SemanticObject : 'Environments',
        Action         : 'manage',
        Value          : description,
    },
    {
        $Type : 'UI.DataField',
        Value : type_code,
    },
    {
        $Type : 'UI.DataField',
        Value : sequence,
    },
]);

annotate service.Environments with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {
                $Type : 'UI.DataField',
                Value : environment,
            },
            {
                $Type : 'UI.DataField',
                Value : version,
            },
            {
                $Type          : 'UI.DataField',
                Value          : description,
            },
            {
                $Type : 'UI.DataField',
                Value : type_code,
            },
            {
                $Type : 'UI.DataField',
                Value : parent_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : sequence,
            },
        ],
    },
    UI.Facets                      : [{
        $Type  : 'UI.ReferenceFacet',
        ID     : 'GeneratedFacet1',
        Label  : 'General Information',
        Target : '@UI.FieldGroup#GeneratedGroup1',
    }, ]
);

annotate service.Environments with {
    type @Common.Text : type.name
};
annotate service.Environments with @(
    UI.SelectionFields : [
        parent_ID,
    ]
);
annotate service.Environments with {
    parent @Common.Text : parent.description
};
annotate service.Environments with {
    parent @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'EnvironmentFolders',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : parent_ID,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};
annotate service.EnvironmentFolders with {
    ID @Common.Text : description
};
