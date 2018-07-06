const Token = artifacts.require('./SkeletalToken.sol');
const ControlCentre = artifacts.require('./ControlCentre.sol');
const DataCentre = artifacts.require('./token/DataCentre.sol');
const assertJump = require('./helpers/assertJump');

contract('UIP2.2', (accounts) => {
  let token;
  let dataCentre;
  let controlCentre;

  beforeEach(async () => {
    token = await Token.new();
    dataCentre = await DataCentre.new();
    controlCentre = await ControlCentre.new(token.address, dataCentre.address);
    await token.transferOwnership(controlCentre.address);
    await dataCentre.transferOwnership(controlCentre.address);
    await controlCentre.unpause();
    await controlCentre.mint(accounts[5], 100);
  });

  it('should allow upgrading control centre using UIP2.2', async () => {

      const TOKENHOLDER_1 = accounts[5];
      const BENEFICIARY = accounts[0];
      const tokensAmount = 100;

      await token.transfer(BENEFICIARY, tokensAmount, {from: TOKENHOLDER_1});
      const tokenBalanceTransfered = await token.balanceOf.call(BENEFICIARY);

      // Begin upgrade
      await controlCentre.pause();
      const newControlCentre = await ControlCentre.new(token.address, dataCentre.address);
      await controlCentre.kill(newControlCentre.address);
      await newControlCentre.unpause();

      // check balances and functions after upgrade
      const tokenBalanceTransfered1 = await token.balanceOf.call(BENEFICIARY);
      assert.equal(tokensAmount, tokenBalanceTransfered1.toNumber(), 'tokens not transferred');
      await token.transfer(TOKENHOLDER_1, tokensAmount, {from: BENEFICIARY});
      const tokenBalanceTransfered2 = await token.balanceOf.call(TOKENHOLDER_1);
      assert.equal(tokensAmount, tokenBalanceTransfered2.toNumber(), 'tokens not transferred');
    });

    it('should not allow killing control centre when not paused', async () => {

      try {
        await controlCentre.kill(accounts[0]);
        assert.fail('should have failed before');
      } catch (error) {
        assertJump(error)
      }
    });

})