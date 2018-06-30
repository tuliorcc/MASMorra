INCLUDE Irvine32.inc

; Constantes 
COLS = 80            ; Colunas do jogo
ROWS = 25            ; Linhas do jogo
MAPCOLS = (COLS - 2) ; Colunas do mapa
MAPROWS = (ROWS - 5) ; Linhas do mapa

; Variáveis
.data
     ; Variáveis da tela
     xMax BYTE COLS      ; número maximo de colunas
     yMax BYTE ROWS      ; númer maximo de linhas

     ; Mapa
     Map BYTE MAPCOLS*MAPROWS Dup('#')  ; vetor de (colunas*linhas) posições. 
     posHeroi WORD 0    ; Posição atual do heroi

     ; Variáveis de geração de mapa
     emptyCells WORD 0
     emptyGoal WORD 0
     direction BYTE 0    ; Direção do corredor [0-Norte, 1-Leste, 2-Sul, 3-Oeste]
     pos WORD 0          ; Ponteiro para a posição atual no mapa (0 - 1559)
     passos BYTE 0       ; Numero de passos que sao dados na geração do mapa



; Procedimentos
.code
; ==============================================================
; LimpaTela PROC
; Objetivo: Limpar a tela do jogo em substituição a função CLRSCR do Irvine, esta função apenas escreve o caracter " "(espaço)em toda a matriz que esta contida no jogo
; Usa:      Sem parâmetros
; Retorna:  Sem retorno
; ==============================================================
LimpaTela PROC
     mov eax, black + (black * 16)      ; Para a função SETTEXTCOLOR deve ser passado al, onde os 4 bits HSB é a cor de fundo e os 4 LSB são a cor da letra, a multiplicação por 16 é equivalente a dar um shift de 4 bits para a esquerda
     call SETTEXTCOLOR                  ; Função Irvine : Configura a cor do texto recebendo como parâmetro o registrador eax
     mov dl, 0                          ; Move o cursor para a posição 0, 0
     mov dh, 0
     call GOTOXY                        ; Função Irvine : Configura o cursor para a linha dh e a coluna dl
     movzx ecx, yMax                    ; Inicializa o contador do loop com a quantidade de linhas
     inc ecx
     mov al, ' '

LLP1 :
     mov dl, 0
     call GOTOXY
     push ecx
     movzx ecx, xMax                    ; Inicializa o contador do loop com a quantidade de colunhas
LLP2 :
     call WRITECHAR                     ; Função Irvine : Escreve um caracter no terminal, tMaxX * tMaxY vezes(declarado de forma a ser dois loops aninhados)
     inc dl
     loop LLP2

     inc dh
     pop ecx
     loop LLP1

     mov eax, white + (black * 16)
     call SETTEXTCOLOR
     mov dl, 0
     mov dh, 0
     call GOTOXY
     ret
LimpaTela ENDP

; ==============================================================
; Bordas PROC
; Objetivo: Desenha as bordas do jogo com o caracter "/" em vermelho
; Usa:      xMax - Quantidade de colunas totais do jogo
;		  yMax - Quantidade de linhas totais do jogo
; Retorna: Sem retorno
; ==============================================================
Bordas PROC
     mov eax, gray + (black * 16)
     call SetTextColor

     ; -------------------- Imprime a borda superior do mapa
     movzx ecx, xMax            
     mov al, '#'
L1:
     call WriteChar
     loop L1
     
     ; ------------------- Imprime as bordas laterais do mapa
     movzx ecx, yMax                  
     sub ecx, 4
     mov dh, 1
L2:
     mov dl, 0
     call GotoXY
     call WriteChar
     mov dl, xMax
     dec dl
     call GotoXY
     call WriteChar
     inc dh
     loop L2

     ; ------------------ Imprime a borda de baixo do mapa
     mov dl, 0
     mov dh, yMax
     sub dh, 4
     call GotoXY
     movzx ecx, xMax           
L3:
     call WriteChar
     loop L3

     mov eax, red + (black * 16)
     call SetTextColor


     ; --------------------Imprime a borda superior do status
     mov al, '='
     mov dl, 0
     mov dh, yMax
     sub dh, 3
     call GotoXY
     movzx ecx, xMax
L4:
     call WriteChar
     loop L4

     ; ------------------Imprime a borda de baixo do status
     mov dl, 0
     mov dh, yMax
     call GotoXY
     movzx ecx, xMax
L5:
     call WriteChar
     loop L5
     
     ; ------------------ Imprime as laterais do status
     mov al, 'I'
     mov ecx, 2
     mov dh, yMax
     sub dh, 2
L6:
     mov dl, 0
     call GotoXY
     call WriteChar
     mov dl, xMax
     dec dl
     call GotoXY
     call WriteChar
     inc dh
     loop L6

     ; ------- Reseta a cor e retorna
     mov eax, white + (black * 16)
     call SetTextColor
     ret
Bordas ENDP

; ============================================================== 
; PrintMapa PROC
; Objetivo: Desenha o Mapa. 
; Usa:     MAPCOLS - Quantidade de colunas no mapa     
;		 MAPROWS - Quantidade de linhas no mapa
; Retorna: Sem retorno
; ==============================================================
PrintMapa PROC USES ecx esi ebx eax
     
     mov eax, black + (gray * 16)
     call SETTEXTCOLOR
     mov dh, 0
     mov dl, 1
     mov ecx, MAPROWS
     mov esi, OFFSET map
     mov ebx, 0
L1:
     add dh, 1
     push ecx                 ; Guarda ecx
     mov ecx, MAPCOLS         ; ecx = numero de colunas do mapa
     call GOTOXY              ; Função Irvine : Configura o cursor para a linha dh e a coluna dl
