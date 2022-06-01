using ModelingService as service from '../../srv/modelingService';

annotate service.ModelTables with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : type_code,
        },
        {
            $Type : 'UI.DataField',
            Value : transportData,
        },
        {
            $Type : 'UI.DataField',
            Value : connection,
        },
    ]
);
annotate service.ModelTables with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : type_code,
            },
            {
                $Type : 'UI.DataField',
                Value : transportData,
            },
            {
                $Type : 'UI.DataField',
                Value : connection,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
    ]
);
annotate service.ModelTables with @(
    UI.SelectionFields : [
        environment_ID,
        function_ID,
    ]
);
