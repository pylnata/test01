using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
    Field,
    Value,
    Sequence,
    Description,
    Documentation,
} from './commonTypes';
using {
    environment,
    field,
    myCodeList
} from './commonAspects';
using {Functions} from './functions';

// @assert.unique : {
//     field       : [
//         environment,
//         field
//     ],
//     description : [
//         environment,
//         description,
//     ]
// }
@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [{Value : field}]
entity Fields : managed, environment {
    key ID                   : GUID;
        field                : Field;
        seq                  : Sequence;
        class                : Association to one FieldClasses  @title : 'Field Class';
        type                 : Association to one FieldTypes    @title : 'Field Type';
        hanaDataType         : Association to one HanaDataTypes @title : 'Data Type';
        dataLength           : DataLength default 16;
        dataDecimals         : DataDecimals default 0;
        unitField            : Association to one UnitFields;
        isLowercase          : IsLowercase default true;
        hasMasterData        : HasMasterData default false;
        hasHierarchies       : HasHierarchy default false;
        calculationHierarchy : Association to one FieldHierarchies;
        masterDataQuery      : Association to one MasterDataQueries;
        description          : Description;
        documentation        : Documentation;
        values               : Composition of many FieldValues
                                   on values.field = $self;
        hierarchies          : Composition of many FieldHierarchies
                                   on hierarchies.field = $self;
}

entity FieldValues : managed, field {
    key ID             : GUID;
        value          : Value;
        isNode         : IsNode;
        description    : Description;
        authorizations : Composition of many FieldValueAuthorizations
                             on authorizations.value = $self;
}

entity FieldValueAuthorizations : managed, field {
    key ID          : GUID;
        value       : Association to one FieldValues @mandatory;
        userGrp     : String;
        readAccess  : Boolean;
        writeAccess : Boolean;
}

entity FieldHierarchies : managed, field {
    key ID          : GUID;
        hierarchy   : Hierarchy;
        description : Description;
        structures  : Composition of many FieldHierarchyStructures
                          on structures.hierarchy = $self;
}

entity FieldHierarchyStructures : managed, field {
    key ID          : GUID;
        sequence    : Sequence;
        hierarchy   : Association to one FieldHierarchies @mandatory;
        value       : Association to one FieldValues      @mandatory;
        parentValue : Association to one FieldValues      @mandatory;
}

type FieldClass @(assert.range) : String @title : 'Field Class' enum {
    Field     = '';
    Parameter = 'PARAMETER';
};

entity FieldClasses : myCodeList {
    key code : FieldClass default '';
}

type FieldType @(assert.range) : String @title : 'Field Type' enum {
    Characteristic = 'CHA';
    KeyFigure      = 'KYF';
    Unit           = 'UNI';
};

entity FieldTypes : myCodeList {
    key code : FieldType default 'CHA';
}

// type DdicDataType : String(10) enum {
//     // Deletion = ''; // In case of deletion request the value is ''
//     // Date/time types
//     DateString          = 'DATS'; // in Format YYYYMMDD
//     TimeString          = 'TIMS'; // in Format HHMMSS
//     // Numeric types
//     Decimal             = 'DEC';
//     // ShortDecimal = 'D16D';
//     // LongDecimal = 'D34D';
//     FloatingPoint       = 'FLTP';
//     TinyInteger         = 'INT1';
//     ShortInteger        = 'INT2';
//     Integer             = 'INT4';
//     LongInteger         = 'INT8';
//     Quantity            = 'QUAN';
//     CurrencyField       = 'CURR';
//     // Unit types
//     Unit                = 'UNIT';
//     CurrencyKey         = 'CUKY';
//     // String types
//     CharacterString     = 'CHAR';
//     // VariableString = 'STRG';
//     ShortVariableString = 'SSTR'; // CLOB
//     NumericalText       = 'NUMC';
// // Client = 'CLNT';
// // LanguageKey = 'LANG';
// // Binary types
// // RawBinary = 'RAW';
// // LongRawBinary = 'LRAW';
// // VariableRawBinary = 'RSTR'; // BLOB
// }

type HanaDataType @(assert.range) : String @title : 'Data type' enum {
    // Datetime types
    /**
     * YYYY-MM-DD
     */
    LocalDate        = 'DATE';
    /**
     * HH24:MI:SS
     */
    LocalTime        = 'TIME';
    /**
     * YYYY-MM-DD HH24:MI:SS
     */
    UTCDateTime      = 'SECONDDATE';
    /**
     * YYYY-MM-DD HH24:MI:SS.FF<7>
     */
    UTCTimestamp     = 'TIMESTAMP';

    // Numeric types
    /**
     * 8-bit
     */
    TinyInteger      = 'TINYINT';
    /**
     * 16-bit
     */
    SmallInteger     = 'SMALLINT';
    /**
     * 32-bit
     */
    Integer          = 'INTEGER';
    /**
     * 64-bit
     */
    BigInteger       = 'BIGINT';
    /**
     * Params: precision (length) <= 38, scale <= precision
     */
    Decimal          = 'DECIMAL';
    /**
     * Decimal with precision 16
     */
    SmallDecimal     = 'SMALLDECIMAL';
    /**
     * 32-bit
     */
    Real             = 'REAL';
    /**
     * 64-bit
     */
    Double           = 'DOUBLE';

    // Boolean type
    /**
     * Possible values: TRUE, FALSE, UNKNOWN = NULL
     */
    Boolean          = 'BOOLEAN';

    // Character string types
    /**
     * Param: length <= 5000 @deprecated In HANA Cloud just an
     * alias for {@link String}
     */
    AsciiString      = 'VARCHAR';
    /**
     * Param: length <= 5000
     */
    String           = 'NVARCHAR';
    /**
     * Param: length <= 2000 @deprecated In HANA Cloud just an
     * alias for {@link FixedString}. Use {@link String} instead
     */
    FixedAsciiString = 'CHAR';
    /**
     * Param: length <= 2000 @deprecated Not officially documented.
     * Use {@link String} instead
     */
    FixedString      = 'NCHAR';

    // Binary types
    /**
     * Param: length <= 5000
     */
    Binary           = 'VARBINARY';
    /**
     * Param: length <= 2000 @deprecated Not officially documented.
     * Use {@link Binary} instead
     */
    FixedBinary      = 'BINARY';

    // Large Object types
    LargeBinary      = 'BLOB';
    /**
     * @deprecated In HANA Cloud just an alias for {@link
     * LargeString}
     */
    LargeAsciiString = 'CLOB';
    LargeString      = 'NCLOB';
};

entity HanaDataTypes : myCodeList {
    key code : HanaDataType default 'NVARCHAR';
}

type DataLength : Integer @title : 'Data Length'  @mandatory  @assert.range : [
    0,
    5000
];

type DataDecimals : Integer @title : 'Data Decimals'  @assert.range : [
    0,
    16
];

type UnitField : FieldType @title : 'Unit Field';

@cds.autoexpose  @readonly
entity UnitFields        as projection on Fields where type.code = 'UNI';


type IsNode : Boolean @title : 'Is Node';
type IsLowercase : Boolean @title : 'Lowercase';
type HasMasterData : Boolean @title : 'Has Master Data';
type HasHierarchy : Boolean @title : 'Has Hierarchy';
type Hierarchy : String @title : 'Hierarchy Name'  @assert.format : '[A-Z,0-9,_]{1,30}';

@cds.autoexpose  @readonly
entity MasterDataQueries as projection on Functions where type.code = 'MT';
