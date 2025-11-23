const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const configPath =path.join(__dirname, "../deploy.json");
  let config ={};

  if (fs.existsSync(configPath)) {
    config = JSON.parse(fs.readFileSync(configPath,"utf8"));
    }

  console.log("=====================================");
  console.log(`🚀 Deploying Project: DappFusion`);
  console.log(`🌐 Network: ${hre.network.name}`);
  console.log("=====================================\n");

  await hre.run("compile");

  const ContractFactory = await hre.ethers.getContractFactory("DappFusion");
  const contract = await ContractFactory.deploy();

  await contract.waitForDeployment();
  const address = await contract.getAddress();

  console.log(`✅ DappFusion deployed successfully!`);
  console.log(`📍 Contract Address: ${address}`);

  // Save deployment details
  config.projectName = "DappFusion";
  config.network = hre.network.name;
  config.contractAddress = address;
  config.deploymentDate = new Date().toISOString();

  fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
  console.log("\n📝 Deployment details saved to deploy.json \n");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
