const cds = require("@sap/cds");

module.exports = function () {
  this.after("READ", "Environments", (req) => {
    enrichEnvironments(req);
  });
  this.before(["PATCH", "SAVE"], "Environments", (req) => {
    checkParentId(req);
  });
};

function enrichEnvironments(req) {
  if (req.type?.code === "NODE") {
    req.url = `#Environments-manage?parent_ID=${req.ID}`;
    req.icon = "sap-icon://folder-blank";
    req.gotoSubfolders = "Child Entries";
    req.version_hidden = true;
    req.gotoFunctions = false;
  } else {
    req.url = `#Functions-manage?environment_ID=${req.ID}`;
    req.icon = "sap-icon://tree";
    req.version_hidden = false;
    req.gotoFunctions = true;
  }
}

function checkParentId(req) {
  const data = req.data;
  if (data.ID === data.parent_ID) {
    const LOG = cds.log("PAPM");
    const error = "Environment {0} cannot be its own parent {1}";
    LOG.error(error);
    req.error(500, error, "parent_ID", [data.ID, data.parent_ID]);
    // throw new Error("Some error happened", "parent_ID", [data.ID, data.parent_ID]);
    // req.error(418,error,"parent_ID",[data.ID, data.parent_ID] );
    // req.reject(418, error, [data.ID, data.parent_ID], "parent_ID");
    // throw new Error("Some error happened", { cause: error });
  }
}
