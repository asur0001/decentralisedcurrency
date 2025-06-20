const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying DecentralizedTimeCapsule contract to Core Blockchain...");

  // Get the contract factory
  const DecentralizedTimeCapsule = await ethers.getContractFactory("DecentralizedTimeCapsule");

  // Deploy the contract
  const timeCapsule = await DecentralizedTimeCapsule.deploy();

  // Wait for deployment to complete
  await timeCapsule.deployed();

  console.log("DecentralizedTimeCapsule deployed to:", timeCapsule.address);
  console.log("Transaction hash:", timeCapsule.deployTransaction.hash);
  
  // Verify deployment
  console.log("Verifying deployment...");
  const capsuleCounter = await timeCapsule.capsuleCounter();
  console.log("Initial capsule counter:", capsuleCounter.toString());
  
  console.log("Deployment completed successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment failed:", error);
    process.exit(1);
  });
