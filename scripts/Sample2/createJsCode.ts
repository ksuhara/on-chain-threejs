import { createJsCode } from '../lib/createJsCode';

async function main() {
  createJsCode('./html/Sample2.html', './output');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
