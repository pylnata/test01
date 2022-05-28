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
  cds.persistence.skip : 'if-unused',
  cds.odata.valuelist,
// UI.Identification    : [{Value : name}],
) {
  name  : String(255)  @title : '{i18n>Name}';
  descr : String(1000) @title : '{i18n>Description}';
}

// @cds.persistence.journal // Enable schema evolution for all environment configuration tables
aspect environment : {
  environment : Association to one Environments @title : 'Environment'  @mandatory;
}

aspect function : environment {
  function : Association to one Functions @title : 'Function'  @mandatory;
}

aspect keyFunction : environment {
  key function : Association to one Functions @mandatory;
}

aspect field : environment {
  field : Association to one Fields @mandatory;
}

aspect check : environment {
  check : Association to one Checks @mandatory;
}

aspect formula {
  formula : String @title : 'Formula';
}

aspect formulaGroup : formula {
  ![group] : Association to one Groups @title : 'Group';
}

aspect formulaOrder : formula {
  ![order] : Association to one Orders @title : 'Order';
}

aspect formulaGroupOrder : formulaGroup {
  ![order] : Association to one Orders;
}

aspect selection : {
  seq  : Sequence default 0;
  sign : Association to one Signs   @title : 'Sign'  @mandatory;
  opt  : Association to one Options @title : 'Option'  @mandatory;
  low  : String                     @title : 'Value';
  high : String                     @title : 'High Value';
}
