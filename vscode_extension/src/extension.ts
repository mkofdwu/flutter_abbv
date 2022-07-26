import * as vscode from 'vscode';
import { execFileSync } from 'node:child_process';

const widgetNames: string[] = [
  'container',
  'row',
  'column',
  'scroll',
  'icon',
  'scaffold',
  'center',
  'align',
  'expanded',
  'spacer',
  'pad',
];

function startsWithWidget(source: string): boolean {
  const result = /[a-zA-Z_][a-zA-Z0-9_]*/.exec(source);
  if (result !== null) {
    return widgetNames.includes(result[0]);
  }
  return false;
}

export function activate(context: vscode.ExtensionContext) {
  const provider = vscode.languages.registerCompletionItemProvider('dart', {
    provideCompletionItems(
      document: vscode.TextDocument,
      position: vscode.Position,
      token: vscode.CancellationToken,
      context: vscode.CompletionContext
    ) {
      // find the nearest '@' symbol (indicates the start of the abbreviation)
      let source: string = '';
      let abbvRange: vscode.Range | null = null;
      for (let lineNum = position.line; lineNum >= 0; lineNum--) {
        const index = document.lineAt(lineNum).text.indexOf('@');
        if (index !== -1) {
          abbvRange = new vscode.Range(new vscode.Position(lineNum, index), position);
          source = document.getText(abbvRange);
          break;
        }
      }
      if (source.length === 0) {
        return undefined;
      }
      if (source[1] !== "'" && !startsWithWidget(source.substring(1))) {
        return undefined;
      }

      try {
        const data = execFileSync(`flutter_abbv.exe`, [source.substring(1)], { cwd: __dirname });
        const completion = new vscode.CompletionItem({
          label: data.toString(),
          description: 'Flutter Abbreviation',
        });
        // is there a better way to do this?
        completion.range = abbvRange!;
        completion.filterText = source;
        return [completion];
      } catch (err) {
        return undefined;
      }
    },
  });

  context.subscriptions.push(provider);
}

export function deactivate() {}
