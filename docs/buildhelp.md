\# Build instructions

\## Build requirements

Git (and CLI; Git Bash)

\## Build help

To build one of the executables, find the corresponding directory in `build/\[name]` and PowerShell script \*\*(run as admin)\*\* to build the executables. The build files are encrypted as structured binary, and are built with the build script.

\## Get started

To start building the executable, open Git Bash as Administrator and use these commands (skip first command if installed using Git):

```Bash

git clone https://github.com/poireguy/ticket-util.git

cd ticket-util

cd build

cd \[executable-to-build]

../~build.exe -BinDir .

```

