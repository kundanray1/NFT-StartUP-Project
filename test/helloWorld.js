const { contracts_build_directory } = require("../truffle-config");

const HelloWorld = artifacts.require("HelloWorld");
contract("HelloWorld", () => {
  it("testing", async () => {
    const instance = await HelloWorld.deployed();
    await instance.setMessage("Hello Test");
    const message = await instance.greetings();
    assert(message === "Hello Test");
  });
});
