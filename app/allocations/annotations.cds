using ModelingService as service from '../../srv/service';
using from '../../db/schema';

annotate service.Allocations with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'type',
            Value : type,
        },
        {
            $Type : 'UI.DataField',
            Value : Environment_ID,
            Label : 'Environment_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : Function_ID,
            Label : 'Function_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : SenderFunction_ID,
            Label : 'SenderFunction_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : ReceiverFunction_ID,
            Label : 'ReceiverFunction_ID',
        },
    ]
);
annotate service.Allocations with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'type',
                Value : type,
            },
            {
                $Type : 'UI.DataField',
                Value : Environment_ID,
                Label : 'Environment_ID',
            },
            {
                $Type : 'UI.DataField',
                Value : Function_ID,
                Label : 'Function_ID',
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
            Label : 'Rules',
            ID : 'Rules',
            Target : 'AllocationRules/@UI.LineItem#Rules',
        },
    ]
);
annotate service.Allocations with {
    Environment @Common.Text : Environment.description
};
annotate service.Allocations with {
    Function @Common.Text : Function.description
};
annotate service.Allocations with {
    SenderFunction @Common.Text : SenderFunction.description
};
annotate service.Allocations with {
    ReceiverFunction @Common.Text : ReceiverFunction.description
};
annotate service.AllocationRules with @(
    UI.LineItem #Rules : [
        {
            $Type : 'UI.DataField',
            Value : type,
            Label : 'type',
        },{
            $Type : 'UI.DataField',
            Value : DriverField_ID,
            Label : 'DriverField_ID',
        },]
);
annotate service.AllocationRules with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Rule',
            ID : 'Rule',
            Target : '@UI.FieldGroup#Rule',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Sender Fields',
            ID : 'SenderFields',
            Target : 'SenderFields/@UI.LineItem#SenderFields',
        },
    ],
    UI.FieldGroup #Rule : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : type,
                Label : 'type',
            },{
                $Type : 'UI.DataField',
                Value : DriverField_ID,
                Label : 'DriverField_ID',
            },],
    }
);
annotate service.Allocations with {
    Environment @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Environments',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : Environment_ID,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.Environments with {
    ID @Common.Text : description
};
annotate service.Allocations with {
    Function @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Functions',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : Function_ID,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.Functions with {
    ID @Common.Text : description
};
annotate service.AllocationRuleSenderFields with @(
    UI.LineItem #SenderFields : [
        {
            $Type : 'UI.DataField',
            Value : Field_ID,
            Label : 'Field_ID',
        },{
            $Type : 'UI.DataField',
            Value : formula,
            Label : 'formula',
        },{
            $Type : 'UI.DataField',
            Value : group_,
            Label : 'group_',
        },]
);
