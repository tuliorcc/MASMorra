INCLUDE Irvine32.inc

;// -------------------------------------------------------------------------
;//  DEFINI��O DE CONSTANTES
;// -------------------------------------------------------------------------
COLS = 80            ;// Colunas do jogo
ROWS = 25            ;// Linhas do jogo
MAPCOLS = (COLS - 2) ;// Colunas do mapa
MAPROWS = (ROWS - 5) ;// Linhas do mapa
MENUQNT = 5			 ;// Quantas op��es tem o menu

;// -------------------------------------------------------------------------
;//  DEFINI��O DE VARI�VEIS
;// -------------------------------------------------------------------------
.data
;// -------------------------------------------------------------------------
;//  VARI�VEIS: TELA
;// -------------------------------------------------------------------------
xMax BYTE COLS      ;// n�mero maximo de colunas
yMax BYTE ROWS      ;// n�mer maximo de linhas

;// -------------------------------------------------------------------------
;//  VARI�VEIS: CONTROLE DO MAPA
;// -------------------------------------------------------------------------
Map BYTE MAPCOLS*MAPROWS Dup('#')	;// vetor de (colunas*linhas) posi��es. 
posHeroi WORD 0						;// Posi��o atual do heroi

;// -------------------------------------------------------------------------
;//  VARI�VEIS: GERA��O DE MAPAS
;// -------------------------------------------------------------------------
emptyCells WORD 0
emptyGoal WORD 0
direction BYTE 0    ;// Dire��o do corredor [0-Norte, 1-Leste, 2-Sul, 3-Oeste]
pos WORD 0          ;// Ponteiro para a posi��o atual no mapa (0 - 1559)
passos BYTE 0       ;// Numero de passos que sao dados na gera��o do mapa

;// -------------------------------------------------------------------------
;//  VARI�VEIS: CONTROLE DO TERMINAL
;// -------------------------------------------------------------------------
cci CONSOLE_CURSOR_INFO <>
StdOut HANDLE ?
ctitle DB 'MASMorra', 0 ;// T�tulo da janela do terminal

;// -------------------------------------------------------------------------
;//  VARI�VEIS: TELAS DO MENU
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
;//  TELAS DO MENU: CONFIGURA��ES
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
;//  DEFINI��O DE PROCEDIMENTOS
;// -------------------------------------------------------------------------
.code
;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: HideCursor
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Esconder o cursor piscante do terminal
;//  PAR�METROS: N�o Possui
;//  RETORNO: N�o Possui
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
;//  PAR�METROS: CL - Op��o atual do menu
;//  RETORNO: N�o Possui
;// -------------------------------------------------------------------------
ShowMenu PROC
	mov eax, yellow + (blue * 16)
	call SetTextColor

	mov esi, 0	;// Inicia o �ndice do menu na primeira op��o

	call clrscr

	mov edx, OFFSET telaMenu ;// Imprime a tela inicial do menu
	call WriteString

	mov ch, cl			;// Copia a sele��o atual para chamar ChangeMenuSel
	call ChangeMenuSel	;// Imprime a seta seletora do menu

MENUL:
	mov  eax, 50
	call Delay
	call ReadKey	;// Verifica se h� uma tecla pressionada
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
	cmp cl, (MENUQNT - 1)	;// Limitador m�ximo
	je MENUL
	mov ch, cl
	inc ch
	call ChangeMenuSel
	jmp MENUL
CIMA :
	cmp cl, 0	;// Limitador m�nimo
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
;//  PAR�METROS:  CH - Nova Op��o Selecionada
;//  RETORNO: CL - Op��o Selecionada
;// -------------------------------------------------------------------------
ChangeMenuSel PROC
	mov dl, 29			;// pos X da seta
	mov dh, 9			;// base do Y do menu(topo)
	add dh, cl			;// pos Y da seta(atual)
	call Gotoxy
	mov al, 32			;// ASCII: Espa�o
	call WriteChar		;// Limpa a sele��o anterior
	mov dh, 9			;// base do Y do menu(topo)
	add dh, ch			;// pos Y da seta(nova)
	call Gotoxy
	mov al, 175			;// ASCII: Seta
	call WriteChar		;// Escreve o indicador do menu
	mov cl, ch			;// Troca a op��o atual
	ret
ChangeMenuSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: DoMenuSel
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Verificar a op��o selecionada no menu e agir de acordo
;//  PAR�METROS:  CL - Op��o Selecionada
;//  RETORNO: N�o Possui
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
;// SELE��O DO MENU: Sair
	call clrscr
	invoke ExitProcess, 0
;// SELE��O DO MENU: Novo Jogo
opNovoJogo:
		ret ;// Retorna ao procedimento main
;// SELE��O DO MENU: Conquistas
opConquistas:
		call clrscr
		mov edx, OFFSET telaConqs
		call WriteString
		jmp MenuRetWait
;// SELE��O DO MENU: Ajuda
opAjuda:
		call clrscr
		mov edx, OFFSET telaAjuda
		call WriteString
		jmp MenuRetWait
;// SELE��O DO MENU: Configura��es
opConfig:
		call clrscr
		mov edx, OFFSET telaConfig
		call WriteString
;// Para telas do menu que aguardam uma tecla para retornar
MenuRetWait:
		mov  eax, 50
		call Delay
		call ReadKey	;// Verifica se h� uma tecla pressionada
		jz MenuRetWait
		call ShowMenu   ;// Retorna ao menu principal
		ret
DoMenuSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: LimpaTela
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Limpar a tela, escrevendo o caracter " " (espa�o) em toda a 
;//			   matriz do jogo
;//  PAR�METROS: N�o Possui
;//  RETORNO: N�o Possui
;// -------------------------------------------------------------------------
LimpaTela PROC
     mov eax, black + (black * 16)      ;// Para a fun��o SETTEXTCOLOR deve ser passado al, onde os 4 bits HSB � a cor de fundo e os 4 LSB s�o a cor da letra, a multiplica��o por 16 � equivalente a dar um shift de 4 bits para a esquerda
     call SETTEXTCOLOR                  ;// Fun��o Irvine : Configura a cor do texto recebendo como par�metro o registrador eax
     mov dl, 0                          ;// Move o cursor para a posi��o 0, 0
     mov dh, 0
     call GOTOXY                        ;// Fun��o Irvine : Configura o cursor para a linha dh e a coluna dl
     movzx ecx, xMax                    ;// Inicializa o contador do loop com a quantidade de colunas

LLP1:
     mov dl, 0
     mov dh, cl
     call GOTOXY
     push ecx
     movzx ecx, yMax                    ;// Inicializa o contador do loop com a quantidade de linhas
LLP2:
     mov al, ' '
     call WRITECHAR                     ;// Fun��o Irvine : Escreve um caracter no terminal, tMaxX * tMaxY vezes(declarado de forma a ser dois loops aninhados)
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

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: drawBordas
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Desenha as bordas do jogo com o caracter "/" em vermelho
;//  PAR�METROS: xMax - Quantidade de colunas totais do jogo
;//				 yMax - Quantidade de linhas totais do jogo
;//  RETORNO: N�o Possui
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
;//  PAR�METROS: MAPCOLS - Quantidade de colunas no mapa 
;//				 MAPROWS - Quantidade de linhas no mapa
;//  RETORNO: N�o Possui
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
     call GOTOXY              ;// Fun��o Irvine : Configura o cursor para a linha dh e a coluna dl
L2:
     mov al, [esi + ebx]
     cmp al, 'A'
     je Hero
Default:
     call WriteChar ;// Desenha padr�o (parede ou nada)
     jmp DefLoop

Hero:
     push eax                      ;// guarda 
     mov eax, white + (gray * 16)  ;// Seleciona o branco  
     call SETTEXTCOLOR
     pop eax
     call WriteChar                ;// Desenha o her�i
     mov eax, black + (gray * 16)  ;// Volta para a cor padr�o
     call SETTEXTCOLOR
     jmp DefLoop

DefLoop:          ;// Continua os loops padr�o
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
;//          emptyCells - c�lulas vazias no mapa
;//          emptyGoal - Meta de c�lulas vazias
;//          pos - posi��o atual na matriz
;//          direction - direcao que a geracao se movera
;//          passos - numero de passos que ser�o dados
;// Retorna: Sem retorno
;// ==============================================================
GeraMapa PROC
;// ------------------------- Reseta mapa e vari�veis
     call ResetMapa
     mov emptyCells, 0
;// ------------------------- Randomiza a meta de c�lulas limpas - entre 620 e 870 (aprox. 40 a 55 % do mapa)
     mov eax, 451
     call RandomRange
     add eax, 420
     mov emptyGoal, ax 

;// ------------------------- Define uma posi��o inicial aleat�ria NO MEIO DO MAPA e salva em pos
     mov esi, OFFSET Map
     mov eax, 521
     call RandomRange
     add eax, 520
     mov pos, ax   
     mov posHeroi, ax

;// ------------------------- Enquanto C�lulas vazias < Meta
WL1: mov ax, emptyGoal
     cmp emptyCells, ax
     jae Fim

;// ------------------------- Randomiza dire��o e num. de passos (de 2 a 5)
     ;----------- Randomiza dire��o (0-4)
     mov eax, 4
     call RandomRange
     mov direction, al
     ;// --------- Randomiza n�mero de passos (1-9)
     mov eax, 9
     call RandomRange
     inc eax
     mov passos, al
     ;// --------- Verifica dire��o e salta para o trecho correspondente
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
     sub ax, MAPCOLS     ;// Se n�o pode mover para cima,
     js WL1              ;// volta para o inicio
     
     mov pos, ax;// salva a nova posi��o

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
     je WL1      ;// se (pos+1)%78 = 0, ent�o n�o � valido
     
     mov ax, pos
     inc ax
     mov pos, ax  ;// salva a nova posi��o

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
     cmp ax, 1559     ;// Se n�o pode mover para baixo,
     ja WL1           ;// volta para o inicio

     mov pos, ax     ;// salva a nova posi��o

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
     je WL1         ;// se pos%78 = 0, ent�o n�o � valido

     mov ax, pos
     dec ax
     mov pos, ax    ;// salva a nova posi��o

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
;//  PAR�METROS: N�o Possui
;//  RETORNO: N�o Possui
;// -------------------------------------------------------------------------
main PROC
	invoke SetConsoleTitle, OFFSET ctitle	;// Muda o t�tulo do terminal
	call HideCursor							;// Esconde o cursor piscante
	mov cl, 0								;// Inicia o seletor do menu na primeira op��o
	call ShowMenu							;// Mostra o menu principal
	call Randomize							;// Randomiza a seed
	call LimpaTela							;// Limpa a tela
	call drawBordas							;// Desenha as bordas do jogo
	call ResetMapa							;// Reseta o mapa
	call GeraMapa							;// Gera um novo mapa
	call PrintMapa							;// Desenha o mapa
main ENDP
END main