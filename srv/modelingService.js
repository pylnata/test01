// const cds = require("@sap/cds");
module.exports = function () {
  this.before("NEW", "Allocations", async (req) => {
    // const result = await cds.query("SELECT CURRENT_CONNECTION FROM DUMMY");
    // const result = await cds.update("ConnectionEnvironments",result.CURRENT_CONNECTION).with({environment: '1'});
    req.data.environment_ID = "1";
    req.data.function_ID = "4";
    // const query = SELECT.one("directory.Session").where({
    //   user: req.user.id,
    // });
    // const session = await cds.tx(req).run(query);
    // if (session === null || !session.directory || !session.version) {
    //   return req.error("mandatory session variable not set");
    // }
    // await cds.run(`SET 'ENVIRONMENT' = '1'`);
  });
};
