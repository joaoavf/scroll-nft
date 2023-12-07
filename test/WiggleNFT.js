const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("WiggleNFT Contract", function () {
    let WiggleNFT;
    let wiggleNFT;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        WiggleNFT = await ethers.getContractFactory("RandomBalls");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        wiggleNFT = await WiggleNFT.deploy();
    });

    describe("Minting", function () {
        it("Should mint a new token and assign it to owner", async function () {
            await wiggleNFT.mint(owner.address, 1);
            expect(await wiggleNFT.ownerOf(1)).to.equal(owner.address);
        });
    });

    describe("Token URI", function () {
        it("Should return a valid SVG URL for a given tokenId", async function () {
            await wiggleNFT.mint(owner.address, 1);
            const tokenURI = await wiggleNFT.tokenURI(1);
            expect(tokenURI).to.include("data:image/svg+xml;base64,");
        });
    });

    describe("Color Selection", function () {
        it("Should select a color based on tokenId", async function () {
            await wiggleNFT.mint(owner.address, 1);
            const tokenURI = await wiggleNFT.tokenURI(1);

            // Add logic to extract color from tokenURI and compare
        });
    });

    describe("Path Generation", function () {
        it("Should generate an SVG path for a given tokenId", async function () {
            await wiggleNFT.mint(owner.address, 1);
            const tokenURI = await wiggleNFT.tokenURI(1);

            // Add logic to extract path from tokenURI and perform some basic checks
        });
    });
});