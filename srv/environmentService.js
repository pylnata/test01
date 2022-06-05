const cds = require("@sap/cds");
const textbundle = require("@sap/textbundle");

module.exports = function () {
  this.after("READ", "Environments", (req) => {
    enrichEnvironments(req);
  });
  this.before(["PATCH", "SAVE"], "Environments", (req) => {
    const textBundle = new textbundle.TextBundle("i18n/environmentService", req.user.locale);
    checkParentId(req.data, textBundle, req);
  });
};

function enrichEnvironments(data) {
  if (data.type?.code === "NODE") {
    data.url = `#Environments-manage?parent_ID=${data.ID}`;
    data.icon = "sap-icon://folder-blank";
    data.gotoSubfolders = "Child Entries";
    data.version_hidden = true;
    data.gotoFunctions = false;
  } else {
    data.url = `#Functions-manage?environment_ID=${data.ID}`;
    data.icon = "sap-icon://tree";
    data.version_hidden = false;
    data.gotoFunctions = true;
  }
}

function checkParentId(data, textBundle, req) {
  if (data.ID === data.parent_ID) {
    const LOG = cds.log("PAPM");
    const text = textBundle.getText("ENVID_OWN_PARENT");
    LOG.error(text);
    req.error(500, text, "parent_ID", [data.ID, data.parent_ID]);
    // throw new Error("Some error happened", "parent_ID", [data.ID, data.parent_ID]);
    // req.reject(418, error, [data.ID, data.parent_ID], "parent_ID");
    // throw new Error("Some error happened", { cause: error });
  }
}
