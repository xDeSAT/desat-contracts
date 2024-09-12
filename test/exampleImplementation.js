const { ethers } = require("hardhat");
const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

const name = "DESAT Savea Wine";
const symbol = "DSW";
const mockProperties = {
    tokenIssuer: "DESAT NETWORK",
    assetHolder: "STASIS UK ASSET HOLDING ONE LTD",
    storageLocation: "SALISBURY UK",
    terms: "HTTPS://DESAT.NETWORK/ASSET/1/TERMS",
    jurisdiction: "UNITED KINGDOM",
    declaredValue: {
        currency: "GBP",
        value: 100,
    },
};

describe("Example Implementation Contract", function () {
    let addr1;

    async function deployImplFixture() {
        // Get the ContractFactory and Signers here.
        const factory = await ethers.getContractFactory("ExampleImplementation");

        const impl = await factory.deploy(name, symbol);
        await impl.deployed();

        return { impl };
    }

    before(async function () {
        const signers = await ethers.getSigners();
        addr1 = signers[1];
    });

    describe("Deployment", function () {
        it("should set the right name", async () => {
            const { impl } = await loadFixture(deployImplFixture);
            expect(await impl.name()).to.equal(name);
        });

        it("should set the right symbol", async () => {
            const { impl } = await loadFixture(deployImplFixture);
            expect(await impl.symbol()).to.equal(symbol);
        });
    });

    describe("Initialize properties", function () {
        let impl, result;

        beforeEach(async function () {
            ({ impl } = await loadFixture(deployImplFixture));

            // Mint a new ERC7578 token
            const tx = await impl.mint(addr1.address, [...Object.values(mockProperties)]);
            result = await tx.wait();
        });

        it("should set properties", async () => {
            const { event, args } = result.events[0];
            const { tokenId, properties } = args;

            expect(event).to.equal("PropertiesSet");
            expect(tokenId).to.equal(1);
            expect(properties.tokenIssuer).to.equal(mockProperties.tokenIssuer);
            expect(properties.assetHolder).to.equal(mockProperties.assetHolder);
            expect(properties.storageLocation).to.equal(mockProperties.storageLocation);
            expect(properties.terms).to.equal(mockProperties.terms);
            expect(properties.jurisdiction).to.equal(mockProperties.jurisdiction);
            expect(properties.declaredValue.currency).to.equal(mockProperties.declaredValue.currency);
            expect(properties.declaredValue.value).to.equal(mockProperties.declaredValue.value);
        });

        it("should store properties", async () => {
            // getter function for properties
            const result = await impl.getProperties(1);

            expect(result.tokenIssuer).to.equal(mockProperties.tokenIssuer);
            expect(result.assetHolder).to.equal(mockProperties.assetHolder);
            expect(result.storageLocation).to.equal(mockProperties.storageLocation);
            expect(result.terms).to.equal(mockProperties.terms);
            expect(result.jurisdiction).to.equal(mockProperties.jurisdiction);
            expect(result.declaredValue.currency).to.equal(mockProperties.declaredValue.currency);
            expect(result.declaredValue.value).to.equal(mockProperties.declaredValue.value);
        });
    });

    describe("Mint", function () {
        let impl;

        beforeEach(async function () {
            ({ impl } = await loadFixture(deployImplFixture));
        });

        it("should mint a new token", async () => {
            const tx = await impl.mint(addr1.address, [...Object.values(mockProperties)]);

            const mintResult = await tx.wait();
            const mintEvent = mintResult.events[1];

            expect(mintResult.events[0].event).to.equal("PropertiesSet");
            expect(mintResult.events[1].event).to.equal("Transfer");
            expect(mintEvent.args.tokenId).to.equal(1); // tokenId should be 1
            expect(mintEvent.args.from).to.equal(ethers.constants.AddressZero); // mints from zero address
            expect(mintEvent.args.to).to.equal(addr1.address); // mints to addr1
        });
    });

    describe("Burn", function () {
        let impl;

        beforeEach(async function () {
            ({ impl } = await loadFixture(deployImplFixture));

            await impl.mint(addr1.address, [...Object.values(mockProperties)]);
        });

        // properties are needed for minting
        it("should burn existing token", async () => {
            const tx = await impl.burn(1);
            const burnResult = await tx.wait();

            // burning first  emits PropertiesRemoved event
            const event0 = burnResult.events[0];
            expect(event0.event).to.equal("PropertiesRemoved");
            expect(event0.args.tokenId).to.equal(1);

            // burning then emits Transfer event
            const event1 = burnResult.events[1];
            expect(event1.event).to.equal("Transfer");
            expect(event1.args.tokenId).to.equal(1);
            expect(event1.args.from).to.equal(addr1.address);
            expect(event1.args.to).to.equal(ethers.constants.AddressZero);

            // properties should be cleared
            const result = await impl.getProperties(1);
            expect(result.tokenIssuer).to.equal("");
            expect(result.assetHolder).to.equal("");
            expect(result.storageLocation).to.equal("");
            expect(result.terms).to.equal("");
            expect(result.jurisdiction).to.equal("");
            expect(result.declaredValue.currency).to.equal("");
            expect(result.declaredValue.value).to.equal(0);
        });

        it("should fail when burning a non-existing token", async () => {
            await expect(impl.burn(2)).to.be.revertedWith(`ERC721NonexistentToken`, 2); // tokenId 2 doesn't exist
        });
    });
});
