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
};
