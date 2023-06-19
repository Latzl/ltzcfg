#!/bin/bash

shFile=$(readlink -f "${BASH_SOURCE[0]}")
shDir=$(dirname $shFile)
cfgVscDir=$shDir/.vscode
cfgFormatFile=$cfgVscDir/.clang-format

if [ -d .vscode ]; then
	backupNum=1
	while [ -d .vscode${backupNum}.bak ];do
		backupNum=$[ $backupNum + 1]
	done
	echo .vscode exisit, move .vscode to .vscode${backupNum}.bak
	mv .vscode .vscode${backupNum}.bak
fi
#mkdir -p .vscode
cp -r $cfgVscDir .
ln -sf $cfgFormatFile .vscode/

echo '*' > .vscode/.gitignore
