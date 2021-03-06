;-------------------------------------------------------------------------------------------------------------------
;GTA3, Basic Game Launcher for Mp!  in x86 ASM - (c) 2021 Robert Rayner - Game Launcher!
;-------------------------------------------------------------------------------------------------------------------
format PE GUI 4.0
entry start
include 'win32a.inc'

ID_PLAYERNAME = 101
ID_GAME = 102
ID_CONSOLE = 103

section '.text' code readable executable

  start:
        invoke  GetModuleHandle,0
        invoke  DialogBoxParam,eax,37,HWND_DESKTOP,DialogProc,0
        or      eax,eax
        jz      exit
  exit:
        invoke  ExitProcess,0

proc DialogProc hwnddlg,msg,wparam,lparam
        push    ebx esi edi
        cmp     [msg],WM_COMMAND
        je      .wmcommand
        cmp     [msg],WM_CLOSE
        je      .wmclose
        xor     eax,eax
        jmp     .finish

  .wmcommand:
        cmp     [wparam],BN_CLICKED shl 16 + IDCANCEL
        je      .wmclose
        cmp     [wparam],BN_CLICKED shl 16 + IDOK
        jne     .processed
        invoke  GetDlgItemText,[hwnddlg],ID_PLAYERNAME,player_name,40h
        invoke  GetDlgItemText,[hwnddlg],ID_GAME,game,100h
       ; invoke  consoleinput, [hwnddlg],['55']
     ; invoke consoleinput,[hwnddlg],'J'



      .topmost_ok:
        ;invoke  SetDlgItemText,[hwnddlg],ID_CONSOLE,'',160h; FOR TESTING
        ;consoleinput; hWnd   ;NOT WORKING
        invoke ShellExecute,0,0,game,game,0,SW_SHOWDEFAULT
        jmp     .processed
  .wmclose:
        invoke  EndDialog,[hwnddlg],0
  .processed:
        mov     eax,1
  .finish:
        pop     edi esi ebx
        ret
endp

section '.bss' readable writeable
  player_name rb 40h
  game rb 100h  
  console rb 160h

; BUGGED, STUDYING THIS AREA
proc consoleinput hWnd
          ;invoke  SetDlgItemText,[hWnd],ID_CONSOLE,[input],160h
          invoke  SetDlgItemText,[hWnd],ID_CONSOLE,'DID I DO WORK?',160h
        ret
endp

section '.idata' import data readable writeable
  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL',\
          consoleinput,'SendInput.DLL',\
          shell,'SHELL32.DLL'

import shell,\ 
    ShellExecute,'ShellExecuteA'

  import kernel,\
         GetModuleHandle,'GetModuleHandleA',\
         ExitProcess,'ExitProcess'

  import user,\
         DialogBoxParam,'DialogBoxParamA',\
         GetDlgItemText,'GetDlgItemTextA',\
         SetDlgItemText,'SetDlgItemTextA',\
         EndDialog,'EndDialog'

section '.edata' export data readable

  export 'SendInput.DLL',\
         consoleinput,'SendText'

section '.rsrc' resource data readable

  directory RT_DIALOG,dialogs

  resource dialogs,\
           37,SUBLANG_DEFAULT, demonstration

  dialog demonstration,'Client Launcher',70,70,190,175,WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME
    dialogitem 'STATIC','&Player Name:',-1,10,10,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_PLAYERNAME,10,20,170,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP
    dialogitem 'STATIC','&Directory:',-1,10,40,70,8,WS_VISIBLE
    dialogitem 'EDIT','',ID_GAME,10,50,170,13,WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL

    ; Needs feature
    dialogitem 'EDIT','E',ID_CONSOLE,10,70,160,70,WS_VISIBLE+WS_CHILD+WS_VSCROLL+ES_AUTOVSCROLL+ES_MULTILINE

    dialogitem 'BUTTON','Launch',IDOK,85,150,45,15,WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
    dialogitem 'BUTTON','&Close',IDCANCEL,135,150,45,15,WS_VISIBLE+WS_TABSTOP+BS_PUSHBUTTON
  enddialog
