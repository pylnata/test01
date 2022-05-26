const cds = require("@sap/cds");

async function activate(req) {
  const LOG = cds.log("PAPM");
  try {
    const sql = `SELECT * FROM ENVIRONMENTS WHERE type_code = 'X'`;
    const cqn = cds.parse.cql(sql);
    const result = await cds.run(sql);
    // const result = await cds.run(testSql);
    console.log(result, cqn, req);
    LOG.info("All good!");
    return true;
  } catch (error) {
    LOG.info(error);
    console.error(error);
    throw new Error("Some error happened", { cause: error });
  }
}
module.exports = { activate };
