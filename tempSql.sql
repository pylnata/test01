
CREATE TABLE Environments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  description NVARCHAR(5000),
  PRIMARY KEY(ID)
);

CREATE TABLE Fields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000),
  type NVARCHAR(5000),
  description NVARCHAR(5000),
  Environment_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Fields_Environment
  FOREIGN KEY(Environment_ID)
  REFERENCES Environments(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Checks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000),
  type NVARCHAR(5000),
  description NVARCHAR(5000),
  Environment_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Checks_Environment
  FOREIGN KEY(Environment_ID)
  REFERENCES Environments(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Functions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000),
  description NVARCHAR(5000),
  type NVARCHAR(5000),
  Environment_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Functions_Environment
  FOREIGN KEY(Environment_ID)
  REFERENCES Environments(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FunctionChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  Function_ID NVARCHAR(36),
  Field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__FunctionChecks_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FunctionChecks_Field
  FOREIGN KEY(Field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FunctionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  formula NVARCHAR(5000),
  group_ NVARCHAR(5000),
  aggregation NVARCHAR(5000),
  Function_ID NVARCHAR(36),
  Field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__FunctionFields_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FunctionFields_Field
  FOREIGN KEY(Field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FunctionFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  sign NVARCHAR(5000),
  opt NVARCHAR(5000),
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  FunctionField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__FunctionFieldSelections_FunctionField
  FOREIGN KEY(FunctionField_ID)
  REFERENCES FunctionFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTables (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  type NVARCHAR(5000),
  Environment_ID NVARCHAR(36),
  Function_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTables_Environment
  FOREIGN KEY(Environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTableFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  ModelTable_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTableFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTableFields_ModelTable
  FOREIGN KEY(ModelTable_ID)
  REFERENCES ModelTables(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Allocations (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  type NVARCHAR(5000),
  Function_ID NVARCHAR(36),
  SenderFunction_ID NVARCHAR(36),
  ReceiverFunction_ID NVARCHAR(36),
  DriverField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Allocations_Function
  FOREIGN KEY(Function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_DriverField
  FOREIGN KEY(DriverField_ID)
  REFERENCES Fields(ID)
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
  description NVARCHAR(5000) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000) NULL,
  type NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  Environment_ID NVARCHAR(36) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000) NULL,
  type NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  Environment_ID NVARCHAR(36) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  type NVARCHAR(5000) NULL,
  Environment_ID NVARCHAR(36) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  type NVARCHAR(5000) NULL,
  Environment_ID NVARCHAR(36) NULL,
  Function_ID NVARCHAR(36) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  ModelTable_ID NVARCHAR(36) NULL,
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
  ID NVARCHAR(36) NOT NULL,
  type NVARCHAR(5000) NULL,
  Function_ID NVARCHAR(36) NULL,
  SenderFunction_ID NVARCHAR(36) NULL,
  ReceiverFunction_ID NVARCHAR(36) NULL,
  DriverField_ID NVARCHAR(36) NULL,
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
  environments_0.description
FROM Environments AS environments_0;

CREATE VIEW ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.ID,
  fields_0.field,
  fields_0.type,
  fields_0.description,
  fields_0.Environment_ID
FROM Fields AS fields_0;

CREATE VIEW ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.ID,
  functions_0.function,
  functions_0.description,
  functions_0.type,
  functions_0.Environment_ID
FROM Functions AS functions_0;

CREATE VIEW ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.ID,
  modelTables_0.type,
  modelTables_0.Environment_ID,
  modelTables_0.Function_ID
FROM ModelTables AS modelTables_0;

CREATE VIEW ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.ID,
  allocations_0.type,
  allocations_0.Function_ID,
  allocations_0.SenderFunction_ID,
  allocations_0.ReceiverFunction_ID,
  allocations_0.DriverField_ID
FROM Allocations AS allocations_0;

CREATE VIEW InputFunctions AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.description,
  Functions_0.type,
  Functions_0.Environment_ID
FROM Functions AS Functions_0
WHERE Functions_0.type = 'MT';

CREATE VIEW ModelingService_Checks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.type,
  Checks_0.description,
  Checks_0.Environment_ID
FROM Checks AS Checks_0;

CREATE VIEW ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ModelTable_ID
FROM ModelTableFields AS ModelTableFields_0;

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

CREATE VIEW ModelingService_InputFunctions AS SELECT
  InputFunctions_0.createdAt,
  InputFunctions_0.createdBy,
  InputFunctions_0.modifiedAt,
  InputFunctions_0.modifiedBy,
  InputFunctions_0.ID,
  InputFunctions_0.function,
  InputFunctions_0.description,
  InputFunctions_0.type,
  InputFunctions_0.Environment_ID
FROM InputFunctions AS InputFunctions_0;
