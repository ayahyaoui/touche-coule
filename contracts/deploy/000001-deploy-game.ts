import 'dotenv/config'
import { DeployFunction } from 'hardhat-deploy/types'

const deployer: DeployFunction = async hre => {
  if (hre.network.config.chainId !== 31337) return
  const { deployer } = await hre.getNamedAccounts()
  console.log(`deployyyyyyyyyyy`);
  await hre.deployments.deploy('BasicShip', { from: deployer, log: true })
  const test = await hre.deployments.deploy('Main', { from: deployer, log: true })
  console.log(`deployed main at ${test.address}`)
  //await hre.deployments.deploy('ShipFactory', { from: deployer, log: true })

}

export default deployer
