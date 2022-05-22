using ModelingService as service from '../../srv/modelingService';
using from '../../db/allocations';
using from '../../db/functions';
using from '../../db/commonTypes';

annotate service.Allocations with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            ID : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Sender',
            ID : 'Sender',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Input',
                    ID : 'Input',
                    Target : '@UI.FieldGroup#Input',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'View',
                    ID : 'View',
                    Target : 'senderViews/@UI.LineItem#View',
                },],
        },
    ],
    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : type_code,
            },{
                $Type : 'UI.DataField',
                Value : valueAdjustment_code,
            },{
                $Type : 'UI.DataField',
                Value : includeInputData,
            },{
                $Type : 'UI.DataField',
                Value : resultHandling_code,
            },{
                $Type : 'UI.DataField',
                Value : includeInitialResult,
            },{
                $Type : 'UI.DataField',
                Value : cycleFlag,
            },{
                $Type : 'UI.DataField',
                Value : cycleMaximum,
            },{
                $Type : 'UI.DataField',
                Value : cycleIterationField_ID,
            },{
                $Type : 'UI.DataField',
                Value : cycleAggregation_code,
            },{
                $Type : 'UI.DataField',
                Value : termFlag,
            },{
                $Type : 'UI.DataField',
                Value : termIterationField_ID,
            },{
                $Type : 'UI.DataField',
                Value : termYearField_ID,
            },{
                $Type : 'UI.DataField',
                Value : termField_ID,
            },{
                $Type : 'UI.DataField',
                Value : termProcessing_code,
            },{
                $Type : 'UI.DataField',
                Value : termYear,
            },{
                $Type : 'UI.DataField',
                Value : termMinimum,
            },{
                $Type : 'UI.DataField',
                Value : termMaximum,
            },{
                $Type : 'UI.DataField',
                Value : environment_ID,
                Label : 'environment_ID',
            },{
                $Type : 'UI.DataField',
                Value : function_ID,
                Label : 'function_ID',
            },],
    }
);
annotate service.Allocations with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : environment_ID,
            Label : 'environment_ID',
        },
        {
            $Type : 'UI.DataField',
            Value : function_ID,
            Label : 'function_ID',
        },
    ]
);

annotate service.Functions with {
    function @Common.Text : description
};

annotate service.Functions with {
    ID @Common.Text : description
};

annotate service.Allocations with {
    valueAdjustment @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AllocationValueAdjustments',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : valueAdjustment_code,
                    ValueListProperty : 'code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.AllocationValueAdjustments with {
    code @Common.Text : name
};

annotate service.SenderViews with {
    order_ @Common.Text : order_.name
};
annotate service.Allocations with @(
    UI.FieldGroup #Input : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : senderFunction_ID,
            },],
    }
);
annotate service.SenderViews with @(
    UI.LineItem #View : [
        {
            $Type : 'UI.DataField',
            Value : field_ID,
        },{
            $Type : 'UI.DataField',
            Value : formula,
        },{
            $Type : 'UI.DataField',
            Value : order__code,
        },]
);
annotate service.SenderViews with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            ID : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Selections',
            ID : 'Selections',
            Target : 'selections/@UI.LineItem#Selections',
        },
    ]
);
annotate service.SenderViewSelections with @(
    UI.LineItem #Selections : [
        {
            $Type : 'UI.DataField',
            Value : sign_code,
        },{
            $Type : 'UI.DataField',
            Value : opt_code,
        },{
            $Type : 'UI.DataField',
            Value : low,
        },{
            $Type : 'UI.DataField',
            Value : high,
        },]
);
annotate service.SenderViews with {
    field @Common.Text : field.description
};
annotate service.SenderViews with @(
    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : field_ID,
            },{
                $Type : 'UI.DataField',
                Value : formula,
            },{
                $Type : 'UI.DataField',
                Value : order__code,
            },],
    }
);
annotate service.Allocations with {
    type @Common.Text : type.name
};
annotate service.Allocations with {
    type @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AllocationTypes',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : type_code,
                    ValueListProperty : 'code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.AllocationTypes with {
    code @Common.Text : name
};
annotate service.Allocations with {
    valueAdjustment @Common.Text : valueAdjustment.name
};
annotate service.Allocations with {
    resultHandling @Common.Text : resultHandling.name
};
annotate service.Allocations with {
    resultHandling @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'ResultHandlings',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : resultHandling_code,
                    ValueListProperty : 'code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.ResultHandlings with {
    code @Common.Text : name
};
annotate service.Allocations with {
    termField @Common.Text : termField.description
};
annotate service.Allocations with {
    termField @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AllocationTermFields',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : termField_ID,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};
annotate service.AllocationTermFields with {
    ID @Common.Text : description
};
annotate service.Allocations with {
    termProcessing @Common.Text : termProcessing.name
};
annotate service.Allocations with {
    termProcessing @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'AllocationTermProcessings',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : termProcessing_code,
                    ValueListProperty : 'code',
                },
            ],
        },
        Common.ValueListWithFixedValues : true
)};
annotate service.AllocationTermProcessings with {
    code @Common.Text : name
};
annotate service.Allocations with {
    environment @Common.Text : environment.description
};
annotate service.Allocations with {
    function @Common.Text : function.description
};
annotate service.Allocations with {
    senderFunction @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'InputFunctions',
            Parameters : [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : senderFunction_ID,
                        ValueListProperty : 'ID',
                    },
                    {
                        $Type : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty : 'function',
                    },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description',
                },
                ],
        },
        Common.ValueListWithFixedValues : false
)};
annotate service.InputFunctions with {
    ID @Common.Text : description
};
annotate service.Allocations with {
    senderFunction @Common.Text : senderFunction.description
};
