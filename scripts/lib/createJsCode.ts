import { readFileSync, writeFileSync } from 'fs';
import { between } from '../lib/string';
import UglifyJS from 'uglify-js';
import { join, parse } from 'path';

export function createJsCode(htmlPath: string, outputDir: string): void {
  const fileContent = readFileSync(htmlPath, 'utf-8'); // HTMLファイルを読み込む
  const rawJsCode = between(fileContent, '// --- start ---', '// --- end ---'); // JavaScriptコードを切り出す
  const minifiedJsCode = UglifyJS.minify(rawJsCode).code; // Minify
  const jsCode = encodeURIComponent(encodeURIComponent(minifiedJsCode)); // URLエンコードを2回
  console.log('jsCode.length', rawJsCode.length, minifiedJsCode.length, jsCode.length);
  const { name } = parse(htmlPath);
  writeFileSync(join(outputDir, name + '.jscode'), jsCode);
  const solidityCode = `string private constant JS_CODE = "${jsCode}";`;
  writeFileSync(join(outputDir, name + '.solcode'), solidityCode);
}
