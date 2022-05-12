const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {
  this.on("updateEnvironments", async (req) => {
    // Activate Button in Functions Fiori Elements UI is clicked
    await UPDATE.entity("Environments")
      .data(req.data)
      .where({ environment: req.data.environment, version: req.data.version });
    return req.data;
  });
});