L2:
     mov al, [esi + ebx]
     cmp al, 'A'
     je Hero
Default:
     call WriteChar ; Desenha padrão (parede ou nada)
     jmp DefLoop

Hero:
     push eax                      ; guarda 
     mov eax, white + (gray * 16)  ; Seleciona o branco  
     call SETTEXTCOLOR
     pop eax
     call WriteChar                ; Desenha o herói
     mov eax, black + (gray * 16)  ; Volta para a cor padrão
     call SETTEXTCOLOR
     jmp DefLoop

DefLoop:          ; Continua os loops padrão
     inc ebx   
     loop L2   
     pop ecx
     loop L1
     
     ; Reseta a cor do print
     mov eax, white + (black * 16)
     call SETTEXTCOLOR

     ret
PrintMapa ENDP

; ==============================================================
; ResetMapa PROC
; Objetivo: Reseta o Mapa, setando todos os bytes do vetor para '#' - parede
; Usa:     MAPCOLS - Quantidade de colunas no mapa
;		 MAPROWS - Quantidade de linhas no mapa
; Retorna: Sem retorno
; ==============================================================
ResetMapa PROC
     mov ecx, 0
     mov esi, OFFSET Map
     mov al, '#'
L1:
     mov [esi+ecx], al
     inc ecx
     cmp ecx, LENGTHOF Map
     jb L1
     
     ret
ResetMapa ENDP

; ==============================================================
; GeraMapa PROC
; Objetivo: Gera o Mapa - drunkard walk modificado
; Usa:     MAPCOLS - Quantidade de colunas no mapa
;		 MAPROWS - Quantidade de linhas no mapa
;          Map     - Mapa (vetor de bytes)
;          emptyCells - células vazias no mapa
;          emptyGoal - Meta de células vazias
;          pos - posição atual na matriz
;          direction - direcao que a geracao se movera
;          passos - numero de passos que serão dados
; Retorna: Sem retorno
; ==============================================================
GeraMapa PROC
; ------------------------- Reseta mapa e variáveis
     call ResetMapa
     mov emptyCells, 0
; ------------------------- Randomiza a meta de células limpas - entre 620 e 870 (aprox. 40 a 55 % do mapa)
     mov eax, 451
     call RandomRange
     add eax, 420
     mov emptyGoal, ax 

; ------------------------- Define uma posição inicial aleatória NO MEIO DO MAPA e salva em pos
     mov esi, OFFSET Map
     mov eax, 521
     call RandomRange
     add eax, 520
     mov pos, ax   
     mov posHeroi, ax

; ------------------------- Enquanto Células vazias < Meta
WL1: mov ax, emptyGoal
     cmp emptyCells, ax
     jae Fim

; ------------------------- Randomiza direção e num. de passos (de 2 a 5)
     ;----------- Randomiza direção (0-4)
     mov eax, 4
     call RandomRange
     mov direction, al
     ; --------- Randomiza número de passos (1-9)
     mov eax, 9
     call RandomRange
     inc eax
     mov passos, al
     ; --------- Verifica direção e salta para o trecho correspondente
     mov esi, OFFSET Map
     cmp direction, 0
     je MoveNorth
     cmp direction, 1
     je MoveEast
     cmp direction, 2
     je MoveSouth
     cmp direction, 3
     je MoveWest

MoveNorth:
     ; ---------- Tira paredes para o norte
     xor ecx, ecx
     mov cl, passos
MNC:
     mov ax, pos         
     sub ax, MAPCOLS     ; Se não pode mover para cima,
     js WL1              ; volta para o inicio
     
     mov pos, ax; salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteN
     inc emptyCells
     mov[esi + eax], bl
NowriteN:  
     loop MNC
     jmp WL1

MoveEast:
     ; ----------Tira paredes para o leste
     xor ecx, ecx
     mov cl, passos
MEC: 
     mov ax, pos
     inc ax       ; ax = pos+1
     mov bl, 78
     div bl       ; (pos+1)/78 - Resto fica em AH
     cmp ah, 0
     je WL1      ; se (pos+1)%78 = 0, então não é valido
     
     mov ax, pos
     inc ax
     mov pos, ax  ; salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteE
     inc emptyCells
     mov[esi + eax], bl
NowriteE:  
     loop MEC
     jmp WL1


MoveSouth:
     ; ----------Tira paredes para o sul
     xor ecx, ecx
     mov cl, passos
MSC: 
     mov ax, pos
     add ax, MAPCOLS
     cmp ax, 1559     ; Se não pode mover para baixo,
     ja WL1           ; volta para o inicio

     mov pos, ax     ; salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteS
     inc emptyCells
     mov[esi + eax], bl
NowriteS:  
     loop MSC
     jmp WL1

MoveWest:
     ; ----------Tira paredes para o oeste
     xor ecx, ecx
     mov cl, passos
MWC :
     mov ax, pos
     mov bl, 78
     div bl         ; pos/78 - Resto fica em AH
     cmp ah, 0
     je WL1         ; se pos%78 = 0, então não é valido

     mov ax, pos
     dec ax
     mov pos, ax    ; salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteW
     inc emptyCells
     mov[esi + eax], bl
NowriteW:  
     loop MWC
     jmp WL1



Fim:
     ; -------- - Insere Personagem no mapa
     mov ax, posHeroi
     mov bl, 'A'
     mov[esi + eax], bl

     ret
GeraMapa ENDP

; *=============================================================
; main PROC
; Objetivo: Função principal do jogo.
; Usa:      Sem parâmetros
; Retorna:  Sem retorno
; =============================================================
main PROC
     call Randomize      ; Randomiza a seed
     call LimpaTela
     call Bordas
     call ResetMapa      
     call GeraMapa
     call PrintMapa
     call LimpaTela

main ENDP
END main