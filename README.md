# codesweep — Fast Duplicate Code Detector

**codesweep** is a fast, cross-platform command-line tool for finding duplicate
and structurally similar functions in TypeScript, JavaScript, Flutter/Dart,
Kotlin, and Swift projects.

Built with Rust and Tree-sitter, codesweep compares syntax structure instead of
plain text. Formatting, comments, and outer function names do not hide duplicated
logic.

> Created by **moJ KS** · [GitHub](https://github.com/mkasaii16)

## Why codesweep?

- Detect exact structural duplicate functions.
- Find near-duplicates with a configurable similarity threshold.
- Parse source code accurately with Tree-sitter grammars.
- Scan large projects using a small native CLI.
- Ignore generated code, dependencies, and custom directories.
- Run on macOS, Linux, and Windows without a language runtime.

## Supported languages

| Language | CLI value | File extensions |
| --- | --- | --- |
| TypeScript | `typescript` or `ts` | `.ts`, `.tsx` |
| JavaScript | `javascript` or `js` | `.js`, `.jsx`, `.mjs`, `.cjs` |
| Flutter / Dart | `flutter` or `dart` | `.dart` |
| Kotlin | `kotlin` or `kt` | `.kt`, `.kts` |
| Swift | `swift` | `.swift` |

## Download

Download the latest archive from the
[codesweep Releases page](https://github.com/mkasaii16/codesweep-releases/releases/latest).

| Operating system | CPU | Release asset |
| --- | --- | --- |
| macOS | Apple Silicon | `codesweep-vX.Y.Z-macos-arm64.tar.gz` |
| macOS | Intel | `codesweep-vX.Y.Z-macos-x64.tar.gz` |
| Linux | x86-64 | `codesweep-vX.Y.Z-linux-x64.tar.gz` |
| Windows | x86-64 | `codesweep-vX.Y.Z-windows-x64.zip` |

Each archive has a matching `.sha256` file for integrity verification.

## Install with Homebrew on macOS or Linux

```bash
brew tap mkasaii16/tap
brew trust --formula mkasaii16/tap/codesweep
brew install mkasaii16/tap/codesweep
```

Upgrade later with:

```bash
brew update
brew upgrade codesweep
```

Uninstall with:

```bash
brew uninstall codesweep
```

The Homebrew package supports Apple Silicon and Intel macOS, plus x86-64 Linux.

## Manual installation on macOS or Linux

Extract the archive, make the binary executable, and place it somewhere in your
`PATH`:

```bash
tar -xzf codesweep-vX.Y.Z-macos-arm64.tar.gz
chmod +x codesweep
sudo mv codesweep /usr/local/bin/codesweep
```

Verify the installation:

```bash
codesweep --version
codesweep --help
```

## Install on Windows

Download and inspect the installer, then run it in PowerShell:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/mkasaii16/codesweep-releases/master/install.ps1 -OutFile install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

The installer downloads the latest Windows archive, verifies its SHA-256
checksum, installs `codesweep.exe` under the current user's local application
directory, and adds that directory to the user `PATH`.

Open a new PowerShell window and verify the installation:

```powershell
codesweep.exe --version
codesweep.exe --help
```

`codesweep.exe` is the actual Windows executable. It is a command-line program,
so it can be run from either **Command Prompt (CMD)** or **PowerShell**.

Command Prompt example:

```bat
codesweep.exe C:\Projects\my-app -lg typescript -t 80
```

PowerShell example:

```powershell
codesweep.exe C:\Projects\my-app -lg typescript -t 80
```

## Quick start

TypeScript is selected by default:

```bash
codesweep ./my-project
```

Choose another language:

```bash
codesweep ./web-app --language javascript
codesweep ./flutter-app --language flutter
codesweep ./android-app --language kotlin
codesweep ./ios-app --language swift
```

Equivalent short language names:

```bash
codesweep ./typescript-app -lg ts
codesweep ./javascript-app -lg js
codesweep ./flutter-app -lg dart
codesweep ./android-app -lg kt
codesweep ./ios-app -lg swift
```

Find functions with at least 80% structural similarity:

```bash
codesweep ./src --threshold 80
```

Include smaller functions and ignore generated directories:

```bash
codesweep ./lib --token 15 --ignore generated --ignore coverage
```

Short options are also supported:

```bash
codesweep ./lib -lg flutter -tk 20 -t 75 -ig generated -ig .dart_tool
```

## Command-line reference

```text
codesweep [FOLDER] [OPTIONS]

-lg, --language <LANG>       Language to scan; default: typescript
-tk, --token <NUMBER>        Minimum function size; default: 30 tokens
-t,  --threshold <PERCENT>   Similarity percentage; default: 100
-ig, --ignore <DIR>          Additional directory name to ignore; repeatable
-h,  --help                  Show the complete help
```

The default ignored directories are `.git`, `target`, and `node_modules`.

## Example output

```text
Exact structural duplicates (minimum 30 tokens). Review before refactoring.

Duplicate group 1 — 2 functions, 42 tokens each
  src/user.ts:12-20  normalizeUser (8 body lines)
  src/admin.ts:44-52 normalizeAdmin (8 body lines)

Total TypeScript files: 37
Total functions: 184
Duplicate groups: 1
Functions in duplicate groups: 2
Failed files: 0
```

## How duplicate detection works

codesweep parses each supported source file into a syntax tree, extracts
functions and methods, normalizes their structure, and compares structural
features. A threshold of `100` reports exact structural duplicates. Lower values
report similar function pairs using structural shingle overlap.

The similarity score is an aid for code review and refactoring; it does not
claim that two functions are behaviorally equivalent.

## Verify a download

macOS or Linux:

```bash
shasum -a 256 -c codesweep-vX.Y.Z-macos-arm64.tar.gz.sha256
```

Windows PowerShell:

```powershell
Get-FileHash .\codesweep-vX.Y.Z-windows-x64.zip -Algorithm SHA256
```

Compare the PowerShell result with the value in the matching `.sha256` file.

## Troubleshooting

### `codesweep: command not found`

Open a new terminal after installation. For manual installs, confirm that the
directory containing `codesweep` or `codesweep.exe` is included in `PATH`.

### macOS blocks the downloaded binary

Homebrew installation is recommended. For a manually downloaded archive that
you trust and whose checksum you verified, remove the quarantine attribute:

```bash
xattr -d com.apple.quarantine ./codesweep
```

### No duplicate functions are reported

Use a lower token minimum or similarity threshold, and confirm the selected
language matches the project:

```bash
codesweep ./src -lg ts -tk 10 -t 70
```

### Generated files make the scan noisy

Repeat `--ignore` for every additional directory name:

```bash
codesweep . -ig generated -ig coverage -ig dist -ig build
```

## Search keywords

Duplicate code detector, code clone detector, similar function finder, static
analysis CLI, TypeScript duplicate code, JavaScript duplicate code, Flutter Dart
code quality, Kotlin refactoring tool, Swift duplicate functions, Tree-sitter,
Rust CLI, cross-platform developer tool.

---

**codesweep** is distributed as prebuilt binaries for developers who want fast,
language-aware duplicate-code analysis without installing Rust or another
runtime.
