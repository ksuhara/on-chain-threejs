import { readFileSync, writeFileSync } from 'fs';
import { between } from '../lib/string';
import UglifyJS from 'uglify-js';
import { join, parse } from 'path';

export function createJsCode(htmlPath: string, outputDir: string): void {
  const fileContent = readFileSync(htmlPath, 'utf-8');
  const rawJsCode = between(fileContent, '// --- start ---', '// --- end ---');
  const minifiedJsCode = UglifyJS.minify(rawJsCode).code;
  const jsCode = encodeURIComponent(encodeURIComponent(minifiedJsCode)); // 埋め込み用JsCode
  console.log('jsCode.length', rawJsCode.length, minifiedJsCode.length, jsCode.length);
  const { name } = parse(htmlPath);
  writeFileSync(join(outputDir, name + '.jscode'), jsCode);
  const solidityCode = `string private constant JS_CODE = "${jsCode}";`;
  writeFileSync(join(outputDir, name + '.solcode'), solidityCode);
}
