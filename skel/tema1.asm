;PETRUSCA BOGDAN-MIHAI
;323CB
%include "includes/io.inc"
extern getAST
extern freeAST
extern puts
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
    left: resd 1
    right: resd 1
    verif1: resd 1
    verif2: resd 1
    negativ: resd 1
    verif: resd 1
section .data
    impartitor dd 10
section .text
global main

myAtoi:
    
    
    
    push ebp
    mov ebp, esp
    
    xor eax, eax
    xor ecx, ecx
    
    mov ebx, [ebp + 8]
    
    cmp byte[ebx], 48
    jle esteNegativ
    mov dword[negativ], 0
    jmp estePozitiv
esteNegativ:
    inc ebx
    mov dword[negativ], 1
    
estePozitiv:   
    push ebx
    push ecx
    push edx
    
aux:    
    mov cl, byte[ebx]
    cmp cl, 0
    je done
    ;PRINT_CHAR CL
    ;NEWLINE
    inc ebx
    
    cmp cl, '9'
    ja done
    cmp cl, '0'
    jb done
    
    sub ecx, '0'
    
    imul eax, 10
    add eax, ecx
    jmp aux
done:
    cmp dword[negativ], 1
    je negatie
    jmp pozitiv
negatie:
    mov edx, 0
    sub edx, eax
    mov eax, edx
pozitiv:
    pop edx
    pop ecx
    pop ebx
 
    leave
    ret
    
    
    

verifCaract:
    
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    
    
    cmp byte[ebx], '+'
    jne esteInmultire
    
    mov eax, 0
    leave 
    ret

esteInmultire:
    cmp byte[ebx], '*'
    jne esteImpartire
    
    mov eax, 0
    leave
    ret
    
esteImpartire:
    cmp byte[ebx], '/'
    jne esteMinus
    
    mov eax, 0
    leave
    ret
    
esteMinus:
    mov cl, byte[ebx + 1]
    cmp cl, 0
    jne esteNumar
    
    
    mov cl, [ebx]
    cmp cl, 48
    jge esteNumar
    
    mov eax, 0
    leave
    ret
    
esteNumar:
    mov eax, 1
    leave
    ret
 
potiCalcula:
    xor ecx, ecx
    xor edx, edx
    
    mov ecx, dword[eax + 4]
    mov edx, dword[eax + 8]
    
    
    mov ebx, [eax]
    push ebx
    call verifCaract
    add esp, 4
    
    xor ecx, ecx
    mov ecx, eax
    
    mov ebx, [edx]
    push ebx
    call verifCaract
    add esp, 4
    
    cmp eax, 1
    je esteValida
    
    
esteValida:
    cmp ecx, 1
    je operatie
    
 
   
auxAdunare:

    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    
    add eax, ebx
    
    leave
    ret
adunare:

    push dword[left]
    push dword[right]
    call auxAdunare
    add esp, 8
    jmp outOperatie
    
auxScadere:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    mov eax, [ebp + 12]    
    
    sub eax, ebx
    
    leave
    ret
    
scadere:
    push dword[left]
    push dword[right]
    call auxScadere
    add esp, 8
    jmp outOperatie  
auxInmultire:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]
    mov eax, [ebp + 12]
    push edx
    xor edx, edx
    ;TODO NUMERE NEGATIvE
    ;cmp ebx, 0
    ;jle numereNegative
    ;cmp eax, 0
   ; jle numereNegative
    
    mul ebx
    pop edx
    leave
    ret
    
    
inmultire:
    push dword[left]
    push dword[right]
    call  auxInmultire
    add esp, 8
    jmp outOperatie  
    
auxImpartire:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 8]  
    mov eax, [ebp + 12]
    
    xor edx, edx
    cmp eax, 0
    jl maiMicCaZero
    jmp maiMareCaZero
maiMicCaZero:
    not edx
    idiv ebx
    jmp iesiAfara
maiMareCaZero:  
    
    cmp ebx, 0
    jl maiMic
    div ebx
    jmp iesiAfara
maiMic:        
    idiv ebx
iesiAfara:
    leave
    ret
        
    
impartire:
    push dword[left]
    push dword[right]
    call auxImpartire
    add esp, 8
    jmp outOperatie    
operatie:
        
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
        
        mov ecx, [eax + 4]
        mov edx, [eax + 8]
        
        mov ebx, [eax]
        
        push eax
        push ebx
        
        mov ebx, [ecx]
        push ebx
        call myAtoi
        add esp, 4
        mov [left], eax
        xor ebx, ebx
        mov ebx, [edx]
        push ebx
        call myAtoi
        add esp, 4
        mov [right], eax
        
        pop ebx
        cmp byte[ebx], '+'
        je adunare
        cmp byte[ebx], '-'
        je scadere
        cmp byte[ebx], '*'
        je inmultire
        cmp byte[ebx], '/'
        je impartire
        
outOperatie:
        mov ecx, eax
        pop eax
        push ecx
        push dword[eax]
        call intToChar
        add esp, 8
        leave
        ret

