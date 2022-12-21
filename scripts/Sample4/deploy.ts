import { ethers } from 'hardhat';
import { waitDeployed, waitTx } from '../lib/common';
import {
  COMPILER_V2_ADDRESS,
  THREE1_ADDRESS,
  THREE2_ADDRESS,
  THREE3_ADDRESS,
  THREE4_ADDRESS,
  THREE5_ADDRESS,
  THREE6_ADDRESS,
  THREE7_ADDRESS,
  THREE8_ADDRESS,
  THREE9_ADDRESS,
} from '../lib/constants';

async function main() {
  // signer
  const [signer] = await ethers.getSigners();
  console.log('signer:', signer.address);

  // deploy
  const earth1 = await ethers.getContractFactory('EarthDataChunk1').then((factory) => factory.deploy());
  await waitDeployed('Earth1', earth1);
  const earth2 = await ethers.getContractFactory('EarthDataChunk2').then((factory) => factory.deploy());
  await waitDeployed('Earth2', earth2);
  const contract = await ethers.getContractFactory('Sample4').then((factory) => factory.deploy());
  await waitDeployed('Sample4', contract);

  // setAddress
  await waitTx('setCompilerAddress', await contract.setCompilerAddress(COMPILER_V2_ADDRESS));
  await waitTx(
    'setThreeAddress',
    await contract.setThreeAddress(
      THREE1_ADDRESS,
      THREE2_ADDRESS,
      THREE3_ADDRESS,
      THREE4_ADDRESS,
      THREE5_ADDRESS,
      THREE6_ADDRESS,
      THREE7_ADDRESS,
      THREE8_ADDRESS,
      THREE9_ADDRESS
    )
  );
  await waitTx('setImageAddress', await contract.setImageAddress(earth1.address, earth2.address));

  // mint
  const tokenId = 1;
  await waitTx('mint', await contract.mint(tokenId));

  console.log('done');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
