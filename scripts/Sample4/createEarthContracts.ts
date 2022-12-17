import { existsSync, mkdirSync, readFileSync } from 'fs';
import { createDataChunkContracts } from '../lib/createDataChunkContracts';

async function main() {
  const name = 'EarthDataChunk';
  const imagePath = './html/images/earth.png';
  const mimeType = 'image/png';
  const outputDir = './output/earth_png';

  const image = readFileSync(imagePath);
  const dataUrl = `data:${mimeType};base64,` + image.toString('base64');

  if (!existsSync(outputDir)) mkdirSync(outputDir);
  createDataChunkContracts(name, dataUrl, outputDir);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
