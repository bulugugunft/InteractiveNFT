const InteractiveNFT = artifacts.require("InteractiveNFT");
// const {sha256, solidityPack, hexlify} = require("ethers/utils");
const truffleAssert = require('truffle-assertions');
const chai = require('chai');
const chaiAsPromised = require('chai-as-promised')
chai.use(chaiAsPromised);



contract('InteractiveNFT', ([alice, bob, carol, james])  => {
    beforeEach(async () => {
      this.instance = await  InteractiveNFT.deployed();
    });

    it("mint", async () => {
        await this.instance.mint()
        assert.equal(await this.instance.textMap(0), "good morning", "text is incorrect");
        assert.equal(await this.instance.colorMap(0), "black", "color is incorrect");
    });

    it("setScript", async () => {
        script = 'ZSI6ICJ0b2tlblVSSSIsIm91dHB1dHMiO'
        await this.instance.setScript(0, 10000, script)
        assert.equal(await this.instance.getScript(0), script, "script is incorrect");
    });


    it("setColor", async () => {
      await this.instance.mint()
      assert.equal(await this.instance.colorMap(0), "black", "color is incorrect");
      const txResult = await this.instance.setColor(0, "blue")
      truffleAssert.eventEmitted(txResult, 'SetColor', (ev) => {
        assert.equal(ev.user, alice, "error user");
        assert.equal(ev.tokenId, 0, "error hash");
        assert.equal(ev.color, "blue", "error amount");
        return true
      })
      assert.equal(await this.instance.colorMap(0), "blue", "color is incorrect");
      await chai.assert.isRejected(this.instance.setColor(0, "red", {from: bob}), 'only nft owner can change')

    });

    it("setText", async () => {
      await this.instance.mint()
      assert.equal(await this.instance.textMap(0), "good morning", "text is incorrect");
      const txResult = await this.instance.setText(0, "good night")
      truffleAssert.eventEmitted(txResult, 'SetText', (ev) => {
        assert.equal(ev.user, alice, "error user");
        assert.equal(ev.tokenId, 0, "error hash");
        assert.equal(ev.text, "good night", "error amount");
        return true
      })
      assert.equal(await this.instance.textMap(0), "good night", "text is incorrect");
      await chai.assert.isRejected(this.instance.setText(0, "ok", {from: bob}), 'only nft owner can change')

    });

})