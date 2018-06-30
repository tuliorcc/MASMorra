INCLUDE Irvine32.inc

;// -------------------------------------------------------------------------
;//  DEFINIÇÃO DE CONSTANTES
;// -------------------------------------------------------------------------
COLS = 80            ;// Colunas do jogo
ROWS = 25            ;// Linhas do jogo
MAPCOLS = (COLS - 2) ;// Colunas do mapa
MAPROWS = (ROWS - 5) ;// Linhas do mapa
MENUQNT = 5			 ;// Quantas opções tem o menu

;// -------------------------------------------------------------------------
;//  DEFINIÇÃO DE VARIÁVEIS
;// -------------------------------------------------------------------------
.data
;// -------------------------------------------------------------------------
;//  VARIÁVEIS: TELA
;// -------------------------------------------------------------------------
xMax BYTE COLS      ;// número maximo de colunas
yMax BYTE ROWS      ;// númer maximo de linhas

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: CONTROLE DO MAPA
;// -------------------------------------------------------------------------
Map BYTE MAPCOLS*MAPROWS Dup('#')	;// vetor de (colunas*linhas) posições. 
posHeroi WORD 0						;// Posição atual do heroi

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: GERAÇÃO DE MAPAS
;// -------------------------------------------------------------------------
emptyCells WORD 0
emptyGoal WORD 0
direction BYTE 0    ;// Direção do corredor [0-Norte, 1-Leste, 2-Sul, 3-Oeste]
pos WORD 0          ;// Ponteiro para a posição atual no mapa (0 - 1559)
passos BYTE 0       ;// Numero de passos que sao dados na geração do mapa

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: CONTROLE DO TERMINAL
;// -------------------------------------------------------------------------
cci CONSOLE_CURSOR_INFO <>
StdOut HANDLE ?
ctitle DB 'MASMorra', 0 ;// Título da janela do terminal

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: TELAS DO MENU
;// -------------------------------------------------------------------------

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: MENU PRINCIPAL
;// -------------------------------------------------------------------------
telaMenu	DB 13, 10
			DB '           __  ___  ___    ____  __  ___', 13, 10
			DB '          /  |/  / / _ |  / __/ /  |/  / ___   ____  ____ ___ _', 13, 10
			DB '         / /|_/ / / __ | _\ \  / /|_/ / / _ \ / __/ / __// _ `/', 13, 10
			DB '        /_/  /_/ /_/ |_|/___/ /_/  /_/  \___//_/   /_/   \_,_/', 13, 10, 13, 10, 13, 10
			DB '                         ____________________ ', 13, 10
			DB '                       / \                   \ ', 13, 10
			DB '                      |  \|    NOVO JOGO     |', 13, 10
			DB '                       \_||    CONQUISTAS    |', 13, 10
			DB '                          |    AJUDA         |', 13, 10
			DB '                          |    CONFIGURACOES |', 13, 10
			DB '                          |    SAIR          |', 13, 10
			DB '                          |  ________________|__', 13, 10
			DB '                          \_/__________________/', 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: CONQUISTAS
;// -------------------------------------------------------------------------
telaConqs	DB 32, 201, 77 DUP(205), 187, 13, 10
			DB 32, 186, '                                  CONQUISTAS                                 ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablabla.                                                            ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                    Pressione qualquer tecla para voltar                     ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: AJUDA
;// -------------------------------------------------------------------------
telaAjuda	DB 32, 201, 77 DUP(205), 187, 13, 10
			DB 32, 186, '                                    AJUDA                                    ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablabla.                                                            ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, ' Recursos utilizados:                                                        ', 186, 13, 10
			DB 32, 186, '   Biblioteca Irvine (http://www.asmirvine.com)                              ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                    Pressione qualquer tecla para voltar                     ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: CONFIGURAÇÕES
;// -------------------------------------------------------------------------
telaConfig	DB 32, 201, 77 DUP(205), 187, 13, 10
			DB 32, 186, '                                 CONFIGURACOES                               ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablablablablablablablablablablablablablablablablablablablablablabla ', 186, 13, 10
			DB 32, 186, ' blablablablabla.                                                            ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                    Pressione qualquer tecla para voltar                     ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0


