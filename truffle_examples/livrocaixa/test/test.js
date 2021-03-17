const testToken = artifacts.require("TestToken");

contract('TestToken', (accounts) => {
    it('should put 10000 testToken in the first account', async () => {
        
        const testTokenInstance = await testToken.deployed();
        const balance = await testTokenInstance.balanceOf.call(accounts[0]);
        
        assert.equal(balance.valueOf(), 10000, "0 wasn't in the first account");
    });

    it('Transfer testToken', async () => {
        
        const testTokenInstance = await testToken.deployed();
        // Account 0 transfer 500 tokens to account 1
        await testTokenInstance.transfer(accounts[1], 500, {from: accounts[0]});
        
        const ac_1_balance = await testTokenInstance.balanceOf(accounts[0]);
        
        assert.equal(ac_1_balance.valueOf(), 9500, 'Account 1 has no expected balance');
        
        const ac_2_balance = await testTokenInstance.balanceOf(accounts[1]);
        
        assert.equal(ac_2_balance.valueOf(), 500, 'Account 2 has no expected balance');
    });
});