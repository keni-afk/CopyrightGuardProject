const CopyrightGuard = artifacts.require("CopyrightGuard");

module.exports = function (deployer) {
    deployer.deploy(CopyrightGuard);
};
