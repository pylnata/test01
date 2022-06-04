const cds = require("@sap/cds");

async function onCreate(req) {
  const d = cds.model.definitions;
  const data = req.data;
  const details = {
    environment_ID: data.environment_ID,
    function_ID: data.ID,
    ID: data.ID,
  };
  switch (data.type_code) {
    case d.FunctionType.enum.Allocation.val:
      data.allocation_ID = data.ID;
      await INSERT.into(d.Allocations).entries([details]);
      break;
    case d.FunctionType.enum.CalculationUnit.val:
      data.calculationUnit_ID = data.ID;
      await INSERT.into(d.CalculationUnits).entries([details]);
      break;
    case d.FunctionType.enum.ModelTable.val:
      data.modelTable_ID = data.ID;
      await INSERT.into(d.ModelTables).entries([details]);
      break;
  }
}

module.exports = { onCreate };
