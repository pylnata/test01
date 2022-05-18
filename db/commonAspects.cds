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
  Function,
  Sequence,
  Field,
  Groups,
  Orders,
  Signs,
  Options
} from './commonTypes';

using {Environments} from './environments';
using {Functions} from './functions';
using {Fields} from './fields';
using {Checks} from './checks';

aspect myCodeList @(
  cds.autoexpose,
  cds.persistence.skip : 'if-unused'
) {
  name  : String(255)  @title : '{i18n>Name}';
  descr : String(1000) @title : '{i18n>Description}';
}

// @cds.persistence.journal // Enable schema evolution for all environment configuration tables
aspect environment : {
  environment : Association to one Environments @mandatory;
}

aspect function : environment {
  Function : Association to one Functions @mandatory;
}

aspect field : environment {
  field : Association to one Fields @mandatory;
}

aspect functionField : function {
  field : Association to one Fields @mandatory;
}

aspect formulaOrderAggregation {
  formula : String;
  group_  : Association to one Groups @mandatory;
  order_  : Association to one Orders @mandatory;
}

aspect selection : {
  step : Integer;
  sign : Association to one Signs   @mandatory;
  opt  : Association to one Options @mandatory;
  low  : String;
  high : String;
}
