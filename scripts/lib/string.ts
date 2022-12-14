export function between(s: string, startToken: string, endToken: string): string {
  let startIndex = s.indexOf(startToken);
  if (startIndex === -1) throw Error('startToken not found: ' + startToken);
  startIndex += startToken.length;
  const endIndex = s.indexOf(endToken, startIndex);
  if (endIndex === -1) throw Error('endToken not found: ' + endToken);
  return s.substring(startIndex, endIndex);
}

export function escapeJsonValue(s: string): string {
  return JSON.stringify({ s }).slice(6, -2); // '{"s":"'〜'"}'
}
