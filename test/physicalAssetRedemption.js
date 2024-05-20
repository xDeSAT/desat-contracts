const { ethers } = require("hardhat");
const { utils } = require("ethers");
const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

const name = "DeSAT Savea Wine";
const symbol = "DSW";
const zeroAddress = "0x0000000000000000000000000000000000000000";
const exampleToken1 = {
    tokenIssuer: "DESAT NETWORK",
    assetHolder: "STASIS UK ASSET HOLDING ONE LTD",
    storedLocation: "SALISBURY UK",
    terms: "HTTTPS://DESAT.NETWORK/ASSET/1/TERMS",
    jurisdiction: "UNITED KINGDOM",
    declaredValue: {
        currency: "GBP",
        value: 100,
    },
};

describe("Example Implementation Contract", function () {
    async function deployTokenFixture() {
        // Get the ContractFactory and Signers here.
        const Token = await ethers.getContractFactory("ExampleImplementation");
        const [owner, addr1, addr2] = await ethers.getSigners();

        const tokenContract = await Token.deploy(name, symbol);
        await tokenContract.deployed();

        return { tokenContract, owner, addr1, addr2 };
    }

    describe("deployment", function () {
        it("should set the right name", async () => {
            const { tokenContract } = await loadFixture(deployTokenFixture);
            expect(await tokenContract.name()).to.equal(name);
        });

        it("should set the right symbol", async () => {
            const { tokenContract } = await loadFixture(deployTokenFixture);
            expect(await tokenContract.symbol()).to.equal(symbol);
        });
    });

    describe("initialize properties", function () {
        let tokenContract, owner, addr1, addr2;
        let result;

        beforeEach(async function () {
            ({ tokenContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture));

            // Test properties initialization by minting a new token
            const tx = await tokenContract.mintToken(addr1.address, { ...exampleToken1 });

            result = await tx.wait();
        });

        // properties are needed for minting
        it("should set properties", async () => {
            // check individual properties in event
            const event = result.events[0];

            expect(event.event).to.equal("PropertiesSet");
            expect(event.args.tokenId).to.equal(1);
            expect(event.args.properties.tokenIssuer).to.equal(exampleToken1.tokenIssuer);
            expect(event.args.properties.assetHolder).to.equal(exampleToken1.assetHolder);
            expect(event.args.properties.storedLocation).to.equal(exampleToken1.storedLocation);
            expect(event.args.properties.terms).to.equal(exampleToken1.terms);
            expect(event.args.properties.jurisdiction).to.equal(exampleToken1.jurisdiction);
            expect(event.args.properties.declaredValue.currency).to.equal(exampleToken1.declaredValue.currency);
            expect(event.args.properties.declaredValue.value).to.equal(exampleToken1.declaredValue.value);
        });

        it("should store properties", async () => {
            // getter function for properties
            const result = await tokenContract.getProperties(1);

            expect(result.tokenIssuer).to.equal(exampleToken1.tokenIssuer);
            expect(result.assetHolder).to.equal(exampleToken1.assetHolder);
            expect(result.storedLocation).to.equal(exampleToken1.storedLocation);
            expect(result.terms).to.equal(exampleToken1.terms);
            expect(result.jurisdiction).to.equal(exampleToken1.jurisdiction);
            expect(result.declaredValue.currency).to.equal(exampleToken1.declaredValue.currency);
            expect(result.declaredValue.value).to.equal(exampleToken1.declaredValue.value);
        });
    });

    describe("minting", function () {
        let tokenContract, owner, addr1, addr2;
        let result;

        beforeEach(async function () {
            ({ tokenContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture));
        });

        // properties are needed for minting
        it("should mint new token", async () => {
            const tx = await tokenContract.mintToken(addr1.address, { ...exampleToken1 });

            const mintResult = await tx.wait();
            const mintEvent = mintResult.events[1];

            expect(mintResult.events[0].event).to.equal("PropertiesSet");
            expect(mintResult.events[1].event).to.equal("Transfer");
            expect(mintEvent.args.tokenId).to.equal(1); // tokenId should be 1
            expect(mintEvent.args.from).to.equal(zeroAddress); // mints from zero address
            expect(mintEvent.args.to).to.equal(addr1.address); // mints to addr1
        });
    });

    describe("burning", function () {
        let tokenContract, owner, addr1, addr2;

        beforeEach(async function () {
            ({ tokenContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture));

            await tokenContract.mintToken(addr1.address, { ...exampleToken1 });
        });

        // properties are needed for minting
        it("should burn existing token", async () => {
            const tx = await tokenContract.burnToken(1);
            const burnResult = await tx.wait();

            // burning first  emits PropertiesRemoved event
            const event0 = burnResult.events[0];
            expect(event0.event).to.equal("PropertiesRemoved");
            expect(event0.args.tokenId).to.equal(1);

            // burning then emits Transfer event
            const event1 = burnResult.events[1];
            expect(event1.event).to.equal("Transfer");
            expect(event1.args.tokenId).to.equal(1); // tokenId should be 1
            expect(event1.args.from).to.equal(addr1.address); // from addr1
            expect(event1.args.to).to.equal(zeroAddress); // to zero address

            // properties should be cleared
            const result = await tokenContract.getProperties(1);
            expect(result.tokenIssuer).to.equal("");
            expect(result.assetHolder).to.equal("");
            expect(result.storedLocation).to.equal("");
            expect(result.terms).to.equal("");
            expect(result.jurisdiction).to.equal("");
            expect(result.declaredValue.currency).to.equal("");
            expect(result.declaredValue.value).to.equal(0);
        });

        it("should fail without to burn non existing token", async () => {
            await expect(tokenContract.burnToken(2)).to.be.revertedWith(`ERC721NonexistentToken`, 2); // tokenId 2 doesn't exist
        });
    });
});
