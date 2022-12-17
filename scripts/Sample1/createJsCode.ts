import { readFileSync, writeFileSync } from 'fs';
import { between } from '../lib/string';
import UglifyJS from 'uglify-js';
import path from 'path';

async function main() {
  const htmlPath = './html/Sample1.html';
  const outputDir = './output';

  const { name } = path.parse(htmlPath);
  const fileContent = readFileSync(htmlPath, 'utf-8');
  const rawJsCode = between(fileContent, '// --- start ---', '// --- end ---');
  const minifiedJsCode = UglifyJS.minify(rawJsCode).code;
  console.log({ minifiedJsCode });
  const finalJsCode = encodeURIComponent(encodeURIComponent(minifiedJsCode)); // 埋め込み用
  console.log('jsCode.length', rawJsCode.length, minifiedJsCode.length, finalJsCode.length);
  writeFileSync(path.join(outputDir, name + '.jscode'), finalJsCode);
  // string private constant JS_CODE = "TODO";

  console.log('done');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
