using ModelingService as service from '../../srv/modelingService';
using from '../../db/functions';



annotate service.Functions with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : function,
        },
        {
            $Type : 'UI.DataField',
            Value : sequence,
        },
        {
            $Type : 'UI.DataField',
            Label : 'type_code',
            Value : type_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'processingType_code',
            Value : processingType_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'businessEventType_code',
            Value : businessEventType_code,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'ModelingService.activate',
            Label : 'Activate',
        },
    ]
);
annotate service.Functions with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : function,
            },
            {
                $Type : 'UI.DataField',
                Value : sequence,
            },
            {
                $Type : 'UI.DataField',
                Label : 'type_code',
                Value : type_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'processingType_code',
                Value : processingType_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'businessEventType_code',
                Value : businessEventType_code,
            },
            {
                $Type : 'UI.DataField',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Value : documentation,
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
