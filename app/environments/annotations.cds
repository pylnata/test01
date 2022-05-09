using ModelingService as service from '../../srv/service';

annotate service.Environments with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'environment',
            Value : environment,
        },
        {
            $Type : 'UI.DataField',
            Label : 'version',
            Value : version,
        },
        {
            $Type : 'UI.DataField',
            Label : 'description',
            Value : description,
        },
    ]
);
annotate service.Environments with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'environment',
                Value : environment,
            },
            {
                $Type : 'UI.DataField',
                Label : 'version',
                Value : version,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
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
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Fields',
            ID : 'Fields',
            Target : 'Fields/@UI.LineItem#Fields1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Functions',
            ID : 'Functions',
            Target : 'Functions/@UI.LineItem#Functions1',
        },
    ]
);
annotate service.Fields with @(
    UI.LineItem #Fields : [
        {
            $Type : 'UI.DataField',
            Value : field,
            Label : 'field',
        },{
            $Type : 'UI.DataField',
            Value : description,
            Label : 'description',
        },{
            $Type : 'UI.DataField',
            Value : type,
            Label : 'type',
        },]
);
annotate service.Functions with @(
    UI.LineItem #Functions : [
        {
            $Type : 'UI.DataField',
            Value : function,
            Label : 'function',
        },{
            $Type : 'UI.DataField',
            Value : description,
            Label : 'description',
        },{
            $Type : 'UI.DataField',
            Value : type,
            Label : 'type',
        },]
);
annotate service.Functions with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Details',
            ID : 'Details',
            Target : '@UI.FieldGroup#Details',
        },
    ],
    UI.FieldGroup #Details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : function,
                Label : 'function',
            },{
                $Type : 'UI.DataField',
                Value : description,
                Label : 'description',
            },{
                $Type : 'UI.DataField',
                Value : type,
                Label : 'type',
            },],
    }
);
annotate service.Fields with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Details',
            ID : 'Details',
            Target : '@UI.FieldGroup#Details',
        },
    ],
    UI.FieldGroup #Details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : field,
                Label : 'field',
            },{
                $Type : 'UI.DataField',
                Value : description,
                Label : 'description',
            },{
                $Type : 'UI.DataField',
                Value : type,
                Label : 'type',
            },],
    }
);
annotate service.Fields with @(
    UI.LineItem #Fields1 : [
        {
            $Type : 'UI.DataField',
            Value : field,
            Label : 'field',
        },{
            $Type : 'UI.DataField',
            Value : description,
            Label : 'description',
        },{
            $Type : 'UI.DataField',
            Value : type,
            Label : 'type',
        },]
);
annotate service.Functions with @(
    UI.LineItem #Functions1 : [
        {
            $Type : 'UI.DataField',
            Value : function,
            Label : 'function',
        },{
            $Type : 'UI.DataField',
            Value : description,
            Label : 'description',
        },{
            $Type : 'UI.DataField',
            Value : type,
            Label : 'type',
        },]
);
