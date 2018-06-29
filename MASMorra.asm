INCLUDE Irvine32.inc

; Constantes 
COLS = 80            ; Colunas do jogo
ROWS = 25            ; Linhas do jogo
MAPCOLS = (COLS - 2) ; Colunas do mapa
MAPROWS = (ROWS - 5) ; Linhas do mapa

; Variáveis
.data
     ; Variaveis da tela
     xMax BYTE COLS      ; número maximo de colunas
     yMax BYTE ROWS      ; númer maximo de linhas

     ; Variaveis do mapa
     Map BYTE MAPCOLS*MAPROWS Dup('#')  ; Mapa: vetor de (colunas*linhas) posições. 


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
     movzx ecx, xMax                    ; Inicializa o contador do loop com a quantidade de colunas

LLP1 :
     mov dl, 0
     mov dh, cl
     call GOTOXY
     push ecx
     movzx ecx, yMax                    ; Inicializa o contador do loop com a quantidade de linhas
LLP2 :
     mov al, ' '
     call WRITECHAR                     ; Função Irvine : Escreve um caracter no terminal, tMaxX * tMaxY vezes(declarado de forma a ser dois loops aninhados)
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

     movzx ecx, xMax                   ; Trecho para impressão da primeira linha da matriz do jogo, imprime tMaxX vezes o caracter "!"
     mov al, '/'
L1:
     call WRITECHAR
     loop L1

     movzx ecx, yMax                   ; Trecho para impressão dos limites laterais do Jogo, imprime tMaxY vezes o caracter '!' de cada lado do inicio e fim da barra impressa anteriormente
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
     movzx ecx, xMax                 ; Trecho para impressão da ultima linha da matriz do jogo, imprime tMaxX vezes o caracter "!"
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
     
L1:
     add dh, 1
     mov ebx, 0    
     push ecx                 ; Guarda ecx
     mov ecx, MAPCOLS         ; ecx = numero de colunas do mapa
     call GOTOXY              ; Função Irvine : Configura o cursor para a linha dh e a coluna dl
L2:
     mov al, [esi + ebx]
     call WriteChar
     inc ebx
     loop L2
     pop ecx
     loop L1
     
     ; Reseta a cor do print
     mov eax, white + (black * 16)
     call SETTEXTCOLOR

     ret
PrintMapa ENDP


main PROC
     call LimpaTela
     call Bordas
     call PrintMapa

main ENDP
END main