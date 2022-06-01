using ModelingService as service from '../../srv/modelingService';

annotate service.CalculationUnits with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'dummy',
            Value : dummy,
        },
    ]
);
annotate service.CalculationUnits with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'dummy',
                Value : dummy,
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