;// -------------------------------------------------------------------------
;//  DEFINIÇÃO DE PROCEDIMENTOS
;// -------------------------------------------------------------------------
.code

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: HideCursor
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Esconder o cursor piscante do terminal
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
HideCursor PROC
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov StdOut, eax
	invoke GetConsoleCursorInfo, StdOut, OFFSET cci
	mov cci.bVisible, FALSE
	invoke SetConsoleCursorInfo, StdOut, OFFSET cci
	ret
HideCursor ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: ShowMenu
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Imprimir o menu principal e chamar o controle da seta seletora
;//  PARÂMETROS: CL - Opção atual do menu
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
ShowMenu PROC
	mov eax, yellow + (blue * 16)
	call SetTextColor

	mov esi, 0	;// Inicia o índice do menu na primeira opção

	call LimpaTela

	mov edx, OFFSET telaMenu ;// Imprime a tela inicial do menu
	call WriteString

	mov ch, cl			;// Copia a seleção atual para chamar ChangeMenuSel
	call ChangeMenuSel	;// Imprime a seta seletora do menu

MENUL:
	mov  eax, 50
	call Delay
	call ReadKey	;// Verifica se há uma tecla pressionada
	jz MENUL
	cmp ah, 48h	;// Seta para cima
	je CIMA
	cmp ah, 50h	;// Seta para baixo
	je BAIXO
	cmp ah, 1Ch	;// Enter
	jne MENUL
	call DoMenuSel
	ret
BAIXO :
	cmp cl, (MENUQNT - 1)	;// Limitador máximo
	je MENUL
	mov ch, cl
	inc ch
	call ChangeMenuSel
	jmp MENUL
CIMA :
	cmp cl, 0	;// Limitador mínimo
	je MENUL
	mov ch, cl
	dec ch
	call ChangeMenuSel
	jmp MENUL
ShowMenu ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: ChangeMenuSel
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Imprimir a seta seletora do menu
;//  PARÂMETROS:  CH - Nova Opção Selecionada
;//  RETORNO: CL - Opção Selecionada
;// -------------------------------------------------------------------------
ChangeMenuSel PROC
	mov dl, 29			;// pos X da seta
	mov dh, 9			;// base do Y do menu(topo)
	add dh, cl			;// pos Y da seta(atual)
	call Gotoxy
	mov al, 32			;// ASCII: Espaço
	call WriteChar		;// Limpa a seleção anterior
	mov dh, 9			;// base do Y do menu(topo)
	add dh, ch			;// pos Y da seta(nova)
	call Gotoxy
	mov al, 175			;// ASCII: Seta
	call WriteChar		;// Escreve o indicador do menu
	mov cl, ch			;// Troca a opção atual
	ret
ChangeMenuSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: DoMenuSel
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Verificar a opção selecionada no menu e agir de acordo
;//  PARÂMETROS:  CL - Opção Selecionada
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
DoMenuSel PROC
	cmp cl, 0
	je opNovoJogo
	cmp cl, 1
	je opConquistas
	cmp cl, 2
	je opAjuda
	cmp cl, 3
	je opConfig
;// SELEÇÃO DO MENU: Sair
	call LimpaTela
	invoke ExitProcess, 0
;// SELEÇÃO DO MENU: Novo Jogo
opNovoJogo:
		ret ;// Retorna ao procedimento main
;// SELEÇÃO DO MENU: Conquistas
opConquistas:
		call LimpaTela
		mov edx, OFFSET telaConqs
		call WriteString
		jmp MenuRetWait
;// SELEÇÃO DO MENU: Ajuda
opAjuda:
		call LimpaTela
		mov edx, OFFSET telaAjuda
		call WriteString
		jmp MenuRetWait
;// SELEÇÃO DO MENU: Configurações
opConfig:
		call LimpaTela
		mov edx, OFFSET telaConfig
		call WriteString
;// Para telas do menu que aguardam uma tecla para retornar
MenuRetWait:
		mov  eax, 50
		call Delay
		call ReadKey	;// Verifica se há uma tecla pressionada
		jz MenuRetWait
		call ShowMenu   ;// Retorna ao menu principal
		ret
DoMenuSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: LimpaTela
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Limpar a tela, escrevendo o caracter " " (espaço) em toda a 
;//			   matriz do jogo
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
LimpaTela PROC USES eax ecx edx
	mov eax, black + (black * 16) ;// Para a função SETTEXTCOLOR deve ser passado al, onde os 4 bits HSB é a cor de fundo e os 4 LSB são a cor da letra, a multiplicação por 16 é equivalente a dar um shift de 4 bits para a esquerda
	call SETTEXTCOLOR ;// Função Irvine : Configura a cor do texto recebendo como parâmetro o registrador eax
	mov dl, 0 ;// Move o cursor para a posição 0, 0
	mov dh, 0
	call GOTOXY ;// Função Irvine : Configura o cursor para a linha dh e a coluna dl
	movzx ecx, yMax ;// Inicializa o contador do loop com a quantidade de linhas
	inc ecx
	mov al, ' '

LLP1 :
	mov dl, 0
	call GOTOXY
	push ecx
	movzx ecx, xMax ;// Inicializa o contador do loop com a quantidade de colunhas
LLP2 :
	call WRITECHAR ;// Função Irvine : Escreve um caracter no terminal, tMaxX * tMaxY vezes(declarado de forma a ser dois loops aninhados)
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

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: drawBordas
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Desenha as bordas do jogo com o caracter "/" em vermelho
;//  PARÂMETROS: xMax - Quantidade de colunas totais do jogo
;//				 yMax - Quantidade de linhas totais do jogo
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
drawBordas PROC
     mov eax, gray + (black * 16)
     call SetTextColor

     ;// -------------------- Imprime a borda superior do mapa
     movzx ecx, xMax            
     mov al, '#'
L1:
     call WriteChar
     loop L1
     
     ;// ------------------- Imprime as bordas laterais do mapa
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

     ;// ------------------ Imprime a borda de baixo do mapa
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


     ;// --------------------Imprime a borda superior do status
     mov al, '='
     mov dl, 0
     mov dh, yMax
     sub dh, 3
     call GotoXY
     movzx ecx, xMax
L4:
     call WriteChar
     loop L4

     ;// ------------------Imprime a borda de baixo do status
     mov dl, 0
     mov dh, yMax
     call GotoXY
     movzx ecx, xMax
L5:
     call WriteChar
     loop L5
     
     ;// ------------------ Imprime as laterais do status
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

     ;// ------- Reseta a cor e retorna
     mov eax, white + (black * 16)
     call SetTextColor
     ret
drawBordas ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: PrintMapa
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Desenha o mapa do jogo
;//  PARÂMETROS: MAPCOLS - Quantidade de colunas no mapa 
;//				 MAPROWS - Quantidade de linhas no mapa
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
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
     push ecx                 ;// Guarda ecx
     mov ecx, MAPCOLS         ;// ecx = numero de colunas do mapa
     call GOTOXY              ;// Função Irvine : Configura o cursor para a linha dh e a coluna dl
L2:
     mov al, [esi + ebx]
     cmp al, 'A'
     je Hero
Default:
     call WriteChar ;// Desenha padrão (parede ou nada)
     jmp DefLoop

Hero:
     push eax                      ;// guarda 
     mov eax, white + (gray * 16)  ;// Seleciona o branco  
     call SETTEXTCOLOR
     pop eax
     call WriteChar                ;// Desenha o herói
     mov eax, black + (gray * 16)  ;// Volta para a cor padrão
     call SETTEXTCOLOR
     jmp DefLoop

DefLoop:          ;// Continua os loops padrão
     inc ebx   
     loop L2   
     pop ecx
     loop L1
     
     ;// Reseta a cor do print
     mov eax, white + (black * 16)
     call SETTEXTCOLOR

     ret
PrintMapa ENDP

;// ==============================================================
;// ResetMapa PROC
;// Objetivo: Reseta o Mapa, setando todos os bytes do vetor para '#' - parede
;// Usa:     MAPCOLS - Quantidade de colunas no mapa
;//		 MAPROWS - Quantidade de linhas no mapa
;// Retorna: Sem retorno
;// ==============================================================
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

;// ==============================================================
;// GeraMapa PROC
;// Objetivo: Gera o Mapa - drunkard walk modificado
;// Usa:     MAPCOLS - Quantidade de colunas no mapa
;//		 MAPROWS - Quantidade de linhas no mapa
;//          Map     - Mapa (vetor de bytes)
;//          emptyCells - células vazias no mapa
;//          emptyGoal - Meta de células vazias
;//          pos - posição atual na matriz
;//          direction - direcao que a geracao se movera
;//          passos - numero de passos que serão dados
;// Retorna: Sem retorno
;// ==============================================================
GeraMapa PROC
;// ------------------------- Reseta mapa e variáveis
     call ResetMapa
     mov emptyCells, 0
