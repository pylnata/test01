using EnvironmentService as service from '../../srv/environmentService';
using from '../../db/environments';

annotate service.Environments with @(UI.LineItem : [

    {
        $Type : 'UI.DataField',
        Value : description,
    },
    {
        $Type : 'UI.DataField',
        Value : environment,
    },
    {
        $Type : 'UI.DataField',
        Value : version,
    },
    {
        $Type : 'UI.DataField',
        Value : type_code,
    },
    {
        $Type          : 'UI.DataFieldWithIntentBasedNavigation',
        SemanticObject : 'Environments',
        Action         : 'manage',
        Value          : gotoSubfolders,
        Mapping        : [{
            $Type                  : 'Common.SemanticObjectMappingType',
            LocalProperty          : ID,
            SemanticObjectProperty : 'parent_ID',
        }, ],
    },
    {
        $Type             : 'UI.DataFieldWithUrl',
        IconUrl           : icon,
        Url               : url,
        Value             : url,
        Label             : 'URL',
        ![@UI.Importance] : #High,
    },
    {
        $Type               : 'UI.DataFieldForIntentBasedNavigation',
        Label               : 'Model',
        SemanticObject      : 'Functions', //Target entity
        Action              : 'manage', //Specifies the app of the target entity
        IconUrl             : 'sap-icon://tree', //Icons only supported for inline actions / intend based navigation
        NavigationAvailable : {$edmJson : {$If : [
            {$Eq : [
                {$Path : 'type_code'},
                'NODE'
            ]},
            false,
            true
        ]}},
        Inline              : true,
        Mapping             : [{
            $Type                  : 'Common.SemanticObjectMappingType',
            LocalProperty          : ID,
            SemanticObjectProperty : 'environment_ID',
        }, ],
        ![@UI.Importance]   : #High,
    },
// {
//     $Type          : 'UI.DataFieldForIntentBasedNavigation',
//     SemanticObject : 'Functions',
//     Action         : 'manage',
//     Label          : 'Go to Functions',
//     Mapping        : [{
//         $Type                  : 'Common.SemanticObjectMappingType',
//         LocalProperty          : ID,
//         SemanticObjectProperty : 'environment_ID',
//     }, ],
// },

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
                $Type : 'UI.DataField',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Value : type_code,
            },
            {
                $Type : 'UI.DataField',
                Value : parent_ID,
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
    @Common.Text : {
        $value                 : type.name,
        ![@UI.TextArrangement] : #TextOnly,
    }
    type;
};

annotate service.Environments with @(UI.SelectionFields : [parent_ID, ]);

annotate service.Environments with {
    parent @Common.Text : {
        $value                 : parent.description,
        ![@UI.TextArrangement] : #TextOnly,
    }
};

annotate service.Environments with {
    type @(
        Common.ValueList                : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'EnvironmentTypes',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : type_code,
                ValueListProperty : 'code',
            }, ],
        },
        Common.ValueListWithFixedValues : true
    )
};

annotate service.EnvironmentTypes with {
    code @Common.Text : {
        $value                 : name,
        ![@UI.TextArrangement] : #TextOnly,
    }
};

annotate service.Environments with {
    parent_ID @Common.Text : {
        $value                 : parent.description,
        ![@UI.TextArrangement] : #TextOnly,
    }
};

annotate service.Environments with {
    parent @(
        Common.ValueList                : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'EnvironmentFolders',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : parent_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'environment',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
    )
};

annotate service.Environments with {
    parent_ID @(
        Common.ValueList                : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'EnvironmentFolders',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : parent_ID,
                    ValueListProperty : 'ID',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'environment',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'version',
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
    )
};
