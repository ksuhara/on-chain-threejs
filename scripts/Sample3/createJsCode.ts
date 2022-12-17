import { createJsCode } from '../lib/createJsCode';

async function main() {
  createJsCode('./html/Sample3.html', './output');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
