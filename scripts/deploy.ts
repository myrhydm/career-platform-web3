import { ethers } from "hardhat";

async function main() {
  console.log("Deploying Career Platform contracts...");

  // Deploy CareerToken
  const CareerToken = await ethers.getContractFactory("CareerToken");
  const careerToken = await CareerToken.deploy();
  await careerToken.waitForDeployment();
  
  console.log("CareerToken deployed to:", await careerToken.getAddress());

  // Deploy CareerAchievements
  const CareerAchievements = await ethers.getContractFactory("CareerAchievements");
  const careerAchievements = await CareerAchievements.deploy();
  await careerAchievements.waitForDeployment();
  
  console.log("CareerAchievements deployed to:", await careerAchievements.getAddress());

  // Save deployment info
  const deploymentInfo = {
    network: "localhost",
    careerToken: await careerToken.getAddress(),
    careerAchievements: await careerAchievements.getAddress(),
    timestamp: new Date().toISOString()
  };

  console.log("Deployment completed:", deploymentInfo);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
