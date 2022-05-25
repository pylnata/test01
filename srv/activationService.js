const cds = require("@sap/cds");

async function activate(req) {
  try {
    const sql = `SELECT * FROM ENVIRONMENTS WHERE type_cod = 'X'`;
    const cqn = cds.parse.cql(sql);
    const result = await cds.run(sql);
    // const result = await cds.run(testSql);
    console.log(result, cqn, req);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  }
}
module.exports = { activate };
