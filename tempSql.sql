
CREATE TABLE Environments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  description NVARCHAR(5000),
  parent_ID NVARCHAR(36),
  type_code NVARCHAR(5000) DEFAULT 'ENV_VER',
  PRIMARY KEY(ID),
  CONSTRAINT c__Environments_type
  FOREIGN KEY(type_code)
  REFERENCES EnvironmentTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Environments_environment UNIQUE (environment, version),
  CONSTRAINT Environments_description UNIQUE (description, version)
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
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Fields_field UNIQUE (environment_ID, field),
  CONSTRAINT Fields_description UNIQUE (environment_ID, description)
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
  parent_ID NVARCHAR(36),
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
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Functions_function UNIQUE (environment_ID, function),
  CONSTRAINT Functions_description UNIQUE (environment_ID, description)
);

CREATE TABLE FunctionTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'MT',
  PRIMARY KEY(code)
);

CREATE TABLE FunctionProcessingTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE FunctionBusinessEventTypes (
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
  function_ID NVARCHAR(36),
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
  senderFunction_ID NVARCHAR(36),
  receiverFunction_ID NVARCHAR(36),
  resultFunction_ID NVARCHAR(36),
  earlyExitCheck_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Allocations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_function
  FOREIGN KEY(function_ID)
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
  CONSTRAINT c__Allocations_cycleAggregation
  FOREIGN KEY(cycleAggregation_code)
  REFERENCES AllocationCycleAggregations(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_termProcessing
  FOREIGN KEY(termProcessing_code)
  REFERENCES AllocationTermProcessings(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationSenderViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationSenderViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViews_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationSenderViewSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationSenderViewSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViewSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViewSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViewSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSenderViewSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationSenderViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverViewSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverViewSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationReceiverViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationOffsets (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  offsetField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationOffsets_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
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
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  debitSign NVARCHAR(5000),
  creditSign NVARCHAR(5000),
  sequence INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationDebitCredits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
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

CREATE TABLE AllocationSelectionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationSelectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationActionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationActionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverSelectionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverSelectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverActionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverActionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  sequence INTEGER,
  rule NVARCHAR(5000),
  description NVARCHAR(5000),
  isActive BOOLEAN DEFAULT TRUE,
  type_code NVARCHAR(10) DEFAULT 'DIRECT',
  senderRule_code NVARCHAR(10) DEFAULT 'POST_AM',
  senderShare DECIMAL DEFAULT 100,
  method_code NVARCHAR(10) DEFAULT 'PR',
  distributionBase NVARCHAR(5000),
  parentRule_ID NVARCHAR(36),
  receiverRule_code NVARCHAR(10) DEFAULT 'VAR_POR',
  scale_code NVARCHAR(10) DEFAULT '',
  driverResultField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_type
  FOREIGN KEY(type_code)
  REFERENCES AllocationRuleTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_senderRule
  FOREIGN KEY(senderRule_code)
  REFERENCES AllocationSenderRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_method
  FOREIGN KEY(method_code)
  REFERENCES AllocationRuleMethods(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_parentRule
  FOREIGN KEY(parentRule_ID)
  REFERENCES AllocationRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_receiverRule
  FOREIGN KEY(receiverRule_code)
  REFERENCES AllocationReceiverRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_scale
  FOREIGN KEY(scale_code)
  REFERENCES AllocationRuleScales(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderValueFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleSenderValueFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationActionFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  group_code NVARCHAR(10) DEFAULT '',
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleSenderViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_group
  FOREIGN KEY(group_code)
  REFERENCES "Groups"(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleSenderFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationRuleSenderViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleReceiverViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  group_code NVARCHAR(10) DEFAULT '',
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleReceiverViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_group
  FOREIGN KEY(group_code)
  REFERENCES "Groups"(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleReceiverFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationRuleReceiverViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
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
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) DEFAULT 'ENV',
  transportData BOOLEAN,
  connName NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTables_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_function
  FOREIGN KEY(function_ID)
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
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnits_function
  FOREIGN KEY(function_ID)
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
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Orders (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Signs (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE Options (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(2) NOT NULL DEFAULT 'EQ',
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
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000),
  messageType_code NVARCHAR(1) DEFAULT 'I',
  category_code NVARCHAR(10) DEFAULT '',
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
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

CREATE TABLE CheckFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  check_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CheckFields_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CheckSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CheckSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES CheckFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CheckCategories (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE CurrencyConversions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  currencyConversion NVARCHAR(5000),
  description NVARCHAR(5000),
  category_code NVARCHAR(5000) DEFAULT 'CURRENCY',
  method_code NVARCHAR(5000) DEFAULT 'ERP',
  bidAskType_code NVARCHAR(5000) DEFAULT 'MID',
  marketDataArea NVARCHAR(5000),
  type NVARCHAR(5000),
  lookup_code NVARCHAR(5000) DEFAULT 'Regular',
  errorHandling_code NVARCHAR(5000) DEFAULT 'fail on error',
  accuracy_code NVARCHAR(5000) DEFAULT '',
  dateFormat_code NVARCHAR(5000) DEFAULT 'auto detect',
  steps_code NVARCHAR(5000) DEFAULT 'shift,convert',
  configurationConnection_ID NVARCHAR(36),
  rateConnection_ID NVARCHAR(36),
  prefactorConnection_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CurrencyConversions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_category
  FOREIGN KEY(category_code)
  REFERENCES ConversionCategories(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_method
  FOREIGN KEY(method_code)
  REFERENCES ConversionMethods(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_bidAskType
  FOREIGN KEY(bidAskType_code)
  REFERENCES ConversionBidAskTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_lookup
  FOREIGN KEY(lookup_code)
  REFERENCES ConversionLookups(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_errorHandling
  FOREIGN KEY(errorHandling_code)
  REFERENCES ConversionErrorHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_accuracy
  FOREIGN KEY(accuracy_code)
  REFERENCES ConversionAccuracies(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_dateFormat
  FOREIGN KEY(dateFormat_code)
  REFERENCES ConversionDateFormats(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_steps
  FOREIGN KEY(steps_code)
  REFERENCES ConversionSteps(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_configurationConnection
  FOREIGN KEY(configurationConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_rateConnection
  FOREIGN KEY(rateConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_prefactorConnection
  FOREIGN KEY(prefactorConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT CurrencyConversions_currencyConversion UNIQUE (environment_ID, currencyConversion),
  CONSTRAINT CurrencyConversions_description UNIQUE (environment_ID, description)
);

CREATE TABLE UnitConversions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  unitConversion NVARCHAR(5000),
  description NVARCHAR(5000),
  errorHandling_code NVARCHAR(5000) DEFAULT 'fail on error',
  rateConnection_ID NVARCHAR(36),
  dimensionConnection_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__UnitConversions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_errorHandling
  FOREIGN KEY(errorHandling_code)
  REFERENCES ConversionErrorHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_rateConnection
  FOREIGN KEY(rateConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_dimensionConnection
  FOREIGN KEY(dimensionConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT UnitConversions_unitConversion UNIQUE (environment_ID, unitConversion),
  CONSTRAINT UnitConversions_description UNIQUE (environment_ID, description)
);

CREATE TABLE ConversionCategories (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CURRENCY',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionMethods (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ERP',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionBidAskTypes (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'MID',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionLookups (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'Regular',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionErrorHandlings (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'fail on error',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionAccuracies (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionDateFormats (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'auto detect',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionSteps (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'shift,convert',
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

CREATE TABLE ConnectionEnvironments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  connection INTEGER NOT NULL,
  environment NVARCHAR(36),
  PRIMARY KEY(connection)
);

CREATE TABLE Connections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  connection NVARCHAR(5000),
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__Connections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Connections_description UNIQUE (environment_ID, description)
);

CREATE TABLE EnvironmentTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ENV_VER',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FieldClasses_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FieldTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(locale, code)
);

CREATE TABLE HanaDataTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'NVARCHAR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'MT',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionProcessingTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionBusinessEventTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ALLOC',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationValueAdjustments_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationTermProcessings_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationCycleAggregations_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DIRECT',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleMethods_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'PR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationSenderRules_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'POST_AM',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationReceiverRules_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'VAR_POR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleScales_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ModelTableTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENV',
  PRIMARY KEY(locale, code)
);

CREATE TABLE MessageTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Groups_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Orders_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Signs_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Options_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(2) NOT NULL DEFAULT 'EQ',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ResultHandlings_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENRICHED',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CheckCategories_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
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
  description NVARCHAR(5000) NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(5000) NULL DEFAULT 'ENV_VER',
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Fields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000) NULL,
  class_code NVARCHAR(5000) NULL DEFAULT '',
  type_code NVARCHAR(5000) NULL DEFAULT 'CHA',
  hanaDataType_code NVARCHAR(5000) NULL DEFAULT 'NVARCHAR',
  dataLength INTEGER NULL DEFAULT 16,
  dataDecimals INTEGER NULL DEFAULT 0,
  unitField_ID NVARCHAR(36) NULL,
  isLowercase BOOLEAN NULL DEFAULT TRUE,
  hasMasterData BOOLEAN NULL DEFAULT FALSE,
  hasHierarchies BOOLEAN NULL DEFAULT FALSE,
  calculationHierarchy_ID NVARCHAR(36) NULL,
  masterDataQuery_ID NVARCHAR(36) NULL,
  description NVARCHAR(5000) NULL,
  documentation NCLOB NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldValues_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  value NVARCHAR(5000) NULL,
  isNode BOOLEAN NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldValueAuthorizations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  value_ID NVARCHAR(36) NULL,
  userGrp NVARCHAR(5000) NULL,
  readAccess BOOLEAN NULL,
  writeAccess BOOLEAN NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldHierarchies_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  hierarchy NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldHierarchyStructures_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sequence INTEGER NULL,
  hierarchy_ID NVARCHAR(36) NULL,
  value_ID NVARCHAR(36) NULL,
  parentValue_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Checks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000) NULL,
  messageType_code NVARCHAR(1) NULL DEFAULT 'I',
  category_code NVARCHAR(10) NULL DEFAULT '',
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CheckFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  ID NVARCHAR(36) NOT NULL,
  check_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CheckSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CurrencyConversions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  currencyConversion NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  category_code NVARCHAR(5000) NULL DEFAULT 'CURRENCY',
  method_code NVARCHAR(5000) NULL DEFAULT 'ERP',
  bidAskType_code NVARCHAR(5000) NULL DEFAULT 'MID',
  marketDataArea NVARCHAR(5000) NULL,
  type NVARCHAR(5000) NULL,
  lookup_code NVARCHAR(5000) NULL DEFAULT 'Regular',
  errorHandling_code NVARCHAR(5000) NULL DEFAULT 'fail on error',
  accuracy_code NVARCHAR(5000) NULL DEFAULT '',
  dateFormat_code NVARCHAR(5000) NULL DEFAULT 'auto detect',
  steps_code NVARCHAR(5000) NULL DEFAULT 'shift,convert',
  configurationConnection_ID NVARCHAR(36) NULL,
  rateConnection_ID NVARCHAR(36) NULL,
  prefactorConnection_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_UnitConversions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  unitConversion NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  errorHandling_code NVARCHAR(5000) NULL DEFAULT 'fail on error',
  rateConnection_ID NVARCHAR(36) NULL,
  dimensionConnection_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Partitions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  "partition" NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_PartitionRanges_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  partition_ID NVARCHAR(36) NULL,
  "range" NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  level INTEGER NULL DEFAULT 0,
  value NVARCHAR(5000) NULL,
  hanaVolumeId INTEGER NULL DEFAULT 0,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Functions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'MT',
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  parentCalculationUnit_ID NVARCHAR(36) NULL,
  description NVARCHAR(5000) NULL,
  documentation NCLOB NULL,
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
  function_ID NVARCHAR(36) NULL,
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
  senderFunction_ID NVARCHAR(36) NULL,
  receiverFunction_ID NVARCHAR(36) NULL,
  resultFunction_ID NVARCHAR(36) NULL,
  earlyExitCheck_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationSenderViews_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationSenderViewSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationInputFunctions_drafts (
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'MT',
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverViews_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverViewSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationResultFunctions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'MT',
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  parentCalculationUnit_ID NVARCHAR(36) NULL,
  description NVARCHAR(5000) NULL,
  documentation NCLOB NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationSelectionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationActionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverSelectionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverActionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  rule NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  isActive BOOLEAN NULL DEFAULT TRUE,
  type_code NVARCHAR(10) NULL DEFAULT 'DIRECT',
  senderRule_code NVARCHAR(10) NULL DEFAULT 'POST_AM',
  senderShare DECIMAL NULL DEFAULT 100,
  method_code NVARCHAR(10) NULL DEFAULT 'PR',
  distributionBase NVARCHAR(5000) NULL,
  parentRule_ID NVARCHAR(36) NULL,
  receiverRule_code NVARCHAR(10) NULL DEFAULT 'VAR_POR',
  scale_code NVARCHAR(10) NULL DEFAULT '',
  driverResultField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderValueFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderViews_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  group_code NVARCHAR(10) NULL DEFAULT '',
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
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
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
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
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
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

CREATE TABLE ModelingService_AllocationChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationUnits_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_ModelTables_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
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
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM Environments AS environments_0;

CREATE VIEW ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM Fields AS fields_0;

CREATE VIEW ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM Checks AS checks_0;

CREATE VIEW ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM CurrencyConversions AS currencyConversions_0;

CREATE VIEW ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM UnitConversions AS unitConversions_0;

CREATE VIEW ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM Partitions AS partitions_0;

CREATE VIEW ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.processingType_code,
  functions_0.businessEventType_code,
  functions_0.partition_ID,
  functions_0.parentCalculationUnit_ID,
  functions_0.description,
  functions_0.documentation
FROM Functions AS functions_0;

CREATE VIEW ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
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
  allocations_0.senderFunction_ID,
  allocations_0.receiverFunction_ID,
  allocations_0.resultFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM Allocations AS allocations_0;

CREATE VIEW ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM CalculationUnits AS calculationUnits_0;

CREATE VIEW ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM ModelTables AS modelTables_0;

CREATE VIEW EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW FunctionParents AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW AllocationInputFunctions AS SELECT
  F_0.ID,
  F_0.function,
  F_0.description,
  F_0.type_code
FROM Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW AllocationResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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

CREATE VIEW AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM Checks AS Checks_0;

CREATE VIEW AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (AllocationActionFields AS L_1 LEFT JOIN Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (AllocationActionFields AS L_1 LEFT JOIN Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW EnvironmentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW EnvironmentFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
WHERE Fields_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW EnvironmentChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM Checks AS Checks_0
WHERE Checks_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW EnvironmentPartitions AS SELECT
  Partitions_0.createdAt,
  Partitions_0.createdBy,
  Partitions_0.modifiedAt,
  Partitions_0.modifiedBy,
  Partitions_0.environment_ID,
  Partitions_0.ID,
  Partitions_0."partition",
  Partitions_0.description,
  Partitions_0.field_ID
FROM Partitions AS Partitions_0
WHERE Partitions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM FieldClasses AS FieldClasses_0;

CREATE VIEW ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM FieldTypes AS FieldTypes_0;

CREATE VIEW ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM FieldValues AS FieldValues_0;

CREATE VIEW ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM MessageTypes AS MessageTypes_0;

CREATE VIEW ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM CheckCategories AS CheckCategories_0;

CREATE VIEW ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM CheckFields AS CheckFields_0;

CREATE VIEW ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value,
  PartitionRanges_0.hanaVolumeId
FROM PartitionRanges AS PartitionRanges_0;

CREATE VIEW ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM FunctionTypes AS FunctionTypes_0;

CREATE VIEW ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

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

CREATE VIEW ModelingService_AllocationSenderViews AS SELECT
  AllocationSenderViews_0.createdAt,
  AllocationSenderViews_0.createdBy,
  AllocationSenderViews_0.modifiedAt,
  AllocationSenderViews_0.modifiedBy,
  AllocationSenderViews_0.environment_ID,
  AllocationSenderViews_0.function_ID,
  AllocationSenderViews_0.formula,
  AllocationSenderViews_0.order_code,
  AllocationSenderViews_0.ID,
  AllocationSenderViews_0.allocation_ID,
  AllocationSenderViews_0.field_ID
FROM AllocationSenderViews AS AllocationSenderViews_0;

CREATE VIEW ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM AllocationRules AS AllocationRules_0;

CREATE VIEW ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM AllocationChecks AS AllocationChecks_0;

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

CREATE VIEW ModelingService_FieldClasses_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FieldClasses_texts AS texts_0;

CREATE VIEW ModelingService_FieldTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FieldTypes_texts AS texts_0;

CREATE VIEW ModelingService_HanaDataTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM HanaDataTypes_texts AS texts_0;

CREATE VIEW ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW ModelingService_MessageTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM MessageTypes_texts AS texts_0;

CREATE VIEW ModelingService_CheckCategories_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CheckCategories_texts AS texts_0;

CREATE VIEW ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM CheckSelections AS CheckSelections_0;

CREATE VIEW ModelingService_FunctionTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionTypes_texts AS texts_0;

CREATE VIEW ModelingService_FunctionProcessingTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionProcessingTypes_texts AS texts_0;

CREATE VIEW ModelingService_FunctionBusinessEventTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionBusinessEventTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationValueAdjustments_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationValueAdjustments_texts AS texts_0;

CREATE VIEW ModelingService_ResultHandlings_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ResultHandlings_texts AS texts_0;

CREATE VIEW ModelingService_AllocationCycleAggregations_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationCycleAggregations_texts AS texts_0;

CREATE VIEW ModelingService_AllocationTermProcessings_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationTermProcessings_texts AS texts_0;

CREATE VIEW ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM Orders AS Orders_0;

CREATE VIEW ModelingService_AllocationSenderViewSelections AS SELECT
  AllocationSenderViewSelections_0.createdAt,
  AllocationSenderViewSelections_0.createdBy,
  AllocationSenderViewSelections_0.modifiedAt,
  AllocationSenderViewSelections_0.modifiedBy,
  AllocationSenderViewSelections_0.environment_ID,
  AllocationSenderViewSelections_0.function_ID,
  AllocationSenderViewSelections_0.seq,
  AllocationSenderViewSelections_0.sign_code,
  AllocationSenderViewSelections_0.opt_code,
  AllocationSenderViewSelections_0.low,
  AllocationSenderViewSelections_0.high,
  AllocationSenderViewSelections_0.ID,
  AllocationSenderViewSelections_0.field_ID
FROM AllocationSenderViewSelections AS AllocationSenderViewSelections_0;

CREATE VIEW ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

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

CREATE VIEW ModelingService_ModelTableTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ModelTableTypes_texts AS texts_0;

CREATE VIEW ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM Signs AS Signs_0;

CREATE VIEW ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM Options AS Options_0;

CREATE VIEW ModelingService_Orders_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Orders_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationSenderRules_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationSenderRules_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleMethods_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleMethods_texts AS texts_0;

CREATE VIEW ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM "Groups" AS Groups_0;

CREATE VIEW ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW ModelingService_AllocationReceiverRules_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationReceiverRules_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleScales_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleScales_texts AS texts_0;

CREATE VIEW ModelingService_Signs_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Signs_texts AS texts_0;

CREATE VIEW ModelingService_Options_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Options_texts AS texts_0;

CREATE VIEW ModelingService_Groups_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Groups_texts AS texts_0;

CREATE VIEW localized_EnvironmentTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FieldClasses AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FieldTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_HanaDataTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionProcessingTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationValueAdjustments AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationTermProcessings AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationCycleAggregations AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleMethods AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationSenderRules AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationReceiverRules AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleScales AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ModelTableTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_MessageTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Groups AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Orders AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Signs AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Options AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ResultHandlings AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CheckCategories AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
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

CREATE VIEW localized_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parent_ID,
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
  L.function_ID,
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
  L.senderFunction_ID,
  L.receiverFunction_ID,
  L.resultFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_AllocationSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSenderViews AS L;

CREATE VIEW localized_AllocationSenderViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationSenderViewSelections AS L;

CREATE VIEW localized_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

CREATE VIEW localized_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connName
FROM ModelTables AS L;

CREATE VIEW localized_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."check",
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

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

CREATE VIEW localized_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

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
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

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

CREATE VIEW localized_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description
FROM Connections AS L;

CREATE VIEW localized_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

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
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM UnitFields AS UnitFields_0;

CREATE VIEW ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.processingType_code,
  MasterDataQueries_0.businessEventType_code,
  MasterDataQueries_0.partition_ID,
  MasterDataQueries_0.parentCalculationUnit_ID,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW ModelingService_FunctionParents AS SELECT
  FunctionParents_0.createdAt,
  FunctionParents_0.createdBy,
  FunctionParents_0.modifiedAt,
  FunctionParents_0.modifiedBy,
  FunctionParents_0.environment_ID,
  FunctionParents_0.ID,
  FunctionParents_0.function,
  FunctionParents_0.sequence,
  FunctionParents_0.parent_ID,
  FunctionParents_0.type_code,
  FunctionParents_0.processingType_code,
  FunctionParents_0.businessEventType_code,
  FunctionParents_0.partition_ID,
  FunctionParents_0.parentCalculationUnit_ID,
  FunctionParents_0.description,
  FunctionParents_0.documentation
FROM FunctionParents AS FunctionParents_0;

CREATE VIEW ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW ModelingService_AllocationInputFunctions AS SELECT
  AllocationInputFunctions_0.ID,
  AllocationInputFunctions_0.function,
  AllocationInputFunctions_0.description,
  AllocationInputFunctions_0.type_code
FROM AllocationInputFunctions AS AllocationInputFunctions_0;

CREATE VIEW ModelingService_AllocationResultFunctions AS SELECT
  AllocationResultFunctions_0.createdAt,
  AllocationResultFunctions_0.createdBy,
  AllocationResultFunctions_0.modifiedAt,
  AllocationResultFunctions_0.modifiedBy,
  AllocationResultFunctions_0.environment_ID,
  AllocationResultFunctions_0.ID,
  AllocationResultFunctions_0.function,
  AllocationResultFunctions_0.sequence,
  AllocationResultFunctions_0.parent_ID,
  AllocationResultFunctions_0.type_code,
  AllocationResultFunctions_0.processingType_code,
  AllocationResultFunctions_0.businessEventType_code,
  AllocationResultFunctions_0.partition_ID,
  AllocationResultFunctions_0.parentCalculationUnit_ID,
  AllocationResultFunctions_0.description,
  AllocationResultFunctions_0.documentation
FROM AllocationResultFunctions AS AllocationResultFunctions_0;

CREATE VIEW ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_FunctionParents AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_AllocationInputFunctions AS SELECT
  F_0.ID,
  F_0.function,
  F_0.description,
  F_0.type_code
FROM localized_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_AllocationResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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

CREATE VIEW localized_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_Checks AS Checks_0;

CREATE VIEW localized_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_AllocationActionFields AS L_1 LEFT JOIN localized_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_AllocationActionFields AS L_1 LEFT JOIN localized_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_EnvironmentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_EnvironmentFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
WHERE Fields_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_EnvironmentChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_Checks AS Checks_0
WHERE Checks_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_Orders AS Orders_0;

CREATE VIEW localized_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_Signs AS Signs_0;

CREATE VIEW localized_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_Options AS Options_0;

CREATE VIEW localized_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_Groups AS Groups_0;

CREATE VIEW localized_EnvironmentPartitions AS SELECT
  Partitions_0.createdAt,
  Partitions_0.createdBy,
  Partitions_0.modifiedAt,
  Partitions_0.modifiedBy,
  Partitions_0.environment_ID,
  Partitions_0.ID,
  Partitions_0."partition",
  Partitions_0.description,
  Partitions_0.field_ID
FROM localized_Partitions AS Partitions_0
WHERE Partitions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.processingType_code,
  functions_0.businessEventType_code,
  functions_0.partition_ID,
  functions_0.parentCalculationUnit_ID,
  functions_0.description,
  functions_0.documentation
FROM localized_Functions AS functions_0;

CREATE VIEW localized_ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_Environments AS environments_0;

CREATE VIEW localized_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_Fields AS fields_0;

CREATE VIEW localized_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_Checks AS checks_0;

CREATE VIEW localized_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
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
  allocations_0.senderFunction_ID,
  allocations_0.receiverFunction_ID,
  allocations_0.resultFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_Allocations AS allocations_0;

CREATE VIEW localized_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM localized_ModelTables AS modelTables_0;

CREATE VIEW localized_ModelingService_AllocationSenderViews AS SELECT
  AllocationSenderViews_0.createdAt,
  AllocationSenderViews_0.createdBy,
  AllocationSenderViews_0.modifiedAt,
  AllocationSenderViews_0.modifiedBy,
  AllocationSenderViews_0.environment_ID,
  AllocationSenderViews_0.function_ID,
  AllocationSenderViews_0.formula,
  AllocationSenderViews_0.order_code,
  AllocationSenderViews_0.ID,
  AllocationSenderViews_0.allocation_ID,
  AllocationSenderViews_0.field_ID
FROM localized_AllocationSenderViews AS AllocationSenderViews_0;

CREATE VIEW localized_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_ModelingService_AllocationSenderViewSelections AS SELECT
  AllocationSenderViewSelections_0.createdAt,
  AllocationSenderViewSelections_0.createdBy,
  AllocationSenderViewSelections_0.modifiedAt,
  AllocationSenderViewSelections_0.modifiedBy,
  AllocationSenderViewSelections_0.environment_ID,
  AllocationSenderViewSelections_0.function_ID,
  AllocationSenderViewSelections_0.seq,
  AllocationSenderViewSelections_0.sign_code,
  AllocationSenderViewSelections_0.opt_code,
  AllocationSenderViewSelections_0.low,
  AllocationSenderViewSelections_0.high,
  AllocationSenderViewSelections_0.ID,
  AllocationSenderViewSelections_0.field_ID
FROM localized_AllocationSenderViewSelections AS AllocationSenderViewSelections_0;

CREATE VIEW localized_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_UnitConversions AS unitConversions_0;

CREATE VIEW localized_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_Partitions AS partitions_0;

CREATE VIEW localized_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_FieldValues AS FieldValues_0;

CREATE VIEW localized_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value,
  PartitionRanges_0.hanaVolumeId
FROM localized_PartitionRanges AS PartitionRanges_0;

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

CREATE VIEW localized_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_CheckFields AS CheckFields_0;

CREATE VIEW localized_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.processingType_code,
  MasterDataQueries_0.businessEventType_code,
  MasterDataQueries_0.partition_ID,
  MasterDataQueries_0.parentCalculationUnit_ID,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_ModelingService_FunctionParents AS SELECT
  FunctionParents_0.createdAt,
  FunctionParents_0.createdBy,
  FunctionParents_0.modifiedAt,
  FunctionParents_0.modifiedBy,
  FunctionParents_0.environment_ID,
  FunctionParents_0.ID,
  FunctionParents_0.function,
  FunctionParents_0.sequence,
  FunctionParents_0.parent_ID,
  FunctionParents_0.type_code,
  FunctionParents_0.processingType_code,
  FunctionParents_0.businessEventType_code,
  FunctionParents_0.partition_ID,
  FunctionParents_0.parentCalculationUnit_ID,
  FunctionParents_0.description,
  FunctionParents_0.documentation
FROM localized_FunctionParents AS FunctionParents_0;

CREATE VIEW localized_ModelingService_AllocationResultFunctions AS SELECT
  AllocationResultFunctions_0.createdAt,
  AllocationResultFunctions_0.createdBy,
  AllocationResultFunctions_0.modifiedAt,
  AllocationResultFunctions_0.modifiedBy,
  AllocationResultFunctions_0.environment_ID,
  AllocationResultFunctions_0.ID,
  AllocationResultFunctions_0.function,
  AllocationResultFunctions_0.sequence,
  AllocationResultFunctions_0.parent_ID,
  AllocationResultFunctions_0.type_code,
  AllocationResultFunctions_0.processingType_code,
  AllocationResultFunctions_0.businessEventType_code,
  AllocationResultFunctions_0.partition_ID,
  AllocationResultFunctions_0.parentCalculationUnit_ID,
  AllocationResultFunctions_0.description,
  AllocationResultFunctions_0.documentation
FROM localized_AllocationResultFunctions AS AllocationResultFunctions_0;

CREATE VIEW localized_ModelingService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW localized_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_UnitFields AS UnitFields_0;

CREATE VIEW localized_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_ModelingService_AllocationInputFunctions AS SELECT
  AllocationInputFunctions_0.ID,
  AllocationInputFunctions_0.function,
  AllocationInputFunctions_0.description,
  AllocationInputFunctions_0.type_code
FROM localized_AllocationInputFunctions AS AllocationInputFunctions_0;

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

CREATE VIEW localized_de_FieldClasses AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FieldClasses AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FieldTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FieldTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_HanaDataTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_HanaDataTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionProcessingTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionProcessingTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationValueAdjustments AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationValueAdjustments AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationTermProcessings AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationTermProcessings AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationCycleAggregations AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationCycleAggregations AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleMethods AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleMethods AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationSenderRules AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationSenderRules AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationReceiverRules AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationReceiverRules AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleScales AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleScales AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ModelTableTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ModelTableTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_MessageTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_MessageTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Groups AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Groups AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Orders AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Orders AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Signs AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Signs AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Options AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Options AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ResultHandlings AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ResultHandlings AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CheckCategories AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CheckCategories AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
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

CREATE VIEW localized_de_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parent_ID,
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
  L.parent_ID,
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
  L.function_ID,
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
  L.senderFunction_ID,
  L.receiverFunction_ID,
  L.resultFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_fr_Allocations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
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
  L.senderFunction_ID,
  L.receiverFunction_ID,
  L.resultFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_de_AllocationSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSenderViews AS L;

CREATE VIEW localized_fr_AllocationSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSenderViews AS L;

CREATE VIEW localized_de_AllocationSenderViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationSenderViewSelections AS L;

CREATE VIEW localized_fr_AllocationSenderViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationSenderViewSelections AS L;

CREATE VIEW localized_de_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_fr_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_de_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_fr_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_de_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_fr_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_de_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_fr_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_de_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_fr_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_de_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_fr_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_de_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

CREATE VIEW localized_fr_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

CREATE VIEW localized_de_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
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
  L.function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connName
FROM ModelTables AS L;

CREATE VIEW localized_de_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."check",
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
  L.ID,
  L."check",
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_de_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

CREATE VIEW localized_fr_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

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

CREATE VIEW localized_de_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_fr_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_de_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
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
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_de_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_fr_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_de_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_fr_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_de_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_fr_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_de_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_fr_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_de_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_fr_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_de_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

CREATE VIEW localized_fr_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

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
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_fr_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_de_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_fr_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_de_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

CREATE VIEW localized_fr_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

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

CREATE VIEW localized_de_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description
FROM Connections AS L;

CREATE VIEW localized_fr_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description
FROM Connections AS L;

CREATE VIEW localized_de_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

CREATE VIEW localized_fr_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

CREATE VIEW localized_de_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_de_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_fr_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_fr_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_de_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
  Functions_0.parent_ID,
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_FunctionParents AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_fr_FunctionParents AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
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
  Functions_0.parent_ID,
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
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_fr_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_de_AllocationInputFunctions AS SELECT
  F_0.ID,
  F_0.function,
  F_0.description,
  F_0.type_code
FROM localized_de_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_fr_AllocationInputFunctions AS SELECT
  F_0.ID,
  F_0.function,
  F_0.description,
  F_0.type_code
FROM localized_fr_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_de_AllocationResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_fr_AllocationResultFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_AllocationTermIterationFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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

CREATE VIEW localized_de_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_de_Checks AS Checks_0;

CREATE VIEW localized_fr_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_fr_Checks AS Checks_0;

CREATE VIEW localized_de_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_de_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_de_AllocationActionFields AS L_1 LEFT JOIN localized_de_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_fr_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_fr_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_fr_AllocationActionFields AS L_1 LEFT JOIN localized_fr_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_de_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_de_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_de_AllocationActionFields AS L_1 LEFT JOIN localized_de_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_fr_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_fr_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM (localized_fr_AllocationActionFields AS L_1 LEFT JOIN localized_fr_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID)
  WHERE F_0.environment_ID = allocation_2.environment_ID);

CREATE VIEW localized_de_EnvironmentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_fr_EnvironmentFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.processingType_code,
  Functions_0.businessEventType_code,
  Functions_0.partition_ID,
  Functions_0.parentCalculationUnit_ID,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_de_EnvironmentFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
WHERE Fields_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_fr_EnvironmentFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
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
WHERE Fields_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_de_EnvironmentChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_de_Checks AS Checks_0
WHERE Checks_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_fr_EnvironmentChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_fr_Checks AS Checks_0
WHERE Checks_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

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

CREATE VIEW localized_de_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_de_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_fr_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_fr_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_de_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_de_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_fr_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_fr_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_de_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_de_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_fr_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_fr_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_de_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_de_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_fr_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_fr_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_de_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_de_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_fr_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_fr_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_de_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_de_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_fr_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_de_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_de_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_fr_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_de_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_de_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_fr_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_de_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_fr_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_fr_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_de_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_fr_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_fr_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_de_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_de_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_fr_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_fr_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_de_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_de_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_fr_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_fr_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_de_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_de_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_fr_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_de_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_de_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_fr_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_fr_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_de_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_de_Orders AS Orders_0;

CREATE VIEW localized_fr_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_fr_Orders AS Orders_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_de_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_fr_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_de_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_fr_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_de_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_fr_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_de_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_fr_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_de_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_fr_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_de_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_de_Signs AS Signs_0;

CREATE VIEW localized_fr_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_fr_Signs AS Signs_0;

CREATE VIEW localized_de_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_de_Options AS Options_0;

CREATE VIEW localized_fr_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_fr_Options AS Options_0;

CREATE VIEW localized_de_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_de_Groups AS Groups_0;

CREATE VIEW localized_fr_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_fr_Groups AS Groups_0;

CREATE VIEW localized_de_EnvironmentPartitions AS SELECT
  Partitions_0.createdAt,
  Partitions_0.createdBy,
  Partitions_0.modifiedAt,
  Partitions_0.modifiedBy,
  Partitions_0.environment_ID,
  Partitions_0.ID,
  Partitions_0."partition",
  Partitions_0.description,
  Partitions_0.field_ID
FROM localized_de_Partitions AS Partitions_0
WHERE Partitions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_fr_EnvironmentPartitions AS SELECT
  Partitions_0.createdAt,
  Partitions_0.createdBy,
  Partitions_0.modifiedAt,
  Partitions_0.modifiedBy,
  Partitions_0.environment_ID,
  Partitions_0.ID,
  Partitions_0."partition",
  Partitions_0.description,
  Partitions_0.field_ID
FROM localized_fr_Partitions AS Partitions_0
WHERE Partitions_0.environment_ID IN (SELECT
    ConnectionEnvironments_1.environment
  FROM ConnectionEnvironments AS ConnectionEnvironments_1
  WHERE ConnectionEnvironments_1.connection = '1');

CREATE VIEW localized_de_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.processingType_code,
  functions_0.businessEventType_code,
  functions_0.partition_ID,
  functions_0.parentCalculationUnit_ID,
  functions_0.description,
  functions_0.documentation
FROM localized_de_Functions AS functions_0;

CREATE VIEW localized_fr_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.processingType_code,
  functions_0.businessEventType_code,
  functions_0.partition_ID,
  functions_0.parentCalculationUnit_ID,
  functions_0.description,
  functions_0.documentation
FROM localized_fr_Functions AS functions_0;

CREATE VIEW localized_de_ModelingService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
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
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_fr_Environments AS environments_0;

CREATE VIEW localized_de_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_de_Fields AS fields_0;

CREATE VIEW localized_fr_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_fr_Fields AS fields_0;

CREATE VIEW localized_de_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_de_Checks AS checks_0;

CREATE VIEW localized_fr_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_fr_Checks AS checks_0;

CREATE VIEW localized_de_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
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
  allocations_0.senderFunction_ID,
  allocations_0.receiverFunction_ID,
  allocations_0.resultFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_de_Allocations AS allocations_0;

CREATE VIEW localized_fr_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
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
  allocations_0.senderFunction_ID,
  allocations_0.receiverFunction_ID,
  allocations_0.resultFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_fr_Allocations AS allocations_0;

CREATE VIEW localized_de_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
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
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connName
FROM localized_fr_ModelTables AS modelTables_0;

CREATE VIEW localized_de_ModelingService_AllocationSenderViews AS SELECT
  AllocationSenderViews_0.createdAt,
  AllocationSenderViews_0.createdBy,
  AllocationSenderViews_0.modifiedAt,
  AllocationSenderViews_0.modifiedBy,
  AllocationSenderViews_0.environment_ID,
  AllocationSenderViews_0.function_ID,
  AllocationSenderViews_0.formula,
  AllocationSenderViews_0.order_code,
  AllocationSenderViews_0.ID,
  AllocationSenderViews_0.allocation_ID,
  AllocationSenderViews_0.field_ID
FROM localized_de_AllocationSenderViews AS AllocationSenderViews_0;

CREATE VIEW localized_fr_ModelingService_AllocationSenderViews AS SELECT
  AllocationSenderViews_0.createdAt,
  AllocationSenderViews_0.createdBy,
  AllocationSenderViews_0.modifiedAt,
  AllocationSenderViews_0.modifiedBy,
  AllocationSenderViews_0.environment_ID,
  AllocationSenderViews_0.function_ID,
  AllocationSenderViews_0.formula,
  AllocationSenderViews_0.order_code,
  AllocationSenderViews_0.ID,
  AllocationSenderViews_0.allocation_ID,
  AllocationSenderViews_0.field_ID
FROM localized_fr_AllocationSenderViews AS AllocationSenderViews_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_de_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_fr_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_de_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_fr_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_de_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_de_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_fr_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_de_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_de_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_fr_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_fr_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationSenderViewSelections AS SELECT
  AllocationSenderViewSelections_0.createdAt,
  AllocationSenderViewSelections_0.createdBy,
  AllocationSenderViewSelections_0.modifiedAt,
  AllocationSenderViewSelections_0.modifiedBy,
  AllocationSenderViewSelections_0.environment_ID,
  AllocationSenderViewSelections_0.function_ID,
  AllocationSenderViewSelections_0.seq,
  AllocationSenderViewSelections_0.sign_code,
  AllocationSenderViewSelections_0.opt_code,
  AllocationSenderViewSelections_0.low,
  AllocationSenderViewSelections_0.high,
  AllocationSenderViewSelections_0.ID,
  AllocationSenderViewSelections_0.field_ID
FROM localized_de_AllocationSenderViewSelections AS AllocationSenderViewSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationSenderViewSelections AS SELECT
  AllocationSenderViewSelections_0.createdAt,
  AllocationSenderViewSelections_0.createdBy,
  AllocationSenderViewSelections_0.modifiedAt,
  AllocationSenderViewSelections_0.modifiedBy,
  AllocationSenderViewSelections_0.environment_ID,
  AllocationSenderViewSelections_0.function_ID,
  AllocationSenderViewSelections_0.seq,
  AllocationSenderViewSelections_0.sign_code,
  AllocationSenderViewSelections_0.opt_code,
  AllocationSenderViewSelections_0.low,
  AllocationSenderViewSelections_0.high,
  AllocationSenderViewSelections_0.ID,
  AllocationSenderViewSelections_0.field_ID
FROM localized_fr_AllocationSenderViewSelections AS AllocationSenderViewSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_de_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_fr_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_de_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_fr_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_de_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_de_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_fr_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_fr_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_de_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_de_UnitConversions AS unitConversions_0;

CREATE VIEW localized_fr_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_fr_UnitConversions AS unitConversions_0;

CREATE VIEW localized_de_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_de_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_fr_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_de_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_de_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_fr_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_de_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_fr_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_de_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_fr_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_de_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_fr_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_de_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_fr_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_fr_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_de_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
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
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_fr_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_de_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_de_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_fr_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_fr_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_de_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_fr_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_de_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_de_Partitions AS partitions_0;

CREATE VIEW localized_fr_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_fr_Partitions AS partitions_0;

CREATE VIEW localized_de_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_de_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_fr_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_fr_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_de_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_de_FieldValues AS FieldValues_0;

CREATE VIEW localized_fr_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_fr_FieldValues AS FieldValues_0;

CREATE VIEW localized_de_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value,
  PartitionRanges_0.hanaVolumeId
FROM localized_de_PartitionRanges AS PartitionRanges_0;

CREATE VIEW localized_fr_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value,
  PartitionRanges_0.hanaVolumeId
FROM localized_fr_PartitionRanges AS PartitionRanges_0;

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

CREATE VIEW localized_de_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_de_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_fr_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_fr_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_de_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_de_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_fr_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_fr_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_de_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_de_CheckFields AS CheckFields_0;

CREATE VIEW localized_fr_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_fr_CheckFields AS CheckFields_0;

CREATE VIEW localized_de_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.processingType_code,
  MasterDataQueries_0.businessEventType_code,
  MasterDataQueries_0.partition_ID,
  MasterDataQueries_0.parentCalculationUnit_ID,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_de_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_fr_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.processingType_code,
  MasterDataQueries_0.businessEventType_code,
  MasterDataQueries_0.partition_ID,
  MasterDataQueries_0.parentCalculationUnit_ID,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_fr_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_de_ModelingService_FunctionParents AS SELECT
  FunctionParents_0.createdAt,
  FunctionParents_0.createdBy,
  FunctionParents_0.modifiedAt,
  FunctionParents_0.modifiedBy,
  FunctionParents_0.environment_ID,
  FunctionParents_0.ID,
  FunctionParents_0.function,
  FunctionParents_0.sequence,
  FunctionParents_0.parent_ID,
  FunctionParents_0.type_code,
  FunctionParents_0.processingType_code,
  FunctionParents_0.businessEventType_code,
  FunctionParents_0.partition_ID,
  FunctionParents_0.parentCalculationUnit_ID,
  FunctionParents_0.description,
  FunctionParents_0.documentation
FROM localized_de_FunctionParents AS FunctionParents_0;

CREATE VIEW localized_fr_ModelingService_FunctionParents AS SELECT
  FunctionParents_0.createdAt,
  FunctionParents_0.createdBy,
  FunctionParents_0.modifiedAt,
  FunctionParents_0.modifiedBy,
  FunctionParents_0.environment_ID,
  FunctionParents_0.ID,
  FunctionParents_0.function,
  FunctionParents_0.sequence,
  FunctionParents_0.parent_ID,
  FunctionParents_0.type_code,
  FunctionParents_0.processingType_code,
  FunctionParents_0.businessEventType_code,
  FunctionParents_0.partition_ID,
  FunctionParents_0.parentCalculationUnit_ID,
  FunctionParents_0.description,
  FunctionParents_0.documentation
FROM localized_fr_FunctionParents AS FunctionParents_0;

CREATE VIEW localized_de_ModelingService_AllocationResultFunctions AS SELECT
  AllocationResultFunctions_0.createdAt,
  AllocationResultFunctions_0.createdBy,
  AllocationResultFunctions_0.modifiedAt,
  AllocationResultFunctions_0.modifiedBy,
  AllocationResultFunctions_0.environment_ID,
  AllocationResultFunctions_0.ID,
  AllocationResultFunctions_0.function,
  AllocationResultFunctions_0.sequence,
  AllocationResultFunctions_0.parent_ID,
  AllocationResultFunctions_0.type_code,
  AllocationResultFunctions_0.processingType_code,
  AllocationResultFunctions_0.businessEventType_code,
  AllocationResultFunctions_0.partition_ID,
  AllocationResultFunctions_0.parentCalculationUnit_ID,
  AllocationResultFunctions_0.description,
  AllocationResultFunctions_0.documentation
FROM localized_de_AllocationResultFunctions AS AllocationResultFunctions_0;

CREATE VIEW localized_fr_ModelingService_AllocationResultFunctions AS SELECT
  AllocationResultFunctions_0.createdAt,
  AllocationResultFunctions_0.createdBy,
  AllocationResultFunctions_0.modifiedAt,
  AllocationResultFunctions_0.modifiedBy,
  AllocationResultFunctions_0.environment_ID,
  AllocationResultFunctions_0.ID,
  AllocationResultFunctions_0.function,
  AllocationResultFunctions_0.sequence,
  AllocationResultFunctions_0.parent_ID,
  AllocationResultFunctions_0.type_code,
  AllocationResultFunctions_0.processingType_code,
  AllocationResultFunctions_0.businessEventType_code,
  AllocationResultFunctions_0.partition_ID,
  AllocationResultFunctions_0.parentCalculationUnit_ID,
  AllocationResultFunctions_0.description,
  AllocationResultFunctions_0.documentation
FROM localized_fr_AllocationResultFunctions AS AllocationResultFunctions_0;

CREATE VIEW localized_de_ModelingService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_de_EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW localized_fr_ModelingService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_fr_EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW localized_de_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_de_UnitFields AS UnitFields_0;

CREATE VIEW localized_fr_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_fr_UnitFields AS UnitFields_0;

CREATE VIEW localized_de_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_de_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_fr_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_de_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_fr_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_de_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_fr_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_de_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_fr_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_de_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_fr_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_de_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_de_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_fr_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_fr_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_de_ModelingService_AllocationInputFunctions AS SELECT
  AllocationInputFunctions_0.ID,
  AllocationInputFunctions_0.function,
  AllocationInputFunctions_0.description,
  AllocationInputFunctions_0.type_code
FROM localized_de_AllocationInputFunctions AS AllocationInputFunctions_0;

CREATE VIEW localized_fr_ModelingService_AllocationInputFunctions AS SELECT
  AllocationInputFunctions_0.ID,
  AllocationInputFunctions_0.function,
  AllocationInputFunctions_0.description,
  AllocationInputFunctions_0.type_code
FROM localized_fr_AllocationInputFunctions AS AllocationInputFunctions_0;
