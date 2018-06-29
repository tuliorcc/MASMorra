INCLUDE Irvine32.inc

; Constantes 
COLS = 80            ; Colunas do jogo
ROWS = 25            ; Linhas do jogo
MAPCOLS = (COLS - 2) ; Colunas do mapa
MAPROWS = (ROWS - 5) ; Linhas do mapa

; Vari�veis
.data
     ; Vari�veis da tela
     xMax BYTE COLS      ; n�mero maximo de colunas
     yMax BYTE ROWS      ; n�mer maximo de linhas

     ; Mapa
     Map BYTE MAPCOLS*MAPROWS Dup('#')  ; vetor de (colunas*linhas) posi��es. 

     ; Vari�veis de gera��o de mapa
     emptyCells WORD 0
     emptyGoal WORD 0
     direction BYTE 0    ; Dire��o do corredor [0-Norte, 1-Leste, 2-Sul, 3-Oeste]
     pos WORD 0          ; Ponteiro para a posi��o atual no mapa (0 - 1559)



; Procedimentos
.code
; ==============================================================
; LimpaTela PROC
; Objetivo: Limpar a tela do jogo em substitui��o a fun��o CLRSCR do Irvine, esta fun��o apenas escreve o caracter " "(espa�o)em toda a matriz que esta contida no jogo
; Usa:      Sem par�metros
; Retorna:  Sem retorno
; ==============================================================
LimpaTela PROC
     mov eax, black + (black * 16)      ; Para a fun��o SETTEXTCOLOR deve ser passado al, onde os 4 bits HSB � a cor de fundo e os 4 LSB s�o a cor da letra, a multiplica��o por 16 � equivalente a dar um shift de 4 bits para a esquerda
     call SETTEXTCOLOR                  ; Fun��o Irvine : Configura a cor do texto recebendo como par�metro o registrador eax
     mov dl, 0                          ; Move o cursor para a posi��o 0, 0
     mov dh, 0
     call GOTOXY                        ; Fun��o Irvine : Configura o cursor para a linha dh e a coluna dl
     movzx ecx, xMax                    ; Inicializa o contador do loop com a quantidade de colunas

LLP1 :
     mov dl, 0
     mov dh, cl
     call GOTOXY
     push ecx
     movzx ecx, yMax                    ; Inicializa o contador do loop com a quantidade de linhas
LLP2 :
     mov al, ' '
     call WRITECHAR                     ; Fun��o Irvine : Escreve um caracter no terminal, tMaxX * tMaxY vezes(declarado de forma a ser dois loops aninhados)
     loop LLP2

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
     mov eax, red + (black * 16)
     call SETTEXTCOLOR

     movzx ecx, xMax                   ; Trecho para impress�o da primeira linha da matriz do jogo, imprime tMaxX vezes o caracter "!"
     mov al, '/'
L1:
     call WRITECHAR
     loop L1

     movzx ecx, yMax                   ; Trecho para impress�o dos limites laterais do Jogo, imprime tMaxY vezes o caracter '!' de cada lado do inicio e fim da barra impressa anteriormente
     mov dh, 1
L2:
     mov dl, 0
     call GOTOXY
     call WRITECHAR
     mov dl, xMax
     dec dl
     call GOTOXY
     call WRITECHAR
     inc dh
     loop L2

     mov dl, 0
     mov dh, yMax
     call GOTOXY
     movzx ecx, xMax                 ; Trecho para impress�o da ultima linha da matriz do jogo, imprime tMaxX vezes o caracter "!"
L3:
     call WRITECHAR
     loop L3

     mov eax, white + (black * 16)
     call SETTEXTCOLOR
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
     call GOTOXY              ; Fun��o Irvine : Configura o cursor para a linha dh e a coluna dl
L2:
     mov al, [esi + ebx]
     cmp al, 'A'
     je Hero
Default:
     call WriteChar ; Desenha padr�o (parede ou nada)
     jmp DefLoop

Hero:
     push eax                      ; guarda 
     mov eax, white + (gray * 16)  ; Seleciona o branco  
     call SETTEXTCOLOR
     pop eax
     call WriteChar                ; Desenha o her�i
     mov eax, black + (gray * 16)  ; Volta para a cor padr�o
     call SETTEXTCOLOR
     jmp DefLoop

DefLoop:          ; Continua os loops padr�o
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
; Retorna: Sem retorno
; ==============================================================
GeraMapa PROC
     call ResetMapa
     mov eax, 210
     call RandomRange
     add eax, 940
     mov emptyGoal, ax    ; Gera um n�mero aleat�rio entre 940 e 1150 (60 a 72% do mapa), essa � a quantidade de c�lulas a serem limpas

     mov esi, OFFSET Map
     mov eax, 1559
     call RandomRange
     mov pos, ax          ; Gera a posi��o inicial
     mov bl, 'A'
     mov [esi + eax], bl  ; Insere personagem na posi��o inicial

     ret
GeraMapa ENDP

; *=============================================================
; main PROC
; Objetivo: Fun��o principal do jogo.
; Usa:      Sem par�metros
; Retorna:  Sem retorno
; =============================================================
main PROC
     call Randomize      ; Randomiza a seed
     call LimpaTela
     call Bordas
     call ResetMapa      
     call GeraMapa
     call PrintMapa

main ENDP
END main