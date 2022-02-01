;Add the ability to send some string text. Add the ability to give error message. Create as exported functions
format PE GUI 4.0 DLL
entry DllEntryPoint

include 'win32a.inc'

section '.text' code readable executable

proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        ret
endp 
