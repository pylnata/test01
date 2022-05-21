using ModelingService as service from '../../srv/modelingService';
using from '../../db/allocations';
using from '../../db/functions';

annotate service.Allocations with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            ID : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
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
            },
            {
                $Type : 'UI.DataField',
                Value : senderInput,
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

annotate service.Allocations with {
    senderInput @Common.Text : _senderInput.description
};
annotate service.Allocations with {
    senderInput @(Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Functions',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : senderInput,
                    ValueListProperty : 'ID',
                },
            ],
        },
        Common.ValueListWithFixedValues : false
)};
annotate service.Functions with {
    ID @Common.Text : description
};
