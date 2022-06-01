const cds = require("@sap/cds");

module.exports = function () {
  this.after("READ", "Environments", (each) => {
    if (each.type?.code === "NODE") {
      each.semanticaction = "manage";
      each.target = "parent_ID";
      each.url = `#Environments-manage?ID=${each.ID}`;
      each.icon = "sap-icon://folder-blank";
      each.version_fc = 1;
      each.version_hidden = true;
    } else {
      each.semanticaction = "manage";
      each.target = "ID";
      // Empty url does still render the text as a link
      // each.url = "";
      // Link to detail page
      each.url = `#Environments-manage?/Environments(ID='${each.ID}',IsActiveEntity=true)`;
      each.icon = "sap-icon://tree";
      // each.version_fc = 7; // Mandatory
      each.version_fc = 3; // Optional
      each.version_hidden = false;
      each.functionLinkDescription = "goto Functions";
    }
  });
};
