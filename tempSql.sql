
CREATE TABLE Environments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  sequence INTEGER,
  description NVARCHAR(5000),
  parent_ID NVARCHAR(36),
  type_code NVARCHAR(5000) DEFAULT 'ENV_VER',
  PRIMARY KEY(ID),
  CONSTRAINT c__Environments_type
  FOREIGN KEY(type_code)
  REFERENCES EnvironmentTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE EnvironmentTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ENV_VER',
  PRIMARY KEY(code)
);

CREATE TABLE Fields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000),
  seq INTEGER,
  class_code NVARCHAR(5000) DEFAULT '',
  type_code NVARCHAR(5000) DEFAULT 'CHA',
  hanaDataType_code NVARCHAR(5000) DEFAULT 'NVARCHAR',
  dataLength INTEGER DEFAULT 16,
  dataDecimals INTEGER DEFAULT 0,
  unitField_ID NVARCHAR(36),
  isLowercase BOOLEAN DEFAULT TRUE,
  hasMasterData BOOLEAN DEFAULT FALSE,
  hasHierarchies BOOLEAN DEFAULT FALSE,
  calculationHierarchy_ID NVARCHAR(36),
  masterDataQuery_ID NVARCHAR(36),
  description NVARCHAR(5000),
  documentation NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__Fields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_class
  FOREIGN KEY(class_code)
  REFERENCES FieldClasses(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_type
  FOREIGN KEY(type_code)
  REFERENCES FieldTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_hanaDataType
  FOREIGN KEY(hanaDataType_code)
  REFERENCES HanaDataTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_calculationHierarchy
  FOREIGN KEY(calculationHierarchy_ID)
  REFERENCES FieldHierarchies(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldValues (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  value NVARCHAR(5000),
  isNode BOOLEAN,
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldValues_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValues_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldValueAuthorizations (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  value_ID NVARCHAR(36),
  userGrp NVARCHAR(5000),
  readAccess BOOLEAN,
  writeAccess BOOLEAN,
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldValueAuthorizations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValueAuthorizations_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValueAuthorizations_value
  FOREIGN KEY(value_ID)
  REFERENCES FieldValues(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldHierarchies (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  hierarchy NVARCHAR(5000),
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldHierarchies_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchies_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldHierarchyStructures (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sequence INTEGER,
  hierarchy_ID NVARCHAR(36),
  value_ID NVARCHAR(36),
  parentValue_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldHierarchyStructures_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_hierarchy
  FOREIGN KEY(hierarchy_ID)
  REFERENCES FieldHierarchies(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_value
  FOREIGN KEY(value_ID)
  REFERENCES FieldValues(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_parentValue
  FOREIGN KEY(parentValue_ID)
  REFERENCES FieldValues(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldClasses (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE FieldTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(code)
);

CREATE TABLE HanaDataTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'NVARCHAR',
  PRIMARY KEY(code)
);

CREATE TABLE Functions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000),
  sequence INTEGER,
  parentFunction_ID NVARCHAR(36),
  type_code NVARCHAR(10) DEFAULT 'MT',
  processingType_code NVARCHAR(10) DEFAULT '',
  businessEventType_code NVARCHAR(10) DEFAULT '',
  partition_ID NVARCHAR(36),
  parentCalculationUnit_ID NVARCHAR(36),
  description NVARCHAR(5000),
  documentation NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__Functions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_type
  FOREIGN KEY(type_code)
  REFERENCES FunctionTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES ProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES BusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FunctionTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'MT',
  PRIMARY KEY(code)
);

CREATE TABLE ProcessingTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE BusinessEventTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Allocations (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) DEFAULT 'ALLOC',
  valueAdjustment_code NVARCHAR(10) DEFAULT '',
  includeInputData BOOLEAN DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN DEFAULT FALSE,
  cycleFlag BOOLEAN DEFAULT FALSE,
  cycleMaximum NVARCHAR(5000) DEFAULT 0,
  cycleIterationField_ID NVARCHAR(36),
  cycleAggregation_code NVARCHAR(10) DEFAULT '',
  termFlag BOOLEAN DEFAULT FALSE,
  termIterationField_ID NVARCHAR(36),
  termYearField_ID NVARCHAR(36),
  termField_ID NVARCHAR(36),
  termProcessing_code NVARCHAR(10) DEFAULT '',
  termYear NVARCHAR(5000),
  termMinimum NVARCHAR(5000),
  termMaximum NVARCHAR(5000),
  senderInputFunction_ID NVARCHAR(36),
  receiverInputFunction_ID NVARCHAR(36),
  ResultFunction_ID NVARCHAR(36),
  earlyExitCheck_checkId NVARCHAR(5000),
  rules_ID NVARCHAR(36),
  offsets_ID NVARCHAR(36),
  debitCredits_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Allocations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_type
  FOREIGN KEY(type_code)
  REFERENCES AllocationTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_valueAdjustment
  FOREIGN KEY(valueAdjustment_code)
  REFERENCES AllocationValueAdjustments(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_resultHandling
  FOREIGN KEY(resultHandling_code)
  REFERENCES ResultHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_cycleIterationField
  FOREIGN KEY(cycleIterationField_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_cycleAggregation
  FOREIGN KEY(cycleAggregation_code)
  REFERENCES AllocationCycleAggregations(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_termProcessing
  FOREIGN KEY(termProcessing_code)
  REFERENCES AllocationTermProcessings(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  rule NVARCHAR(5000),
  sequence INTEGER,
  type_code NVARCHAR(10) DEFAULT 'DIRECT',
  alMethod_code NVARCHAR(10) DEFAULT 'PR',
  ruleState BOOLEAN DEFAULT TRUE,
  parentRule_ID NVARCHAR(36),
  senderRule_code NVARCHAR(10) DEFAULT 'POST_AM',
  receiverRule_code NVARCHAR(10) DEFAULT 'VAR_POR',
  distributionBase NVARCHAR(5000),
  scale_code NVARCHAR(10) DEFAULT '',
  senderShare DECIMAL DEFAULT 100,
  driverField_ID NVARCHAR(36),
  allocation_ID NVARCHAR(36),
  fields_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_type
  FOREIGN KEY(type_code)
  REFERENCES AllocationRuleTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_alMethod
  FOREIGN KEY(alMethod_code)
  REFERENCES AllocationRuleMethods(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_senderRule
  FOREIGN KEY(senderRule_code)
  REFERENCES AllocationSenderRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_receiverRule
  FOREIGN KEY(receiverRule_code)
  REFERENCES AllocationReceiverRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_scale
  FOREIGN KEY(scale_code)
  REFERENCES AllocationRuleScales(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  group__code NVARCHAR(10),
  order__code NVARCHAR(10),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  Selections_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFields_group_
  FOREIGN KEY(group__code)
  REFERENCES "Groups"(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFields_order_
  FOREIGN KEY(order__code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFields_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  step INTEGER,
  sign_code NVARCHAR(1),
  opt_code NVARCHAR(2),
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFieldSelections_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationRuleFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationOffsets (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  offsetField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationOffsets_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_offsetField
  FOREIGN KEY(offsetField_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationDebitCredits (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  debitSign NVARCHAR(5000),
  creditSign NVARCHAR(5000),
  sequence INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationDebitCredits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ALLOC',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationValueAdjustments (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationTermProcessings (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationCycleAggregations (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationRuleTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DIRECT',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationRuleMethods (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'PR',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationSenderRules (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'POST_AM',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationReceiverRules (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'VAR_POR',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationRuleScales (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE ModelTables (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) DEFAULT 'ENV',
  transportData BOOLEAN,
  connName NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTables_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_type
  FOREIGN KEY(type_code)
  REFERENCES ModelTableTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTableFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  modelTable_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTableFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTableFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTableFields_modelTable
  FOREIGN KEY(modelTable_ID)
  REFERENCES ModelTables(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTableTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENV',
  PRIMARY KEY(code)
);

CREATE TABLE CalculationUnits (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  CONSTRAINT c__CalculationUnits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnits_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE MessageTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE "Groups" (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL,
  PRIMARY KEY(code)
);

CREATE TABLE Orders (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL,
  PRIMARY KEY(code)
);

CREATE TABLE Signs (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL,
  PRIMARY KEY(code)
);

CREATE TABLE Options (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(2) NOT NULL,
  PRIMARY KEY(code)
);

CREATE TABLE ResultHandlings (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENRICHED',
  PRIMARY KEY(code)
);

CREATE TABLE Checks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  checkId NVARCHAR(5000) NOT NULL,
  seq INTEGER,
  messageType_code NVARCHAR(1) DEFAULT 'I',
  category_code NVARCHAR(10) DEFAULT '',
  description NVARCHAR(5000),
  PRIMARY KEY(checkId),
  CONSTRAINT c__Checks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Checks_messageType
  FOREIGN KEY(messageType_code)
  REFERENCES MessageTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Checks_category
  FOREIGN KEY(category_code)
  REFERENCES CheckCategories(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Checks_description UNIQUE (environment_ID, description)
);

CREATE TABLE CheckCategories (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Partitions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  "partition" NVARCHAR(5000),
  description NVARCHAR(5000),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Partitions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Partitions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Partitions_partition UNIQUE (environment_ID, "partition"),
  CONSTRAINT Partitions_description UNIQUE (environment_ID, description)
);

CREATE TABLE PartitionRanges (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  partition_ID NVARCHAR(36),
  "range" NVARCHAR(5000),
  sequence INTEGER,
  level INTEGER DEFAULT 0,
  value NVARCHAR(5000),
  hanaVolumeId INTEGER DEFAULT 0,
  PRIMARY KEY(ID),
  CONSTRAINT c__PartitionRanges_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__PartitionRanges_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE EnvironmentTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ENV_VER',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Allocations_senderFunctionSelections (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_senderFunctionSelections_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_senderFunctionSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_senderFunctionSelections_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_senderFunctionSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_receiverFunctionSelections (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_receiverFunctionSelections_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_receiverFunctionSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_receiverFunctionSelections_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_receiverFunctionSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_selectionFields (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_selectionFields_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_selectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_selectionFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_selectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_actionFields (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_actionFields_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_actionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_actionFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_actionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_rSelectionFields (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_rSelectionFields_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rSelectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rSelectionFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rSelectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_rActionFields (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_rActionFields_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rActionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rActionFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_rActionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations_checks (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  check_checkId NVARCHAR(5000),
  PRIMARY KEY(up__ID, ID),
  CONSTRAINT c__Allocations_checks_up_
  FOREIGN KEY(up__ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_checks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_checks_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_checks_check
  FOREIGN KEY(check_checkId)
  REFERENCES Checks(checkId)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DRAFT_DraftAdministrativeData (
  DraftUUID NVARCHAR(36) NOT NULL,
  CreationDateTime TIMESTAMP_TEXT,
  CreatedByUser NVARCHAR(256),
  DraftIsCreatedByMe BOOLEAN,
  LastChangeDateTime TIMESTAMP_TEXT,
  LastChangedByUser NVARCHAR(256),
  InProcessByUser NVARCHAR(256),
  DraftIsProcessedByMe BOOLEAN,
  PRIMARY KEY(DraftUUID)
);

CREATE TABLE ModelingService_Environments_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000) NULL,
  version NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  description NVARCHAR(5000) NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(5000) NULL DEFAULT 'ENV_VER',
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Allocations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'ALLOC',
  valueAdjustment_code NVARCHAR(10) NULL DEFAULT '',
  includeInputData BOOLEAN NULL DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) NULL DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN NULL DEFAULT FALSE,
  cycleFlag BOOLEAN NULL DEFAULT FALSE,
  cycleMaximum NVARCHAR(5000) NULL DEFAULT 0,
  cycleIterationField_ID NVARCHAR(36) NULL,
  cycleAggregation_code NVARCHAR(10) NULL DEFAULT '',
  termFlag BOOLEAN NULL DEFAULT FALSE,
  termIterationField_ID NVARCHAR(36) NULL,
  termYearField_ID NVARCHAR(36) NULL,
  termField_ID NVARCHAR(36) NULL,
  termProcessing_code NVARCHAR(10) NULL DEFAULT '',
  termYear NVARCHAR(5000) NULL,
  termMinimum NVARCHAR(5000) NULL,
  termMaximum NVARCHAR(5000) NULL,
  senderInputFunction_ID NVARCHAR(36) NULL,
  receiverInputFunction_ID NVARCHAR(36) NULL,
  ResultFunction_ID NVARCHAR(36) NULL,
  earlyExitCheck_checkId NVARCHAR(5000) NULL,
  rules_ID NVARCHAR(36) NULL,
  offsets_ID NVARCHAR(36) NULL,
  debitCredits_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Allocations_senderFunctionSelections_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_Allocations_receiverFunctionSelections_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_Allocations_selectionFields_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_Allocations_actionFields_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_Allocations_rSelectionFields_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_Allocations_rActionFields_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sfield NVARCHAR(18) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_AllocationRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'DIRECT',
  alMethod_code NVARCHAR(10) NULL DEFAULT 'PR',
  ruleState BOOLEAN NULL DEFAULT TRUE,
  parentRule_ID NVARCHAR(36) NULL,
  senderRule_code NVARCHAR(10) NULL DEFAULT 'POST_AM',
  receiverRule_code NVARCHAR(10) NULL DEFAULT 'VAR_POR',
  distributionBase NVARCHAR(5000) NULL,
  scale_code NVARCHAR(10) NULL DEFAULT '',
  senderShare DECIMAL NULL DEFAULT 100,
  driverField_ID NVARCHAR(36) NULL,
  allocation_ID NVARCHAR(36) NULL,
  fields_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationOffsets_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  offsetField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationDebitCredits_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  debitSign NVARCHAR(5000) NULL,
  creditSign NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Allocations_checks_drafts (
  up__ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  check_checkId NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(up__ID, ID)
);

CREATE TABLE ModelingService_CalculationUnits_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL
);

CREATE TABLE ModelingService_ModelTables_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'ENV',
  transportData BOOLEAN NULL,
  connName NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_ModelTableFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  modelTable_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE VIEW ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.sequence,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM Environments AS environments_0;

CREATE VIEW ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.Function_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.senderInputFunction_ID,
  allocations_0.receiverInputFunction_ID,
  allocations_0.ResultFunction_ID,
  allocations_0.earlyExitCheck_checkId,
  allocations_0.rules_ID,
  allocations_0.offsets_ID,
  allocations_0.debitCredits_ID
FROM Allocations AS allocations_0;

CREATE VIEW ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.Function_ID
FROM CalculationUnits AS calculationUnits_0;

CREATE VIEW ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.Function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM ModelTables AS modelTables_0;

CREATE VIEW EnvironmentFolders AS SELECT
  Environments_0.ID,
  Environments_0.description
FROM Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW ParentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW ResultModelTables AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW ParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW SenderInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0;

CREATE VIEW ReceiverInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0;

CREATE VIEW ResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0;

CREATE VIEW AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW AllocationTermYearFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW AllocationTermFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW EarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.checkId,
  Checks_0.seq,
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM Checks AS Checks_0;

CREATE VIEW ParentAllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM AllocationRules AS AllocationRules_0;

CREATE VIEW DriverFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0;

CREATE VIEW ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM AllocationTypes AS AllocationTypes_0;

CREATE VIEW ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM ResultHandlings AS ResultHandlings_0;

CREATE VIEW ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW ModelingService_Allocations_senderFunctionSelections AS SELECT
  senderFunctionSelections_0.up__ID,
  senderFunctionSelections_0.createdAt,
  senderFunctionSelections_0.createdBy,
  senderFunctionSelections_0.modifiedAt,
  senderFunctionSelections_0.modifiedBy,
  senderFunctionSelections_0.environment_ID,
  senderFunctionSelections_0.Function_ID,
  senderFunctionSelections_0.field_ID,
  senderFunctionSelections_0.ID,
  senderFunctionSelections_0.sfield
FROM Allocations_senderFunctionSelections AS senderFunctionSelections_0;

CREATE VIEW ModelingService_Allocations_receiverFunctionSelections AS SELECT
  receiverFunctionSelections_0.up__ID,
  receiverFunctionSelections_0.createdAt,
  receiverFunctionSelections_0.createdBy,
  receiverFunctionSelections_0.modifiedAt,
  receiverFunctionSelections_0.modifiedBy,
  receiverFunctionSelections_0.environment_ID,
  receiverFunctionSelections_0.Function_ID,
  receiverFunctionSelections_0.field_ID,
  receiverFunctionSelections_0.ID,
  receiverFunctionSelections_0.sfield
FROM Allocations_receiverFunctionSelections AS receiverFunctionSelections_0;

CREATE VIEW ModelingService_Allocations_selectionFields AS SELECT
  selectionFields_0.up__ID,
  selectionFields_0.createdAt,
  selectionFields_0.createdBy,
  selectionFields_0.modifiedAt,
  selectionFields_0.modifiedBy,
  selectionFields_0.environment_ID,
  selectionFields_0.Function_ID,
  selectionFields_0.field_ID,
  selectionFields_0.ID,
  selectionFields_0.sfield
FROM Allocations_selectionFields AS selectionFields_0;

CREATE VIEW ModelingService_Allocations_actionFields AS SELECT
  actionFields_0.up__ID,
  actionFields_0.createdAt,
  actionFields_0.createdBy,
  actionFields_0.modifiedAt,
  actionFields_0.modifiedBy,
  actionFields_0.environment_ID,
  actionFields_0.Function_ID,
  actionFields_0.field_ID,
  actionFields_0.ID,
  actionFields_0.sfield
FROM Allocations_actionFields AS actionFields_0;

CREATE VIEW ModelingService_Allocations_rSelectionFields AS SELECT
  rSelectionFields_0.up__ID,
  rSelectionFields_0.createdAt,
  rSelectionFields_0.createdBy,
  rSelectionFields_0.modifiedAt,
  rSelectionFields_0.modifiedBy,
  rSelectionFields_0.environment_ID,
  rSelectionFields_0.Function_ID,
  rSelectionFields_0.field_ID,
  rSelectionFields_0.ID,
  rSelectionFields_0.sfield
FROM Allocations_rSelectionFields AS rSelectionFields_0;

CREATE VIEW ModelingService_Allocations_rActionFields AS SELECT
  rActionFields_0.up__ID,
  rActionFields_0.createdAt,
  rActionFields_0.createdBy,
  rActionFields_0.modifiedAt,
  rActionFields_0.modifiedBy,
  rActionFields_0.environment_ID,
  rActionFields_0.Function_ID,
  rActionFields_0.field_ID,
  rActionFields_0.ID,
  rActionFields_0.sfield
FROM Allocations_rActionFields AS rActionFields_0;

CREATE VIEW ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM AllocationRules AS AllocationRules_0;

CREATE VIEW ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.Function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.Function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW ModelingService_Allocations_checks AS SELECT
  checks_0.up__ID,
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.Function_ID,
  checks_0.ID,
  checks_0.check_checkId
FROM Allocations_checks AS checks_0;

CREATE VIEW ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID
FROM ModelTableFields AS ModelTableFields_0;

CREATE VIEW ModelingService_EnvironmentTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM EnvironmentTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_EnvironmentTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.sequence,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.seq,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parentFunction_ID,
  L.type_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.parentCalculationUnit_ID,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_Allocations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.valueAdjustment_code,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.senderInputFunction_ID,
  L.receiverInputFunction_ID,
  L.ResultFunction_ID,
  L.earlyExitCheck_checkId,
  L.rules_ID,
  L.offsets_ID,
  L.debitCredits_ID
FROM Allocations AS L;

CREATE VIEW localized_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.rule,
  L.sequence,
  L.type_code,
  L.alMethod_code,
  L.ruleState,
  L.parentRule_ID,
  L.senderRule_code,
  L.receiverRule_code,
  L.distributionBase,
  L.scale_code,
  L.senderShare,
  L.driverField_ID,
  L.allocation_ID,
  L.fields_ID
FROM AllocationRules AS L;

CREATE VIEW localized_AllocationRuleFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.formula,
  L.group__code,
  L.order__code,
  L.ID,
  L.rule_ID,
  L.Selections_ID
FROM AllocationRuleFields AS L;

CREATE VIEW localized_AllocationRuleFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.step,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleFieldSelections AS L;

CREATE VIEW localized_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connName
FROM ModelTables AS L;

CREATE VIEW localized_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID
FROM ModelTableFields AS L;

CREATE VIEW localized_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID
FROM CalculationUnits AS L;

CREATE VIEW localized_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.checkId,
  L.seq,
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value,
  L.hanaVolumeId
FROM PartitionRanges AS L;

CREATE VIEW localized_Allocations_senderFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_senderFunctionSelections AS L;

CREATE VIEW localized_Allocations_receiverFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_receiverFunctionSelections AS L;

CREATE VIEW localized_Allocations_selectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_selectionFields AS L;

CREATE VIEW localized_Allocations_actionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_actionFields AS L;

CREATE VIEW localized_Allocations_rSelectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rSelectionFields AS L;

CREATE VIEW localized_Allocations_rActionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rActionFields AS L;

CREATE VIEW localized_Allocations_checks AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.check_checkId
FROM Allocations_checks AS L;

CREATE VIEW ModelingService_DraftAdministrativeData AS SELECT
  DraftAdministrativeData.DraftUUID,
  DraftAdministrativeData.CreationDateTime,
  DraftAdministrativeData.CreatedByUser,
  DraftAdministrativeData.DraftIsCreatedByMe,
  DraftAdministrativeData.LastChangeDateTime,
  DraftAdministrativeData.LastChangedByUser,
  DraftAdministrativeData.InProcessByUser,
  DraftAdministrativeData.DraftIsProcessedByMe
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;

CREATE VIEW ModelingService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.description
FROM EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW ModelingService_ParentAllocationRules AS SELECT
  ParentAllocationRules_0.createdAt,
  ParentAllocationRules_0.createdBy,
  ParentAllocationRules_0.modifiedAt,
  ParentAllocationRules_0.modifiedBy,
  ParentAllocationRules_0.environment_ID,
  ParentAllocationRules_0.Function_ID,
  ParentAllocationRules_0.ID,
  ParentAllocationRules_0.rule,
  ParentAllocationRules_0.sequence,
  ParentAllocationRules_0.type_code,
  ParentAllocationRules_0.alMethod_code,
  ParentAllocationRules_0.ruleState,
  ParentAllocationRules_0.parentRule_ID,
  ParentAllocationRules_0.senderRule_code,
  ParentAllocationRules_0.receiverRule_code,
  ParentAllocationRules_0.distributionBase,
  ParentAllocationRules_0.scale_code,
  ParentAllocationRules_0.senderShare,
  ParentAllocationRules_0.driverField_ID,
  ParentAllocationRules_0.allocation_ID,
  ParentAllocationRules_0.fields_ID
FROM ParentAllocationRules AS ParentAllocationRules_0;

CREATE VIEW localized_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_ParentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_ResultModelTables AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_ParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_SenderInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0;

CREATE VIEW localized_ReceiverInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0;

CREATE VIEW localized_ResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0;

CREATE VIEW localized_AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_AllocationTermYearFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_AllocationTermFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_EarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.checkId,
  Checks_0.seq,
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_Checks AS Checks_0;

CREATE VIEW localized_ParentAllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_DriverFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0;

CREATE VIEW localized_ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.sequence,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_Environments AS environments_0;

CREATE VIEW localized_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.Function_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.senderInputFunction_ID,
  allocations_0.receiverInputFunction_ID,
  allocations_0.ResultFunction_ID,
  allocations_0.earlyExitCheck_checkId,
  allocations_0.rules_ID,
  allocations_0.offsets_ID,
  allocations_0.debitCredits_ID
FROM localized_Allocations AS allocations_0;

CREATE VIEW localized_ModelingService_Allocations_senderFunctionSelections AS SELECT
  senderFunctionSelections_0.up__ID,
  senderFunctionSelections_0.createdAt,
  senderFunctionSelections_0.createdBy,
  senderFunctionSelections_0.modifiedAt,
  senderFunctionSelections_0.modifiedBy,
  senderFunctionSelections_0.environment_ID,
  senderFunctionSelections_0.Function_ID,
  senderFunctionSelections_0.field_ID,
  senderFunctionSelections_0.ID,
  senderFunctionSelections_0.sfield
FROM localized_Allocations_senderFunctionSelections AS senderFunctionSelections_0;

CREATE VIEW localized_ModelingService_Allocations_receiverFunctionSelections AS SELECT
  receiverFunctionSelections_0.up__ID,
  receiverFunctionSelections_0.createdAt,
  receiverFunctionSelections_0.createdBy,
  receiverFunctionSelections_0.modifiedAt,
  receiverFunctionSelections_0.modifiedBy,
  receiverFunctionSelections_0.environment_ID,
  receiverFunctionSelections_0.Function_ID,
  receiverFunctionSelections_0.field_ID,
  receiverFunctionSelections_0.ID,
  receiverFunctionSelections_0.sfield
FROM localized_Allocations_receiverFunctionSelections AS receiverFunctionSelections_0;

CREATE VIEW localized_ModelingService_Allocations_selectionFields AS SELECT
  selectionFields_0.up__ID,
  selectionFields_0.createdAt,
  selectionFields_0.createdBy,
  selectionFields_0.modifiedAt,
  selectionFields_0.modifiedBy,
  selectionFields_0.environment_ID,
  selectionFields_0.Function_ID,
  selectionFields_0.field_ID,
  selectionFields_0.ID,
  selectionFields_0.sfield
FROM localized_Allocations_selectionFields AS selectionFields_0;

CREATE VIEW localized_ModelingService_Allocations_actionFields AS SELECT
  actionFields_0.up__ID,
  actionFields_0.createdAt,
  actionFields_0.createdBy,
  actionFields_0.modifiedAt,
  actionFields_0.modifiedBy,
  actionFields_0.environment_ID,
  actionFields_0.Function_ID,
  actionFields_0.field_ID,
  actionFields_0.ID,
  actionFields_0.sfield
FROM localized_Allocations_actionFields AS actionFields_0;

CREATE VIEW localized_ModelingService_Allocations_rSelectionFields AS SELECT
  rSelectionFields_0.up__ID,
  rSelectionFields_0.createdAt,
  rSelectionFields_0.createdBy,
  rSelectionFields_0.modifiedAt,
  rSelectionFields_0.modifiedBy,
  rSelectionFields_0.environment_ID,
  rSelectionFields_0.Function_ID,
  rSelectionFields_0.field_ID,
  rSelectionFields_0.ID,
  rSelectionFields_0.sfield
FROM localized_Allocations_rSelectionFields AS rSelectionFields_0;

CREATE VIEW localized_ModelingService_Allocations_rActionFields AS SELECT
  rActionFields_0.up__ID,
  rActionFields_0.createdAt,
  rActionFields_0.createdBy,
  rActionFields_0.modifiedAt,
  rActionFields_0.modifiedBy,
  rActionFields_0.environment_ID,
  rActionFields_0.Function_ID,
  rActionFields_0.field_ID,
  rActionFields_0.ID,
  rActionFields_0.sfield
FROM localized_Allocations_rActionFields AS rActionFields_0;

CREATE VIEW localized_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.Function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.Function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID
FROM localized_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.Function_ID
FROM localized_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.Function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM localized_ModelTables AS modelTables_0;

CREATE VIEW localized_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_ModelingService_Allocations_checks AS SELECT
  checks_0.up__ID,
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.Function_ID,
  checks_0.ID,
  checks_0.check_checkId
FROM localized_Allocations_checks AS checks_0;

CREATE VIEW localized_ModelingService_ParentAllocationRules AS SELECT
  ParentAllocationRules_0.createdAt,
  ParentAllocationRules_0.createdBy,
  ParentAllocationRules_0.modifiedAt,
  ParentAllocationRules_0.modifiedBy,
  ParentAllocationRules_0.environment_ID,
  ParentAllocationRules_0.Function_ID,
  ParentAllocationRules_0.ID,
  ParentAllocationRules_0.rule,
  ParentAllocationRules_0.sequence,
  ParentAllocationRules_0.type_code,
  ParentAllocationRules_0.alMethod_code,
  ParentAllocationRules_0.ruleState,
  ParentAllocationRules_0.parentRule_ID,
  ParentAllocationRules_0.senderRule_code,
  ParentAllocationRules_0.receiverRule_code,
  ParentAllocationRules_0.distributionBase,
  ParentAllocationRules_0.scale_code,
  ParentAllocationRules_0.senderShare,
  ParentAllocationRules_0.driverField_ID,
  ParentAllocationRules_0.allocation_ID,
  ParentAllocationRules_0.fields_ID
FROM localized_ParentAllocationRules AS ParentAllocationRules_0;

CREATE VIEW localized_de_EnvironmentTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_EnvironmentTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.sequence,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_fr_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.sequence,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_de_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.seq,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_fr_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.seq,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_de_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_fr_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_de_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_fr_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_de_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_fr_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_de_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_fr_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_de_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parentFunction_ID,
  L.type_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.parentCalculationUnit_ID,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_fr_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parentFunction_ID,
  L.type_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.parentCalculationUnit_ID,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_de_Allocations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.valueAdjustment_code,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.senderInputFunction_ID,
  L.receiverInputFunction_ID,
  L.ResultFunction_ID,
  L.earlyExitCheck_checkId,
  L.rules_ID,
  L.offsets_ID,
  L.debitCredits_ID
FROM Allocations AS L;

CREATE VIEW localized_fr_Allocations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.valueAdjustment_code,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.senderInputFunction_ID,
  L.receiverInputFunction_ID,
  L.ResultFunction_ID,
  L.earlyExitCheck_checkId,
  L.rules_ID,
  L.offsets_ID,
  L.debitCredits_ID
FROM Allocations AS L;

CREATE VIEW localized_de_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.rule,
  L.sequence,
  L.type_code,
  L.alMethod_code,
  L.ruleState,
  L.parentRule_ID,
  L.senderRule_code,
  L.receiverRule_code,
  L.distributionBase,
  L.scale_code,
  L.senderShare,
  L.driverField_ID,
  L.allocation_ID,
  L.fields_ID
FROM AllocationRules AS L;

CREATE VIEW localized_fr_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.rule,
  L.sequence,
  L.type_code,
  L.alMethod_code,
  L.ruleState,
  L.parentRule_ID,
  L.senderRule_code,
  L.receiverRule_code,
  L.distributionBase,
  L.scale_code,
  L.senderShare,
  L.driverField_ID,
  L.allocation_ID,
  L.fields_ID
FROM AllocationRules AS L;

CREATE VIEW localized_de_AllocationRuleFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.formula,
  L.group__code,
  L.order__code,
  L.ID,
  L.rule_ID,
  L.Selections_ID
FROM AllocationRuleFields AS L;

CREATE VIEW localized_fr_AllocationRuleFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.formula,
  L.group__code,
  L.order__code,
  L.ID,
  L.rule_ID,
  L.Selections_ID
FROM AllocationRuleFields AS L;

CREATE VIEW localized_de_AllocationRuleFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.step,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleFieldSelections AS L;

CREATE VIEW localized_fr_AllocationRuleFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.step,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleFieldSelections AS L;

CREATE VIEW localized_de_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_fr_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_de_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_fr_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_de_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connName
FROM ModelTables AS L;

CREATE VIEW localized_fr_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connName
FROM ModelTables AS L;

CREATE VIEW localized_de_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID
FROM ModelTableFields AS L;

CREATE VIEW localized_fr_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID
FROM ModelTableFields AS L;

CREATE VIEW localized_de_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID
FROM CalculationUnits AS L;

CREATE VIEW localized_fr_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID
FROM CalculationUnits AS L;

CREATE VIEW localized_de_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.checkId,
  L.seq,
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_fr_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.checkId,
  L.seq,
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_de_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_fr_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_de_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value,
  L.hanaVolumeId
FROM PartitionRanges AS L;

CREATE VIEW localized_fr_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value,
  L.hanaVolumeId
FROM PartitionRanges AS L;

CREATE VIEW localized_de_Allocations_senderFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_senderFunctionSelections AS L;

CREATE VIEW localized_fr_Allocations_senderFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_senderFunctionSelections AS L;

CREATE VIEW localized_de_Allocations_receiverFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_receiverFunctionSelections AS L;

CREATE VIEW localized_fr_Allocations_receiverFunctionSelections AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_receiverFunctionSelections AS L;

CREATE VIEW localized_de_Allocations_selectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_selectionFields AS L;

CREATE VIEW localized_fr_Allocations_selectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_selectionFields AS L;

CREATE VIEW localized_de_Allocations_actionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_actionFields AS L;

CREATE VIEW localized_fr_Allocations_actionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_actionFields AS L;

CREATE VIEW localized_de_Allocations_rSelectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rSelectionFields AS L;

CREATE VIEW localized_fr_Allocations_rSelectionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rSelectionFields AS L;

CREATE VIEW localized_de_Allocations_rActionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rActionFields AS L;

CREATE VIEW localized_fr_Allocations_rActionFields AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.field_ID,
  L.ID,
  L.sfield
FROM Allocations_rActionFields AS L;

CREATE VIEW localized_de_Allocations_checks AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.check_checkId
FROM Allocations_checks AS L;

CREATE VIEW localized_fr_Allocations_checks AS SELECT
  L.up__ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.Function_ID,
  L.ID,
  L.check_checkId
FROM Allocations_checks AS L;

CREATE VIEW localized_de_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_de_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_fr_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_fr_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_de_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_fr_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_de_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_fr_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_ParentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_fr_ParentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_de_ResultModelTables AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_fr_ResultModelTables AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_ParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_fr_ParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_de_SenderInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0;

CREATE VIEW localized_fr_SenderInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0;

CREATE VIEW localized_de_ReceiverInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0;

CREATE VIEW localized_fr_ReceiverInputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0;

CREATE VIEW localized_de_ResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0;

CREATE VIEW localized_fr_ResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parentFunction_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0;

CREATE VIEW localized_de_AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_fr_AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_de_AllocationTermYearFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_fr_AllocationTermYearFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_de_AllocationTermFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_fr_AllocationTermFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_de_EarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.checkId,
  Checks_0.seq,
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_de_Checks AS Checks_0;

CREATE VIEW localized_fr_EarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.checkId,
  Checks_0.seq,
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_fr_Checks AS Checks_0;

CREATE VIEW localized_de_ParentAllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_de_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_fr_ParentAllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_fr_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_de_DriverFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0;

CREATE VIEW localized_fr_DriverFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.seq,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0;

CREATE VIEW localized_de_ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.sequence,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_de_Environments AS environments_0;

CREATE VIEW localized_fr_ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.sequence,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_fr_Environments AS environments_0;

CREATE VIEW localized_de_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.Function_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.senderInputFunction_ID,
  allocations_0.receiverInputFunction_ID,
  allocations_0.ResultFunction_ID,
  allocations_0.earlyExitCheck_checkId,
  allocations_0.rules_ID,
  allocations_0.offsets_ID,
  allocations_0.debitCredits_ID
FROM localized_de_Allocations AS allocations_0;

CREATE VIEW localized_fr_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.Function_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.senderInputFunction_ID,
  allocations_0.receiverInputFunction_ID,
  allocations_0.ResultFunction_ID,
  allocations_0.earlyExitCheck_checkId,
  allocations_0.rules_ID,
  allocations_0.offsets_ID,
  allocations_0.debitCredits_ID
FROM localized_fr_Allocations AS allocations_0;

CREATE VIEW localized_de_ModelingService_Allocations_senderFunctionSelections AS SELECT
  senderFunctionSelections_0.up__ID,
  senderFunctionSelections_0.createdAt,
  senderFunctionSelections_0.createdBy,
  senderFunctionSelections_0.modifiedAt,
  senderFunctionSelections_0.modifiedBy,
  senderFunctionSelections_0.environment_ID,
  senderFunctionSelections_0.Function_ID,
  senderFunctionSelections_0.field_ID,
  senderFunctionSelections_0.ID,
  senderFunctionSelections_0.sfield
FROM localized_de_Allocations_senderFunctionSelections AS senderFunctionSelections_0;

CREATE VIEW localized_fr_ModelingService_Allocations_senderFunctionSelections AS SELECT
  senderFunctionSelections_0.up__ID,
  senderFunctionSelections_0.createdAt,
  senderFunctionSelections_0.createdBy,
  senderFunctionSelections_0.modifiedAt,
  senderFunctionSelections_0.modifiedBy,
  senderFunctionSelections_0.environment_ID,
  senderFunctionSelections_0.Function_ID,
  senderFunctionSelections_0.field_ID,
  senderFunctionSelections_0.ID,
  senderFunctionSelections_0.sfield
FROM localized_fr_Allocations_senderFunctionSelections AS senderFunctionSelections_0;

CREATE VIEW localized_de_ModelingService_Allocations_receiverFunctionSelections AS SELECT
  receiverFunctionSelections_0.up__ID,
  receiverFunctionSelections_0.createdAt,
  receiverFunctionSelections_0.createdBy,
  receiverFunctionSelections_0.modifiedAt,
  receiverFunctionSelections_0.modifiedBy,
  receiverFunctionSelections_0.environment_ID,
  receiverFunctionSelections_0.Function_ID,
  receiverFunctionSelections_0.field_ID,
  receiverFunctionSelections_0.ID,
  receiverFunctionSelections_0.sfield
FROM localized_de_Allocations_receiverFunctionSelections AS receiverFunctionSelections_0;

CREATE VIEW localized_fr_ModelingService_Allocations_receiverFunctionSelections AS SELECT
  receiverFunctionSelections_0.up__ID,
  receiverFunctionSelections_0.createdAt,
  receiverFunctionSelections_0.createdBy,
  receiverFunctionSelections_0.modifiedAt,
  receiverFunctionSelections_0.modifiedBy,
  receiverFunctionSelections_0.environment_ID,
  receiverFunctionSelections_0.Function_ID,
  receiverFunctionSelections_0.field_ID,
  receiverFunctionSelections_0.ID,
  receiverFunctionSelections_0.sfield
FROM localized_fr_Allocations_receiverFunctionSelections AS receiverFunctionSelections_0;

CREATE VIEW localized_de_ModelingService_Allocations_selectionFields AS SELECT
  selectionFields_0.up__ID,
  selectionFields_0.createdAt,
  selectionFields_0.createdBy,
  selectionFields_0.modifiedAt,
  selectionFields_0.modifiedBy,
  selectionFields_0.environment_ID,
  selectionFields_0.Function_ID,
  selectionFields_0.field_ID,
  selectionFields_0.ID,
  selectionFields_0.sfield
FROM localized_de_Allocations_selectionFields AS selectionFields_0;

CREATE VIEW localized_fr_ModelingService_Allocations_selectionFields AS SELECT
  selectionFields_0.up__ID,
  selectionFields_0.createdAt,
  selectionFields_0.createdBy,
  selectionFields_0.modifiedAt,
  selectionFields_0.modifiedBy,
  selectionFields_0.environment_ID,
  selectionFields_0.Function_ID,
  selectionFields_0.field_ID,
  selectionFields_0.ID,
  selectionFields_0.sfield
FROM localized_fr_Allocations_selectionFields AS selectionFields_0;

CREATE VIEW localized_de_ModelingService_Allocations_actionFields AS SELECT
  actionFields_0.up__ID,
  actionFields_0.createdAt,
  actionFields_0.createdBy,
  actionFields_0.modifiedAt,
  actionFields_0.modifiedBy,
  actionFields_0.environment_ID,
  actionFields_0.Function_ID,
  actionFields_0.field_ID,
  actionFields_0.ID,
  actionFields_0.sfield
FROM localized_de_Allocations_actionFields AS actionFields_0;

CREATE VIEW localized_fr_ModelingService_Allocations_actionFields AS SELECT
  actionFields_0.up__ID,
  actionFields_0.createdAt,
  actionFields_0.createdBy,
  actionFields_0.modifiedAt,
  actionFields_0.modifiedBy,
  actionFields_0.environment_ID,
  actionFields_0.Function_ID,
  actionFields_0.field_ID,
  actionFields_0.ID,
  actionFields_0.sfield
FROM localized_fr_Allocations_actionFields AS actionFields_0;

CREATE VIEW localized_de_ModelingService_Allocations_rSelectionFields AS SELECT
  rSelectionFields_0.up__ID,
  rSelectionFields_0.createdAt,
  rSelectionFields_0.createdBy,
  rSelectionFields_0.modifiedAt,
  rSelectionFields_0.modifiedBy,
  rSelectionFields_0.environment_ID,
  rSelectionFields_0.Function_ID,
  rSelectionFields_0.field_ID,
  rSelectionFields_0.ID,
  rSelectionFields_0.sfield
FROM localized_de_Allocations_rSelectionFields AS rSelectionFields_0;

CREATE VIEW localized_fr_ModelingService_Allocations_rSelectionFields AS SELECT
  rSelectionFields_0.up__ID,
  rSelectionFields_0.createdAt,
  rSelectionFields_0.createdBy,
  rSelectionFields_0.modifiedAt,
  rSelectionFields_0.modifiedBy,
  rSelectionFields_0.environment_ID,
  rSelectionFields_0.Function_ID,
  rSelectionFields_0.field_ID,
  rSelectionFields_0.ID,
  rSelectionFields_0.sfield
FROM localized_fr_Allocations_rSelectionFields AS rSelectionFields_0;

CREATE VIEW localized_de_ModelingService_Allocations_rActionFields AS SELECT
  rActionFields_0.up__ID,
  rActionFields_0.createdAt,
  rActionFields_0.createdBy,
  rActionFields_0.modifiedAt,
  rActionFields_0.modifiedBy,
  rActionFields_0.environment_ID,
  rActionFields_0.Function_ID,
  rActionFields_0.field_ID,
  rActionFields_0.ID,
  rActionFields_0.sfield
FROM localized_de_Allocations_rActionFields AS rActionFields_0;

CREATE VIEW localized_fr_ModelingService_Allocations_rActionFields AS SELECT
  rActionFields_0.up__ID,
  rActionFields_0.createdAt,
  rActionFields_0.createdBy,
  rActionFields_0.modifiedAt,
  rActionFields_0.modifiedBy,
  rActionFields_0.environment_ID,
  rActionFields_0.Function_ID,
  rActionFields_0.field_ID,
  rActionFields_0.ID,
  rActionFields_0.sfield
FROM localized_fr_Allocations_rActionFields AS rActionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.Function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_de_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_fr_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.Function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_fr_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_de_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.Function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_de_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_fr_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.Function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_fr_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_de_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID
FROM localized_de_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_fr_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID
FROM localized_fr_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_de_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.Function_ID
FROM localized_de_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.Function_ID
FROM localized_fr_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_de_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.Function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM localized_de_ModelTables AS modelTables_0;

CREATE VIEW localized_fr_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.Function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM localized_fr_ModelTables AS modelTables_0;

CREATE VIEW localized_de_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_de_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.Function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.rule,
  AllocationRules_0.sequence,
  AllocationRules_0.type_code,
  AllocationRules_0.alMethod_code,
  AllocationRules_0.ruleState,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.scale_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.driverField_ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.fields_ID
FROM localized_fr_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_de_ModelingService_Allocations_checks AS SELECT
  checks_0.up__ID,
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.Function_ID,
  checks_0.ID,
  checks_0.check_checkId
FROM localized_de_Allocations_checks AS checks_0;

CREATE VIEW localized_fr_ModelingService_Allocations_checks AS SELECT
  checks_0.up__ID,
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.Function_ID,
  checks_0.ID,
  checks_0.check_checkId
FROM localized_fr_Allocations_checks AS checks_0;

CREATE VIEW localized_de_ModelingService_ParentAllocationRules AS SELECT
  ParentAllocationRules_0.createdAt,
  ParentAllocationRules_0.createdBy,
  ParentAllocationRules_0.modifiedAt,
  ParentAllocationRules_0.modifiedBy,
  ParentAllocationRules_0.environment_ID,
  ParentAllocationRules_0.Function_ID,
  ParentAllocationRules_0.ID,
  ParentAllocationRules_0.rule,
  ParentAllocationRules_0.sequence,
  ParentAllocationRules_0.type_code,
  ParentAllocationRules_0.alMethod_code,
  ParentAllocationRules_0.ruleState,
  ParentAllocationRules_0.parentRule_ID,
  ParentAllocationRules_0.senderRule_code,
  ParentAllocationRules_0.receiverRule_code,
  ParentAllocationRules_0.distributionBase,
  ParentAllocationRules_0.scale_code,
  ParentAllocationRules_0.senderShare,
  ParentAllocationRules_0.driverField_ID,
  ParentAllocationRules_0.allocation_ID,
  ParentAllocationRules_0.fields_ID
FROM localized_de_ParentAllocationRules AS ParentAllocationRules_0;

CREATE VIEW localized_fr_ModelingService_ParentAllocationRules AS SELECT
  ParentAllocationRules_0.createdAt,
  ParentAllocationRules_0.createdBy,
  ParentAllocationRules_0.modifiedAt,
  ParentAllocationRules_0.modifiedBy,
  ParentAllocationRules_0.environment_ID,
  ParentAllocationRules_0.Function_ID,
  ParentAllocationRules_0.ID,
  ParentAllocationRules_0.rule,
  ParentAllocationRules_0.sequence,
  ParentAllocationRules_0.type_code,
  ParentAllocationRules_0.alMethod_code,
  ParentAllocationRules_0.ruleState,
  ParentAllocationRules_0.parentRule_ID,
  ParentAllocationRules_0.senderRule_code,
  ParentAllocationRules_0.receiverRule_code,
  ParentAllocationRules_0.distributionBase,
  ParentAllocationRules_0.scale_code,
  ParentAllocationRules_0.senderShare,
  ParentAllocationRules_0.driverField_ID,
  ParentAllocationRules_0.allocation_ID,
  ParentAllocationRules_0.fields_ID
FROM localized_fr_ParentAllocationRules AS ParentAllocationRules_0;