;// ------------------------- Randomiza a meta de células limpas - entre 620 e 870 (aprox. 40 a 55 % do mapa)
     mov eax, 451
     call RandomRange
     add eax, 420
     mov emptyGoal, ax 

;// ------------------------- Define uma posição inicial aleatória NO MEIO DO MAPA e salva em pos
     mov esi, OFFSET Map
     mov eax, 521
     call RandomRange
     add eax, 520
     mov pos, ax   
     mov posHeroi, ax

;// ------------------------- Enquanto Células vazias < Meta
WL1: mov ax, emptyGoal
     cmp emptyCells, ax
     jae Fim

;// ------------------------- Randomiza direção e num. de passos (de 2 a 5)
     ;----------- Randomiza direção (0-4)
     mov eax, 4
     call RandomRange
     mov direction, al
     ;// --------- Randomiza número de passos (1-9)
     mov eax, 9
     call RandomRange
     inc eax
     mov passos, al
     ;// --------- Verifica direção e salta para o trecho correspondente
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
     ;// ---------- Tira paredes para o norte
     xor ecx, ecx
     mov cl, passos
MNC:
     mov ax, pos         
     sub ax, MAPCOLS     ;// Se não pode mover para cima,
     js WL1              ;// volta para o inicio
     
     mov pos, ax;// salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteN
     inc emptyCells
     mov[esi + eax], bl
NowriteN:  
     loop MNC
     jmp WL1

MoveEast:
     ;// ----------Tira paredes para o leste
     xor ecx, ecx
     mov cl, passos
MEC: 
     mov ax, pos
     inc ax       ;// ax = pos+1
     mov bl, 78
     div bl       ;// (pos+1)/78 - Resto fica em AH
     cmp ah, 0
     je WL1      ;// se (pos+1)%78 = 0, então não é valido
     
     mov ax, pos
     inc ax
     mov pos, ax  ;// salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteE
     inc emptyCells
     mov[esi + eax], bl
NowriteE:  
     loop MEC
     jmp WL1


MoveSouth:
     ;// ----------Tira paredes para o sul
     xor ecx, ecx
     mov cl, passos
MSC: 
     mov ax, pos
     add ax, MAPCOLS
     cmp ax, 1559     ;// Se não pode mover para baixo,
     ja WL1           ;// volta para o inicio

     mov pos, ax     ;// salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteS
     inc emptyCells
     mov[esi + eax], bl
NowriteS:  
     loop MSC
     jmp WL1

MoveWest:
     ;// ----------Tira paredes para o oeste
     xor ecx, ecx
     mov cl, passos
MWC :
     mov ax, pos
     mov bl, 78
     div bl         ;// pos/78 - Resto fica em AH
     cmp ah, 0
     je WL1         ;// se pos%78 = 0, então não é valido

     mov ax, pos
     dec ax
     mov pos, ax    ;// salva a nova posição

     mov bl, ' '
     cmp[esi + eax], bl
     je NowriteW
     inc emptyCells
     mov[esi + eax], bl
NowriteW:  
     loop MWC
     jmp WL1



Fim:
     ;// -------- - Insere Personagem no mapa
     mov ax, posHeroi
     mov bl, 'A'
     mov[esi + eax], bl

     ret
GeraMapa ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: main
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Procedimento principal do jogo
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
main PROC

	invoke SetConsoleTitle, OFFSET ctitle	;// Muda o título do terminal
	call HideCursor							;// Esconde o cursor piscante
	mov cl, 0								;// Inicia o seletor do menu na primeira opção
	call ShowMenu							;// Mostra o menu principal
	call Randomize							;// Randomiza a seed
	call LimpaTela							;// Limpa a tela
	call drawBordas							;// Desenha as bordas do jogo
	call ResetMapa							;// Reseta o mapa
	call GeraMapa							;// Gera um novo mapa
	call PrintMapa							;// Desenha o mapa

main ENDP
END main