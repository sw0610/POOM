var PoomContract = artifacts.reqire("PoomContract.sol");
module.exports = function (deployer){
    deployer.deploy(PoomContract);
}