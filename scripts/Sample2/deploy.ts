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
  const contract = await ethers.getContractFactory('Sample2').then((factory) => factory.deploy());
  await waitDeployed('Sample2', contract);

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

  // mint 5x
  for (let i = 0; i < 5; i++) {
    await waitTx('mint', await contract.mint());
  }

  console.log('done');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
