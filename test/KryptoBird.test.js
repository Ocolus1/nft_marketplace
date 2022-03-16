const { assert } = require('chai'); 

const KryptoBird = artifacts.require('./KryptoBird');

require("chai").use(require("chai-as-promised")).should()

contract("KryptoBird", (accounts) => {
    let contract
    before( async() => {
        
        contract = await KryptoBird.deployed();
    })


    describe("deployment", async() => {
        it("deploy successfully", async() => {
            const address = contract.address;
            assert.notEqual(address, "");
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        })

        it("Has a name", async() => {
            const name = await contract.name();
            assert.equal(name, "KryptoBird")
        })
        it("Has a symbol", async() => {
            const symbol = await contract.symbol();
            assert.equal(symbol, "KBIRDZ")
        })
    })

    describe("minting", async() => {
        it("creates new token", async() => {
            let result = await contract.mint("http...1")
            let totalSupply =  await contract.totalSupply();
            assert.equal(totalSupply, 1)
            let event = result.logs[0].args
            assert.equal(event._from, "0x0000000000000000000000000000000000000000", "from the contract")
            assert.equal(event._to, accounts[0], "to is the msg.sender")

            await contract.mint("http...1").should.be.rejected;
        })
    })

    describe('indexing', async() => { 
        it("lists kryptobirz", async() => {
            // minting threee new tokens 
            await contract.mint("http...2")
            await contract.mint("http...3")
            await contract.mint("http...4")
            let totalSupply =  await contract.totalSupply();

            let result = []
            let KryptoBird
            for(let i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptobirdz(i-1)
                result.push(KryptoBird)
            }

            let expected = ["http...1", "http...2", "http...3", "http...4"]
            assert.equal(result.join(','), expected.join(","))
        })
     })
})