# word-writer-6-commodore-64
Word Writer 6 for the Commodore 64 Source Code - 6502 Assembly Language (C) 1983 - 1991

This is the source code to Word Writer 6 for the Commodore 64 published by Timeworks.

Word Writer was originally written in the 2500AD Cross Assembler.  That source is included in the WW6_2500AD folder.  Running the 2500AD assembler is not feasible today so the source code has been converted using [Convert To ACME](https://github.com/jefflomax/converttoacme) to the free ACME Cross Assembler, available on Windows, MacOS, and Linux.  The converted code is in WW6_ACME.

## Setup
The easy way to start is to setup using the [acme-assembly-vscode-template](https://github.com/Esshahn/acme-assembly-vscode-template).  This will include 

### Folder Structure
```
C:\Tools\VICE ( VICE emulator )
\bin\win\acme.exe
\bin\mac\acme
\bin\linux\acme
\converttoacme (publish the .NET Core 3 Convert To ACME here is you wish to re-run the conversion to ACME)
\WW6_2500AD
Original .ASM Files
convert.bat
\WW6_ACME
Converted .ASM Files
asm.bat  (assemble ww6outln.prg and ww6data.prg)
lst.bat  (create a source listing)
runww6data.bat  (run Word Writer 6 built with the Mini Database overlay)
runww6outln.bat (run Word Writer 6 built with the Outliner overlay)
rundisk.bat (run Word Writer 6 from a D64 file including the program and both overlays)
\WW6_ACME\build
extractOverlays.ps1 (open the built Word Writer programs and extract the overlays)
createDiskWithOverlays.bat (create a D64 disk of WW6 and the two overlays)
\WW6_ACME\.vscode
tasks.json (Visual Studio Code CTRL-SHIFT-B build file to assemble and run)
```

## Assembling and running
To assemble and run Word Writer 6, have WWDATA.ASM the current file in Visual Studio Code (Mini DB overlay included) or WW.ASM as the current file (Outliner overlay included) and press CTRL-SHIFT-B.  This will assemble and launch just the program in VICE.

## Creating a disk with overlays
* Run asm.bat to assemble Word Writer 6 versions with both overlays.
* In the Build folder, run extractOverlays.ps1 (tested only on Windows 10).  This will parse the symbol files (labels, labelsd) determine the location of the overlay in each file, and write out ov1.prg and ov2.prg.
* In the Build folder, run createDiskWithOverlays.bat.  This will use VICE to create TEST.D64 including ww6 and the two overlays
* Run rundisk.bat to launch VICE, attach TEST.D64, and run Word Writer 6.


