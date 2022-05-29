{

Win32 PE File Header *FULL* Implementation in Pascal (Delphi) bY SMoKE in 2002
==============================================================================
E-Mail: smoke@armenia.com
WWW   : http://freenet.am/~softland

}

Unit PE;

interface

uses Windows;

const
  IMAGE_NT_SIGNATURE = $00004550;
  MAX_SECTION_NUMBER = 20;

type
  IMAGE_DIR_ITEM = record
                     VirtualAddress: DWORD;
                     Size: DWORD;
                   end;

  IMAGE_FILE_HEADER = record
                        Machine:WORD;
                        NumberOfSections:WORD;
                        TimeDateStamp:DWORD;
                        PointerToSymbolTable:DWORD;
                        NumberOfSymbols:DWORD;
                        SizeOfOptionalHeader:WORD;
                        Characteristics:WORD;
                      end;

  IMAGE_OPTIONAL_HEADER = record
                            Magic:                   WORD;

                            MajorLinkerVersion,
                            MinorLinkerVersion:      BYTE;

                            SizeOfCode,
                            SizeOfInitializedData,
                            SizeOfUninitializedData,
                            AddressOfEntryPoint,
                            BaseOfCode,
                            BaseOfData,
                            ImageBase,
                            SectionAlignment,
                            FileAlignment:           DWORD;

                            Subsystem,
                            DllCharacteristics,
                            MajorOperatingSystemVersion,
                            MinorOperatingSystemVersion,
                            MajorImageVersion,
                            MinorImageVersion,
                            MajorSubsystemVersion,
                            MinorSubsystemVersion: WORD;

                            Win32VersionValue,
                            SizeOfImage,
                            SizeOfHeaders,
                            CheckSum,
                            SizeOfStackReserve,
                            SizeOfStackCommit,
                            SizeOfHeapReserve,
                            SizeOfHeapCommit,
                            LoaderFlags,
                            NumberOfRvaAndSizes: DWORD;
                            IMAGE_DIRECTORY_ENTRIES: record
                                                       _EXPORT:      IMAGE_DIR_ITEM;
                                                       IMPORT:       IMAGE_DIR_ITEM;
                                                       RESOURCE:     IMAGE_DIR_ITEM;
                                                       EXCEPTION:    IMAGE_DIR_ITEM;
                                                       SECURITY:     IMAGE_DIR_ITEM;
                                                       BASERELOC:    IMAGE_DIR_ITEM;
                                                       DEBUG:        IMAGE_DIR_ITEM;
                                                       COPYRIGHT:    IMAGE_DIR_ITEM;
                                                       GLOBALPTR:    IMAGE_DIR_ITEM;
                                                       TLS:          IMAGE_DIR_ITEM;
                                                       CONFIG:       IMAGE_DIR_ITEM;
                                                       BOUND_IMPORT: IMAGE_DIR_ITEM;
                                                       IAT:          IMAGE_DIR_ITEM;
                                                     end;
                             ZERO: array [1..24] of Byte;
                      end;

  SECTION = record
              Name: array [1..8] OF Char;
              VirtualSize: DWORD;
              VirtualAddress: DWORD;
              SizeOfRawData: DWORD;
              PointerToRawData: DWORD;
              PointerToRelocations: DWORD;
              PointerToLinenumbers: DWORD;
              NumberOfRelocations: WORD;
              NumberOfLinenumbers: WORD;
              Characteristics: DWORD;
        end;

var
  PE_HEADER: record
               IMAGE_NT_SIGNATURE: DWORD;
               FILE_HEADER: IMAGE_FILE_HEADER;
               OPTIONAL_HEADER: IMAGE_OPTIONAL_HEADER;
             end;
  SECTION_HEADER: ARRAY [1..MAX_SECTION_NUMBER] of SECTION;


function RVA2Offset(RVA:DWORD):DWORD;
function Offset2RVA(Offset:DWORD):DWORD;

implementation


function RVA2Offset(RVA:DWORD):DWORD;
var i:integer;
    VirtAddr,VA2,szRawData,ptrRawData:DWORD;
begin
  RVA:=RVA-PE_HEADER.OPTIONAL_HEADER.ImageBase;
  for i:=1 to PE_HEADER.FILE_HEADER.NumberOfSections do begin
    VirtAddr:=SECTION_HEADER[i].VirtualAddress;
    szRawData:=SECTION_HEADER[i].SizeOfRawData;
    ptrRawData:=SECTION_HEADER[i].PointerToRawData;
    if RVA>=VirtAddr then begin
      VA2:=VirtAddr+szRawData;
      if RVA<VA2 then begin
        RVA:=RVA-VirtAddr;
        RVA:=RVA+ptrRawData;
      end;
    end;
  end;
  RVA2Offset:=RVA;
end;


function Offset2RVA(Offset: DWORD): DWORD;
var i: Integer;
    VSize, VAddr, RSize, RAddr, X1: DWORD;
begin
  for i:=1 to PE_HEADER.FILE_HEADER.NumberOfSections do begin
    VSize := SECTION_HEADER[i].VirtualSize;
    VAddr := SECTION_HEADER[i].VirtualAddress;
    RSize := SECTION_HEADER[i].SizeOfRawData;
    RAddr:=SECTION_HEADER[i].PointerToRawData;
    if Offset>=RAddr then begin
      X1:=RAddr+RSize;
      if Offset<X1 then Offset:=Offset-RAddr+VAddr;
    end;
  end;
  Offset2RVA:=Offset+PE_HEADER.OPTIONAL_HEADER.ImageBase;
end;


end.
