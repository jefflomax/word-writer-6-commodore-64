REM ,u USR ,s SEQ
REM C:\Tools\c1541.exe -format "WORDWRITER,JL" d64 C:\tmp\TEST.D64 8 -write ww6.prg @8: -write xxx.prg @8: -write readme.txt @8:"labels,s" -exit
C:\Tools\vice\c1541.exe -format "wordwriter,jl" d64 TEST.D64 8 -write ww6data.prg @8:"ww6" -write ov1.prg @8:"ov1" -write ov2.prg @8:"ov2" -list -exit

