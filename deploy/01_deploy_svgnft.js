const fs = require('fs');
const {networkConfig} = require('../helper-hardhat-config');

module.exports = async({
    getNamedAccounts,
    getChainId,
    deployments
}) => {
    const {deploy, log} = deployments;
    const {deployer} = await getNamedAccounts();
    const chainId = await getChainId();

    log("Starting NFT deployment");
    const SVGNFT = await deploy("SVGNFT", {
        from: deployer,
        log: true
    })
    log(`NFT contract deployed at ${SVGNFT.address}`);
    let filepath = "./img/image1.svg";
    let svg = fs.readFileSync(filepath, {encoding: 'utf-8'});
    let svgNFTContract = await ethers.getContractFactory("SVGNFT");
    let accounts = await hre.ethers.getSigners();
    let signer = accounts[0];

    let svgNFT = new ethers.Contract(SVGNFT.address, svgNFTContract.interface, signer);
    const netwrokName = networkConfig[chainId]['name'];
    log(`verify with: \n npx hardhat verify --network ${netwrokName} ${svgNFT.address}`);

    let tokenId = await svgNFT.tokenId();
    let tx = await svgNFT.create(svg);
    let receipt = await tx.wait(1);
    log('NFT created!!');
    log(`You can view the tokenURI here: ${await svgNFT.tokenURI(tokenId)}`);

}