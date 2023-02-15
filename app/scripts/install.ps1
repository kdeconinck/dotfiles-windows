# ======================================================================================================================
# == LICENSE:       Copyright (c) 2023 Kevin De Coninck
# ==
# ==                Permission is hereby granted, free of charge, to any person
# ==                obtaining a copy of this software and associated documentation
# ==                files (the "Software"), to deal in the Software without
# ==                restriction, including without limitation the rights to use,
# ==                copy, modify, merge, publish, distribute, sublicense, and/or sell
# ==                copies of the Software, and to permit persons to whom the
# ==                Software is furnished to do so, subject to the following
# ==                conditions:
# ==
# ==                The above copyright notice and this permission notice shall be
# ==                included in all copies or substantial portions of the Software.
# ==
# ==                THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# ==                EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# ==                OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# ==                NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# ==                HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# ==                WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# ==                FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# ==                OTHER DEALINGS IN THE SOFTWARE.
# ======================================================================================================================

# Verify if "Scoop" is already installed.
# If it's NOT, "Scoop" is installed, followed by "GIT".
# We install "GIT" as this is a requirement for "Scoop".
#
# If scoop is already installed (which means that "GIT" has been installed already), the buckets, the installed
# applications and "Scoop" itself are updated.
If (-Not $(Get-Command scoop)) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    scoop install git
}
Else {
    scoop update
    scoop update *
}

# Configure "GIT".
git config --global user.name "Kevin De Coninck"
git config --global user.email "kevin.dconinck@gmail.com"

# Install all the fonts from the "fonts/" directory.
ForEach ($font in $(Get-ChildItem "..\fonts" -Recurse -Include '*.ttf', '*.ttc', '*.otf')) {
    If (-Not (Test-Path "$ENV:USERPROFILE\AppData\Local\Microsoft\Windows\Fonts\$($font.Name)")) {
        Write-Host "Font NOT found ..."
        Write-Host $font.FullName
        (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere($font.FullName)
    }
}

# Configure "Scoop" and install all the required applications.
scoop bucket add extras
scoop bucket add java

scoop install googlechrome
scoop install gh
scoop install oh-my-posh
scoop install pwsh
scoop install vscode
scoop install 7zip
scoop install dotnet-sdk
scoop install go
scoop install flutter

# Add "Pwsh (PowerShell Core)" as a context menu option.
reg import $($(scoop prefix pwsh) + "\install-explorer-context.reg")

# Add "VS Code" as a context menu option.
reg import $($(scoop prefix vscode) + "\install-context.reg")

# Install the required VS Code extensions.
code --install-extension EditorConfig.EditorConfig --force
code --install-extension ms-vscode.powershell --force
code --install-extension vscode-icons-team.vscode-icons --force
code --install-extension mhutchie.git-graph --force
code --install-extension golang.go --force
code --install-extension dart-code.flutter --force
code --install-extension dart-code.dart-code --force

# Configure VS Code.
Copy-Item "..\config\vscode\settings.json" -Destination $($(scoop prefix vscode) + "\data\user-data\user")