esteFrunza:
    cmp dword[eax + 8], 0
    je label3    
    
label3:
    leave
    ret


parcurgere:
   
    push ebp
    mov ebp, esp
   
    mov eax, [ebp + 8]
   
   
    mov ebx, [eax]
    ;PRINT_CHAR [ebx]
    
    ;VERIFIC DACA COPIII SUNT NUMERE
    push eax
    push eax
    
    push ebx
    call verifCaract
    add esp, 4
    
    cmp eax, 0
    jne aici
    
    pop eax
    mov ebx, [eax + 4]
    mov edx, [eax + 8]
    
    push ebx
    mov ebx, [ebx]
    push ebx
    call verifCaract
    add esp, 4
    mov [verif1], eax
    pop ebx
    
    push edx
    mov ebx, [edx]
    push ebx
    call verifCaract
    add esp, 4
    mov [verif2], eax
    pop edx
    
    cmp dword[verif1], 1
    jne aici
    cmp dword[verif2], 1
    jne aici
    
    pop eax
    
    push eax
    call operatie
    add esp, 4
    jmp aici2
    
aici:   
    pop eax
aici2:

    cmp dword[eax + 4], 0
    je esteFrunza
   
   
    push eax
    mov eax, [eax + 4]
    push eax
    call parcurgere
    add esp, 4
    pop eax
   
    
    
    push eax
    
    mov ebx, [eax]
    push ebx
    call verifCaract
    add esp, 4
    mov [verif], eax
    pop eax
    
    cmp dword[verif], 0
    jne afara2
    
    push eax
    mov ecx, [eax + 4]
    
    push eax
    mov ebx, [ecx]
    push ebx
    call verifCaract
    add esp, 4
    cmp eax, 0
    je afara
    pop eax
    mov edx, [eax + 8]
    
    mov ebx, [edx]
    push ebx
    call verifCaract
    add esp, 4
    cmp eax, 0
    je afara
    
    pop eax
    push eax
    call operatie
    add esp, 4
    jmp afara2
   
afara:
    pop eax 
afara2: 
    push eax
    mov eax, [eax + 8]
    push eax
    call parcurgere
    add esp, 4
    pop eax
   
    
    push eax
    
    mov ebx, [eax]
    push ebx
    call verifCaract
    add esp, 4
    mov [verif], eax
    pop eax
    
    cmp dword[verif], 0
    jne afara3
    
    push eax
    mov ecx, [eax + 4]
    
    push eax
    mov ebx, [ecx]
    push ebx
    call verifCaract
    add esp, 4
    cmp eax, 0
    je afara3
    pop eax
    mov edx, [eax + 8]
    
    mov ebx, [edx]
    push ebx
    call verifCaract
    add esp, 4
    cmp eax, 0
    je afara3
    
    pop eax
    push eax
    call operatie
    add esp, 4
    jmp afara4
   
afara3:
    pop eax 
afara4: 
  
 
  
  
   
   
    leave
    ret
    
nrCifre:    
    xor eax, eax
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov edx, 0
    
    xor ecx, ecx
    mov ebx, 10
    
    
    
   ; PRINT_DEC 4, eax
loop:
    inc ecx
    div ebx
    mov edx, 0
    cmp eax, 0
    jg loop
    
    mov eax, ecx
    leave
    ret
    
    
intToChar:
    
    push ebp
    mov ebp, esp
    push eax
 
    mov ebx, [ebp +8]
    mov eax, [ebp + 12]
    
    
    cmp eax, 0
    jl nrNegativ
    mov dword[negativ], 0
    jmp nrPozitiv
nrNegativ:
    mov dword[negativ], 1
    push edx
    mov edx, 0
    sub edx, eax
    mov eax, edx
    pop edx
nrPozitiv:
    push eax
    push ebx
    push eax
    call nrCifre
    add esp, 4
    ;IN ECX SE VA AFLA NUMARUL DE CIFRE
    mov ecx, eax
    pop ebx
    pop eax
    cmp dword[negativ], 1
    jne convert
    mov dl, '-'
    mov byte[ebx], dl
    
convert:
    xor edx, edx
    push ecx
    mov ecx, [impartitor]
    div ecx

    pop ecx
    add dl, '0'
    cmp dword[negativ], 1
    je nuScad_1
    mov byte[ebx + ecx - 1], dl
    jmp scad_1
nuScad_1:
    mov byte[ebx + ecx], dl
scad_1:
    loop convert
    pop eax
    
    leave
    ret
        
    

main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    ;IN EAX PUN NODE*
    mov eax, [root]
    
    ;IN EBX PUN CHAR*
    push eax
    call parcurgere
    add esp, 4
    
    
    ;push eax
    ;call parcurgere
    ;add esp, 4
    ;IN ECX PUN COPILUL STANG
    ;IN EDX PUN COPILUL DREPT
iesire:
  
    push ebx
    call puts
    add esp, 4
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret