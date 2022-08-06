import * as vscode from 'vscode';
import { execFileSync } from 'node:child_process';
import { existsSync } from 'fs';

export function activate(context: vscode.ExtensionContext) {
  if (vscode.workspace.workspaceFolders === undefined) {
    return;
  }

  const currentDir = vscode.workspace.workspaceFolders[0].uri.fsPath;
  const configFile = currentDir + '/flutter_abbv.yaml';

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

      try {
        const args = [source.substring(1)];
        if (existsSync(configFile)) {
          args.push(configFile);
        }
        const data = execFileSync(`flutter_abbv.exe`, args, { cwd: __dirname });
        if (data.slice(0, 7) === 'ERROR: ') {
          return undefined;
        }
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
