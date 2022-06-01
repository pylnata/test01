const cds = require("@sap/cds");

module.exports = function () {
  this.after("READ", "Environments", (each) => {
    console.log("after READ Environments");
    if (each.type.code === "NODE") {
      each.semanticaction = "manage";
      each.target = "parent_ID";
      each.url = `#Environments-manage?ID=${each.ID}`;
      each.icon = "sap-icon://folder-blank";
    } else {
      each.semanticaction = "manage";
      each.target = "ID";
      // Empty url does still render the text as a link
      // each.url = "";
      // Link to detail page
      each.url = `#Environments-manage?/Environments(ID='${each.ID}',IsActiveEntity=true)`;
      each.icon = "sap-icon://tree";
    }
  });
};
