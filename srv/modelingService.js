const cds = require("@sap/cds");
const activationService = require("./activationService");
module.exports = function () {
  this.on("activate", async (req) => {
    await activationService.activate(req);
  });
  // this.before("NEW", "*", async (req) => {
  //   if (cds) {
  //     if (req.target.elements.environment_ID) req.data.environment_ID = "1";
  //     if (req.target.elements.function_ID) req.data.function_ID = "4";
  //     if (req.target.elements.sequence) req.data.sequence = 10;
  //   }
  // });
  // this.before("READ", "*", async (req) => {
  //   if (req.target.elements.environment_ID) {
  //     const cql = cds.parse.expr(`1 = 1 AND (environment_ID = '1')`);
  //     if (req.query.SELECT.where) {
  //       req.query.SELECT.where.push(cql.xpr[3]);
  //       req.query.SELECT.where.push(cql.xpr[4]);
  //     } else {
  //       req.query.SELECT.where = [cql.xpr[4]];
  //     }
  //     console.log(req.query.SELECT.where);
  //   }
  // });
  this.after("READ", "Functions", (each) => {
    switch (each.type_code) {
      case "AL":
        each.semanticObject = "Allocation";
        each.url = `#Allocations-manage&/Allocations(ID=689c7441-310e-4f46-8514-5cdee31cb6ee,IsActiveEntity=true)`;
        break;
      case "MT":
        each.url = `#Modeltable-manage&/ModelTables(ID='3',IsActiveEntity=true)`;
        break;
      case "CU":
        each.url = `#Calculationunits-manage&/CalculationUnits(ID='1',IsActiveEntity=true)`;
        break;

      default:
        break;
    }
  });
};
