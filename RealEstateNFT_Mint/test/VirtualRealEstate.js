const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("VirtualRealEstate", function () {
  let owner;
  let user;
  let virtualRealEstate;

  beforeEach(async function () {
    [owner, user] = await ethers.getSigners();

    const VirtualRealEstate = await ethers.getContractFactory("VirtualRealEstate");
    virtualRealEstate = await VirtualRealEstate.deploy();
    // await virtualRealEstate.deployed();
  });

  it("should mint a token with URI", async function () {
    const tokenURI = "https://example.com/token/1";
    await virtualRealEstate.connect(owner).mintWithURI(user.address, tokenURI);

    const tokenId = 1 // Retrieve the actual tokenId
    const retrievedURI = await virtualRealEstate.getTokenURI(tokenId);

    expect(retrievedURI).to.equal(tokenURI);
  });

  it("should mint a token with event", async function () {
    const tokenURI = "https://example.com/token/2";
    const tx = await virtualRealEstate.connect(owner).mintWithURI(user.address, tokenURI);
    await tx.wait();
    // const txReceipt = await tx.wait();

    // const mintedEvent = txReceipt.events && txReceipt.events.find((event) => event.event === 'minted');
    // expect(mintedEvent).to.exist;

    const filter = virtualRealEstate.filters.minted();
    const events = await virtualRealEstate.queryFilter(filter);

    // Check if the event is emitted
    expect(events.length).to.equal(1);

    // Check the event properties
    const mintedEvent = events[0];

    expect(mintedEvent.args.to).to.be.equal(user.address);
    expect(mintedEvent.args.TokenID).to.be.equal(1);

  })
});
