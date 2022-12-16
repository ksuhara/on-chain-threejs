import { writeFileSync } from 'fs';
import { join } from 'path';

function getContractCode(contractName: string, data: string): string {
  return `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract ${contractName} {
    string public constant data = "${data}";
}`;
}

export function createDataChunkContracts(name: string, data: string, outputDir: string) {
  const maxSize = 24256;
  const fileCount = Math.ceil(data.length / maxSize);
  for (let i = 0; i < fileCount; i++) {
    const start = i * maxSize;
    const dataChunk = data.slice(start, start + maxSize);
    const contractName = name + (i + 1);
    const contractCode = getContractCode(contractName, dataChunk);
    writeFileSync(join(outputDir, `${contractName}.sol`), contractCode);
  }
}
