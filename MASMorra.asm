INCLUDE Irvine32.inc
INCLUDELIB Winmm.lib	;// Biblioteca do PlaySound

PlaySound PROTO, pszSound : PTR BYTE, hmod : DWORD, fdwSound : DWORD

;// -------------------------------------------------------------------------
;//  DEFINIÇÃO DE CONSTANTES
;// -------------------------------------------------------------------------
MENUQNT = 4				;// Quantas opções tem o menu
MAXLEVEL = 20			;// Nível máximo

;// -------------------------------------------------------------------------
;//  CONSTANTES: MAPA, OBJETOS E PERSONAGENS
;// -------------------------------------------------------------------------
COLS = 80				;// Colunas do jogo
ROWS = 25				;// Linhas do jogo
MAPCOLS = (COLS - 2)	;// Colunas do mapa
MAPROWS = (ROWS - 5)	;// Linhas do mapa
HEROICHAR = 143			;// Caractere do herói
ESCADACHAR = 35		;// Caractere das escadas
PAREDECHAR = 178		;// Caractere das paredes
VAZIOCHAR  = ' '		;// Caractere vazio
BAUCHAR = 254			;// Caractere dos baús
MONSTROCHAR = 38		;// Caractere dos monstros

;// -------------------------------------------------------------------------
;//  CONSTANTES: FLAGS DO PLAYSOUND
;// -------------------------------------------------------------------------
SND_FILENAME  = 20000h
SND_ASYNC	  = 00001h
SND_NODEFAULT = 00002h
SND_LOOP	  = 00008h

;// -------------------------------------------------------------------------
;//  DEFINIÇÃO DE VARIÁVEIS
;// -------------------------------------------------------------------------
.data
;// -------------------------------------------------------------------------
;//  VARIÁVEIS: ÁUDIOS
;// -------------------------------------------------------------------------
auClick		BYTE 'audio/click.wav', 0
auEvil		BYTE 'audio/evil.wav', 0
auHurt		BYTE 'audio/hurt.wav', 0
auPunch		BYTE 'audio/punch.wav', 0
auDoor		BYTE 'audio/door.wav', 0
auTada		BYTE 'audio/tada.wav', 0
auCoin		BYTE 'audio/coin.wav', 0
auPotion	BYTE 'audio/potion.wav', 0

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: TELA
;// -------------------------------------------------------------------------
xMax BYTE COLS      ;// número maximo de colunas
yMax BYTE ROWS      ;// númer maximo de linhas

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: CONTROLE E EXIBIÇÃO DO MAPA
;// -------------------------------------------------------------------------
Map BYTE MAPCOLS*MAPROWS Dup(?)	;// vetor de (colunas*linhas) posições. 
posHeroi WORD 0					;// Posição atual do heroi
posEscada WORD 0				;// Posição atual da escada

;// -------------------------------------------------------------------------
;//  VARIÁVEIS: CONTROLE E EXIBIÇÃO DE VARIÁVEIS DO JOGO
;// -------------------------------------------------------------------------
Level BYTE 0				;// Nível atual
inStairs DB 0				;// Indica se o jogador se encontra na escada
Abates WORD 0				;// Monstros abatidos
Movimentos WORD 0			;// Movimentos (passos dados)
BausCnt WORD 0				;// Baús abertos
HealthConf WORD 10			;// Configuração: Vida Inicial
AudioConf BYTE 1			;// Configuração: Efeitos Sonoros
strLevel DB 'LEVEL: ',0
Health WORD 10
strHealth DB 'HEALTH: ',0
Attack BYTE 2
strAttack DB 'ATTACK: ',0
Gold WORD 0
strGold DB 'GOLD: ',0
isDead DB 0
PosMonstro WORD 0			;// Usado para a movimentação dos monstros

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
;//  VARIÁVEIS: TELAS DO JOGO
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
			DB '                       \_||    AJUDA         |', 13, 10
			DB '                          |    CONFIGURACOES |', 13, 10
			DB '                          |    SAIR          |', 13, 10
			DB '                          |  ________________|__', 13, 10
			DB '                          \_/__________________/', 13, 10, 13, 10, 13, 10
			DB '                       Utilize as setas do teclado', 13, 10
			DB '                          e Enter para confirmar', 0

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: AJUDA
;// -------------------------------------------------------------------------
telaAjuda	DB 32, 201, 77 DUP(205), 187, 13, 10
			DB 32, 186, '                                    AJUDA                                    ', 186, 13, 10
			DB 32, 186, '                                 -----------                                 ', 186, 13, 10
			DB 32, 186, '   MASMorra e um jogo de exploracao e sobrevivencia. Tente chegar ao final.  ', 186, 13, 10
			DB 32, 186, '            ___                                                              ', 186, 13, 10
			DB 32, 186, '        ___/_^_\___     - Utilize as setas do teclado para movimentar        ', 186, 13, 10
			DB 32, 186, '       /_<_|_v_|_>_\      seu heroi (',HEROICHAR,'), coletar tesouros e atacar.          ', 186, 13, 10
			DB 32, 186, '      /____|___|____\                                                        ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '     - Monstros (', MONSTROCHAR, ') tem dano relativo ao nivel atual e concedem Gold.        ', 186, 13, 10
			DB 32, 186, '     - Baus de Tesouro (', BAUCHAR, ') concedem Gold ou Vida.                            ', 186, 13, 10
			DB 32, 186, '     - Encontre a Saida (', ESCADACHAR, ') em cada nivel para avancar.                      ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, ' Recursos utilizados:                                                        ', 186, 13, 10
			DB 32, 186, '   - Biblioteca Irvine (http://www.asmirvine.com)                            ', 186, 13, 10
			DB 32, 186, '   - Audios de freesound.org (http://freesound.org)                          ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                Pressione qualquer tecla para voltar ao menu                 ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DO MENU: CONFIGURAÇÕES
;// -------------------------------------------------------------------------
telaConfig	DB 32, 201, 77 DUP(205), 187, 13, 10
			DB 32, 186, '                                 CONFIGURACOES                               ', 186, 13, 10
			DB 32, 186, '                               -----------------                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '               Efeitos Sonoros: [ ] Ativados | [ ] Desativados               ', 186, 13, 10
	        DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '               Vida Inicial: [ ] 10 | [ ] 20 | [ ] 30                        ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '               Retornar ao menu principal                                    ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                     Utilize as setas do teclado e Enter                     ', 186, 13, 10
			DB 32, 186, '                        para alterar as configuracoes                        ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DE FINAL DE PARTIDA: DERROTA
;// -------------------------------------------------------------------------
telaDerrota	DB 32, 201, 77 DUP(205), 187, 13, 10              
			DB 32, 186, '                ____    ____ ____  ____    ___   ______  ___                 ', 186, 13, 10
			DB 32, 186, '                || \\  ||    || \\ || \\  // \\  | || | // \\                ', 186, 13, 10
			DB 32, 186, '                ||  )) ||==  ||_// ||_// ((   ))   ||   ||=||                ', 186, 13, 10
			DB 32, 186, '                ||_//  ||___ || \\ || \\  \\_//    ||   || ||                ', 186, 13, 10
			DB 32, 186, '               -----------------------------------------------               ', 186, 13, 10
			DB 32, 186, '                     Voce foi derrotado. Tente novamente.                    ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                        Nivel alcancado:                                     ', 186, 13, 10
			DB 32, 186, '                          Gold recebido:                                     ', 186, 13, 10
			DB 32, 186, '                      Monstros abatidos:                                     ', 186, 13, 10
			DB 32, 186, '                             Movimentos:                                     ', 186, 13, 10
			DB 32, 186, '                           Baus abertos:                                     ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                Pressione qualquer tecla para voltar ao menu                 ', 186, 13, 10
			DB 32, 200, 77 DUP(205), 188, 13, 10, 0

;// -------------------------------------------------------------------------
;//  TELAS DE FINAL DE PARTIDA: VITÓRIA
;// -------------------------------------------------------------------------
telaVitoria	DB 32, 201, 77 DUP(205), 187, 13, 10              
			DB 32, 186, '                   __ __ __ ______   ___   ____  __  ___                     ', 186, 13, 10
			DB 32, 186, '                   || || || | || |  // \\  || \\ || // \\                    ', 186, 13, 10
			DB 32, 186, '                   \\ // ||   ||   ((   )) ||_// || ||=||                    ', 186, 13, 10
			DB 32, 186, '                    \V/  ||   ||    \\_//  || \\ || || ||                    ', 186, 13, 10
			DB 32, 186, '                  -----------------------------------------                  ', 186, 13, 10
			DB 32, 186, '                            Voce venceu! Parabens!                           ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                        Nivel alcancado:                                     ', 186, 13, 10
			DB 32, 186, '                          Gold recebido:                                     ', 186, 13, 10
			DB 32, 186, '                      Monstros abatidos:                                     ', 186, 13, 10
			DB 32, 186, '                             Movimentos:                                     ', 186, 13, 10
			DB 32, 186, '                           Baus abertos:                                     ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                                                                             ', 186, 13, 10
			DB 32, 186, '                Pressione qualquer tecla para voltar ao menu                 ', 186, 13, 10
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
	push ecx
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE1
	invoke PlaySound, offset auClick, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE1:
	pop eax
	pop ecx
	jmp MENUL
CIMA :
	cmp cl, 0	;// Limitador mínimo
	je MENUL
	mov ch, cl
	dec ch
	call ChangeMenuSel
	push ecx
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE2
	invoke PlaySound, offset auClick, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE2:
	pop eax
	pop ecx
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
	je opAjuda
	cmp cl, 2
	je opConfig
;// SELEÇÃO DO MENU: Sair
	call LimpaTela
	invoke ExitProcess, 0
;// SELEÇÃO DO MENU: Novo Jogo
opNovoJogo:
        call MainGame
        mov cl, 0
		jmp MenuRetWait 
;// SELEÇÃO DO MENU: Ajuda
opAjuda:
		call LimpaTela
		mov edx, OFFSET telaAjuda
		call WriteString
		jmp MenuRetWait
;// SELEÇÃO DO MENU: Configurações
opConfig:
		call showConfig
		call ShowMenu	;// Retorna ao menu principal
		ret
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
;//  PROCEDIMENTO: ShowConfig
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Imprimir o menu de configurações e chamar o controle da seta seletora
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
showConfig PROC USES eax ecx edx
	mov eax, yellow + (blue * 16)
	call SetTextColor

	call LimpaTela

	mov edx, OFFSET telaConfig	;// Imprime a tela inicial do menu de configurações
	call WriteString

	call UpdateConfigIndicator ;//Imprime os indicadores das configurações

	mov cl, 2	;// Inicia o índice das configurações na opção de retorno

	call ChangeConfigSel	;// Imprime a seta seletora do menu de configurações

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
	call DoConfigSel
	jmp MENUL
BAIXO :
	cmp cl, 2	;// Limitador máximo
	je MENUL
	mov ch, cl
	inc ch
	call ChangeConfigSel
	push ecx
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE3
	invoke PlaySound, offset auClick, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE3:
	pop eax
	pop ecx
	jmp MENUL
CIMA :
	cmp cl, 0	;// Limitador mínimo
	je MENUL
	mov ch, cl
	dec ch
	call ChangeConfigSel
	push ecx
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE4
	invoke PlaySound, offset auClick, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE4:
	pop eax
	pop ecx
	jmp MENUL
showConfig ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: ChangeConfigSel
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Imprimir a seta seletora do menu de configurações
;//  PARÂMETROS:  CH - Nova Opção Selecionada
;//  RETORNO: CL - Opção Selecionada
;// -------------------------------------------------------------------------
ChangeConfigSel PROC
	mov dl, 15			;// pos X da seta
	mov dh, 5			;// base do Y do menu(topo)
	add dh, cl			;// pos Y da seta(atual) (2x)
	add dh, cl
	call Gotoxy
	mov al, 32			;// ASCII: Espaço
	call WriteChar		;// Limpa a seleção anterior
	mov dh, 5			;// base do Y do menu(topo)
	add dh, ch			;// pos Y da seta(nova) (2x)
	add dh, ch
	call Gotoxy
	mov al, 175			;// ASCII: Seta
	call WriteChar		;// Escreve o indicador do menu
	mov cl, ch			;// Troca a opção atual
	ret
ChangeConfigSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: DoConfigSel
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Verificar a opção selecionada no menu de configurações
;//  PARÂMETROS:  CL - Opção Selecionada
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
DoConfigSel PROC
	push ecx
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE5
	invoke PlaySound, offset auClick, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE5:
	pop eax
	pop ecx
	cmp cl, 0
	je opAudio
	cmp cl, 1
	je opHealth
	call ShowMenu	;// Retorna ao menu principal
;// SELEÇÃO DO MENU: Efeitos Sonoros
opAudio:
	mov al, AudioConf
	cmp al, 1
	je AudioON
	mov AudioConf, 1
	call UpdateConfigIndicator
	ret
AudioON:
	mov AudioConf, 0
	call UpdateConfigIndicator
	ret
;// SELEÇÃO DO MENU: Vida Inicial
opHealth:
	mov ax, HealthConf
	cmp ax, 10
	je HP10
	cmp ax, 20
	je HP20
HP30:
	mov HealthConf, 10
	call UpdateConfigIndicator
	ret
HP20:
	mov HealthConf, 30
	call UpdateConfigIndicator
	ret
HP10:
	mov HealthConf, 20
	call UpdateConfigIndicator
	ret
DoConfigSel ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: UpdateConfigIndicator
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Verificar as configuraçoes atuais, alterando os indicadores do menu
;//  PARÂMETROS:  Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
UpdateConfigIndicator PROC
;// Limpa todos os indicadores
	mov dl, 35		;// pos X do indicador de Efeitos Sonoros 1
	mov dh, 5		;// pos Y
	call Gotoxy
	mov al, 32		;// ASCII: Espaço
	call WriteChar
	mov dl, 50		;// pos X do indicador de Efeitos Sonoros 2
	call Gotoxy
	mov al, 32		;// ASCII: Espaço
	call WriteChar
	mov dl, 32		;// pos X do indicador de Vida Inicial 1
	mov dh, 7		;// pos Y
	call Gotoxy
	mov al, 32		;// ASCII: Espaço 32
	call WriteChar
	mov dl, 41		;// pos X do indicador de Vida Inicial 2
	call Gotoxy
	mov al, 32		;// ASCII: Espaço
	call WriteChar
	mov dl, 50		;// pos X do indicador de Vida Inicial 3
	call Gotoxy
	mov al, 32		;// ASCII: Espaço
	call WriteChar

;// INDICADOR DA CONFIGURAÇÃO DE EFEITOS SONOROS
	mov dh, 5				;// pos Y
	mov al, AudioConf
	cmp al, 1
	je AudioON
AudioOFF:
	mov dl, 50
	call Gotoxy
	mov al, 254
	call WriteChar
	jmp HPIND
AudioON:
	mov dl, 35
	call Gotoxy
	mov al, 254
	call WriteChar

;// INDICADOR DA CONFIGURAÇÃO DE VIDA INICIAL
HPIND:
	mov dh, 7		;// pos Y
	mov ax, HealthConf
	cmp ax, 10
	je HP10
	cmp ax, 20
	je HP20
HP30:
	mov dl, 50
	call Gotoxy
	mov al, 254
	call WriteChar
	ret
HP20:
	mov dl, 41
	call Gotoxy
	mov al, 254
	call WriteChar
	ret
HP10:
	mov dl, 32
	call Gotoxy
	mov al, 254
	call WriteChar
	ret
UpdateConfigIndicator ENDP

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
	mov al, VAZIOCHAR

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
drawBordas PROC uses eax ecx edx 
     mov eax, gray + (black * 16)
     call SetTextColor

     ;// -------------------- Imprime a borda superior do mapa
     mov al, 201
     call WriteChar

     movzx ecx, xMax
     sub ecx, 2
     mov al, 205
L1:
     call WriteChar
     loop L1

     mov al, 187
     call WriteChar

     ;// ------------------- Imprime as bordas laterais do mapa
     mov al, 186
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
     
     mov al, 200
     call WriteChar

     movzx ecx, xMax  
     sub ecx, 2
     mov al, 205

L3:
     call WriteChar
     loop L3

     mov al, 188
     call WriteChar

     mov eax, red + (black * 16)
     call SetTextColor


     ;// --------------------Imprime a borda superior do status
     mov al, 201
     mov dl, 0
     mov dh, yMax
     sub dh, 3
     call GotoXY
     call WriteChar
     movzx ecx, xMax
     sub ecx, 2
     mov al, 205
L4:
     call WriteChar
     loop L4

     mov al, 187
     call WriteChar

     ;// ------------------Imprime a borda de baixo do status
     mov al, 200
     mov dl, 0
     mov dh, yMax
     call GotoXY
     call writeChar
     movzx ecx, xMax
     sub ecx, 2
     mov al, 205
L5:
     call WriteChar
     loop L5
          
     mov al, 188
     call WriteChar
     
     ;// ------------------ Imprime as laterais do status
     mov ecx, 2
     mov dh, yMax
     sub dh, 2
L6:
     mov dl, 0
     call GotoXY
     mov al, 186
     call WriteChar
     mov dl, xMax
     dec dl
     call GotoXY
     mov al, 186
     call WriteChar
     inc dh
     loop L6

     ;// ------- Reseta a cor e retorna
     mov eax, white + (black * 16)
     call SetTextColor
     ret
drawBordas ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: drawStatus
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Desenha o status do jogo (nível, vida, etc)
;//  PARÂMETROS: xMax - Quantidade de colunas totais do jogo
;//		       yMax - Quantidade de linhas totais do jogo
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
drawStatus PROC uses eax edx
     
     mov eax, white+(black*16)
     call SetTextColor

     mov ecx, 78
     mov dh, 23
     mov dl, 1
     call GotoXY
     mov al, VAZIOCHAR
L1:  
     call WriteChar
     loop L1


     ;// ---- LEVEL
     mov dh, 23     ;// move para a posição
     mov dl, 5
     call GotoXY
     mov edx, OFFSET strLevel
     call WriteString
     mov al, Level
     call WriteDec
     
     ;// ---- HEALTH
     mov dh, 23     ;// move para a posição
     mov dl, 25
     call GotoXY
     mov edx, OFFSET strHealth
     call WriteString
     mov ax, Health
     call WriteDec

     ;// ---- GOLD
     mov dh, 23     ;// move para a posição
     mov dl, 45
     call GotoXY
     mov edx, OFFSET strGold
     call WriteString
     mov ax, Gold
     call WriteDec

     call HideCursor
     ret
drawStatus ENDP


;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: PrintMapa
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Desenha o mapa do jogo
;//  PARÂMETROS: MAPCOLS - Quantidade de colunas no mapa 
;//				 MAPROWS - Quantidade de linhas no mapa
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
PrintMapa PROC USES ecx esi ebx eax edx
     
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
     cmp al, HEROICHAR
     je Hero
     cmp al, ESCADACHAR
     je Escada
     cmp al, BAUCHAR
     je Bau
	cmp al, MONSTROCHAR
     je Monstro
     push eax
     mov eax, black + (gray * 16);// Volta para a cor padrão
     call SETTEXTCOLOR
     pop eax
Default:
     call WriteChar ;// Desenha padrão (parede ou nada)
     inc ebx   
     loop L2   
     pop ecx
     loop L1
     jmp Fim

Hero:
     push eax                      ;// guarda 
     mov eax, white + (gray * 16)  ;// Seleciona o branco  
     call SETTEXTCOLOR
     pop eax
     jmp Default

Escada:
     push eax                      ;// guarda 
     mov eax, lightGreen + (gray * 16)  ;// Seleciona o verde  
     call SETTEXTCOLOR
     pop eax
     jmp Default

Bau:
     push eax                      ;// guarda 
     mov eax, yellow + (gray * 16)  ;// Seleciona o amarelo  
     call SETTEXTCOLOR
     pop eax
     jmp Default

Monstro:
     push eax                      ;// guarda 
     mov eax, red + (gray * 16)  ;// Seleciona o vermelho  
     call SETTEXTCOLOR
     pop eax
     jmp Default

Fim:    
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
ResetMapa PROC uses eax ecx esi
     mov ecx, 0
     mov esi, OFFSET Map
     mov al, PAREDECHAR
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
GeraMapa PROC USES eax ebx ecx edx esi
;// ------------------------- Reseta mapa e variáveis
     call ResetMapa
     mov emptyCells, 0
;// ------------------------- Randomiza a meta de células limpas - entre 620 e 950 (aprox. 40 a 60 % do mapa)
     mov eax, 451
     call RandomRange
     add eax, 500
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

     mov bl, VAZIOCHAR
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

     mov bl, VAZIOCHAR
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

     mov bl, VAZIOCHAR
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

     mov bl, VAZIOCHAR
     cmp [esi + eax], bl
     je NowriteW
     inc emptyCells
     mov [esi + eax], bl
NowriteW:  
     loop MWC
     jmp WL1



Fim:
     ;// -------- - Insere a Escada no mapa
     mov ax, pos
     mov posEscada, ax
     mov bl, ESCADACHAR
     mov [esi+eax], bl

     ;// -------- - Insere Personagem no mapa
     mov ax, posHeroi
     mov bl, HEROICHAR
     mov [esi + eax], bl

     call InsertBaus
	call InsertMonstros

     ret
GeraMapa ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: InsertBaus
;// -------------------------------------------------------------------------
;//	OBJETIVO: Insere os baús no mapa
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
InsertBaus PROC
     mov esi, OFFSET Map
     mov ecx, 2
     mov bl, VAZIOCHAR

random:
     mov eax, 1561
     call RandomRange
     mov dl, [esi+eax]
     cmp dl, bl
     jne random

addBau:
     mov dl, BAUCHAR
     mov [esi+eax], dl
     loop random

     ret
InsertBaus ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: InsertMonstros
;// -------------------------------------------------------------------------
;//	OBJETIVO: Insere os monstros no mapa
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
InsertMonstros PROC
     mov esi, OFFSET Map
     mov ecx, 5
     mov eax, 15
     call RandomRange
     add ecx, eax
     mov bl, VAZIOCHAR

random:
     mov bl, VAZIOCHAR
     mov eax, 1561
     call RandomRange
     mov dl, [esi+eax]
     cmp dl, bl
     jne random
     mov bl, BAUCHAR
     cmp dl, bl
     je random

addMonstro:
     mov dl, MONSTROCHAR
     mov [esi+eax], dl
     loop random

     ret
InsertMonstros ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: mainGame
;// -------------------------------------------------------------------------
;//	OBJETIVO: Loop do jogo
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
MainGame PROC uses ecx eax
     
InitAll:
     ;// Reseta variáveis
     mov Level, 1
	 mov ax, HealthConf
     mov Health, ax
     mov Gold, 0
	 mov Abates, 0
	 mov Movimentos, 0
	 mov BausCnt, 0
     mov isDead, 0

InitLevel:
     call LimpaTela;// Limpa a tela
     call drawBordas;// Desenha as bordas do jogo
     call ResetMapa;// Reseta o mapa
     call GeraMapa;// Gera um novo mapa

gameloop:
     call PrintMapa;// Desenha o mapa
     call drawStatus;// Escreve os status
     call PlayerMove

     cmp inStairs, 0 ;// Verifica se o o jogador se encontra na escada
     jne NextLevel
     cmp isDead, 0  ;// Verifica se o jogador esta morto
     jne EndDead
     
     call PrintMapa
     mov eax, 50
     call Delay
     call MoveMonstros
     
     jmp gameloop

NextLevel:
	 ;// Som de porta abrindo
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE6
	invoke PlaySound, offset auDoor, NULL, SND_FILENAME or SND_NODEFAULT
MUTE6:
	pop eax
     mov inStairs, 0 
     mov al, MAXLEVEL ;// Verifica se terminou o nível final
     cmp al, Level
     je EndGame
     inc Level
     jmp InitLevel

EndDead:
	 ;// Som de derrota
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE7
	invoke PlaySound, offset auEvil, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE7:
	pop eax
	 call LimpaTela
	 mov edx, OFFSET telaDerrota
	 call WriteString
	 jmp FillPlacar
EndGame:
	 ;// Som de vitória
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE8
	invoke PlaySound, offset auTada, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE8:
	pop eax
	 call LimpaTela
	 mov edx, OFFSET telaVitoria
	 call WriteString
FillPlacar:
	 mov eax, white+(black*16)
     call SetTextColor
	 mov dl, 43
	 ;// ---- NIVEL ALCANÇADO
     mov dh, 8     ;// move para a posição
     call GotoXY
     mov al, Level
     call WriteDec
	 ;// ---- GOLD RECEBIDO
     mov dh, 9     ;// move para a posição
     call GotoXY
     mov ax, Gold
     call WriteDec
	 ;// ---- MONSTROS ABATIDOS
     mov dh, 10     ;// move para a posição
     call GotoXY
     mov ax, Abates
     call WriteDec
	 ;// ---- MOVIMENTOS (PASSOS DADOS)
     mov dh, 11     ;// move para a posição
     call GotoXY
     mov ax, Movimentos
     call WriteDec
	 ;// ---- BAÚS ABERTOS
     mov dh, 12     ;// move para a posição
     call GotoXY
     mov ax, BausCnt
     call WriteDec
     ret
MainGame ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: MoveMonstros
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Move os monstros aleatoriamente
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
MoveMonstros PROC
     
     mov esi, OFFSET map
     mov ecx, 1559
     mov bl, MONSTROCHAR

Scan:
     cmp [esi+ecx], bl
     je Monstro
     loop Scan
     jmp Fim

Monstro: 
     call MonstroMoveCheck
     loop Scan

Fim:
     ret
MoveMonstros ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: MonstroMoveCheck
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Checagem de movimentação dos monstros
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------

MonstroMoveCheck PROC uses esi eax ebx
     
     mov PosMonstro, cx

Dir: 
     call Randomize
     mov eax, 4
     call RandomRange
     cmp eax, 0
     je MonUp
     cmp eax, 1
     je MonRight
     cmp eax, 2
     je MonDown
     cmp eax, 3
     je MonLeft

MonUp:
     movzx eax, PosMonstro
     cmp ax, 77
     jbe EndMov     ;// Tenta outra direção caso inválido

     ;// Checa se existe uma parede:
     sub eax, 78
     mov bl, PAREDECHAR
     cmp [esi + eax], bl
     je EndMov
     ;// Move caso válido
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovUp
     ;// Outras colisões
     jmp colisao

MonDown:
     mov ax, PosMonstro
     mov bx, 1482
     cmp ax, bx
     jbe EndMov     ;// Tenta outra direção caso inválido

     ;// Checa se existe uma parede:
     add eax, 78
     mov bl, PAREDECHAR
     cmp[esi + eax], bl
     je EndMov
     ;// Move caso válido
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovDown
     jmp colisao

MonLeft:
     mov ax, PosMonstro
     mov bl, 78
     div bl             ;// pos/78 - Resto fica em AH
     cmp ah, 0
     jbe EndMov;// Tenta outra direção caso inválido

     mov ax, posMonstro
     ;// Checa se existe uma parede:
     dec ax
     mov bl, PAREDECHAR
     cmp [esi+eax], bl
     je EndMov
     ;// Move caso válido
     mov bl, VAZIOCHAR
     cmp [esi + eax], bl
     je MovLeft
     jmp colisao

MonRight:
     mov ax, PosMonstro
     inc ax         ;// ax = pos+1
     mov bl, 78
     div bl         ;// (pos+1)/78 - Resto fica em AH
     cmp ah, 0      ;// se (pos+1)%78 = 0, então não é valido
     jbe EndMov     ;// Tenta outra direção caso inválido     

     mov ax, posMonstro
     ;// Checa se existe uma parede:
     inc ax
     mov bl, PAREDECHAR
     cmp[esi + eax], bl
     je EndMov
     ;// Move caso válido
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovRight
     jmp colisao

Colisao:
     ;// Colisão com escada
     mov bl, ESCADACHAR
     cmp[esi + eax], bl
     jmp EndMov
     ;// Colisão com bau
     mov bl, BAUCHAR
     cmp[esi + eax], bl
     jmp EndMov
	;// Colisão com o Heroi
     mov bl, HEROICHAR
     cmp[esi + eax], bl
     je colisaoHeroi
	;// Colisão com monstro
     mov bl, MONSTROCHAR
     cmp[esi + eax], bl
     jmp Dir   

MovUp:
     sub PosMonstro, 78
     mov ax, PosMonstro
     mov bl, VAZIOCHAR
     mov [esi + eax + 78], bl   ;// Limpa posição atual
     mov bl, MONSTROCHAR
     mov [esi + eax], bl ; // Adiciona o monstro na nova posição
     sub ecx, 78
     jmp EndMov

MovDown :
     add PosMonstro, 78
     mov ax, PosMonstro
     mov bl, VAZIOCHAR
     mov[esi + eax - 78], bl   ;// Limpa posição atual
     mov bl, MONSTROCHAR
     mov[esi + eax], bl ; // Adiciona o monstro na nova posição
     jmp EndMov

MovLeft :
     dec PosMonstro
     mov ax, PosMonstro
     mov bl, VAZIOCHAR
     mov[esi + eax + 1], bl;// Limpa posição atual
     mov bl, MONSTROCHAR
     mov[esi + eax], bl; // Adiciona o monstro na nova posição
     dec ecx
     jmp EndMov

MovRight :
     inc PosMonstro
     mov ax, PosMonstro
     mov bl, VAZIOCHAR
     mov[esi + eax - 1], bl;// Limpa posição atual
     mov bl, MONSTROCHAR
     mov[esi + eax], bl; // Adiciona o monstro na nova posição
     jmp EndMov

colisaoHeroi:
     movzx ebx, Level
     cmp Health, bx   ;// compara a vida atual com o dano (dano=level)
     jbe Fatal
	 ;// Som de ferimento
	push eax
	mov al, AudioConf
	cmp al, 1
	jne MUTE9
	invoke PlaySound, offset auHurt, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE9:
	pop eax
     sub Health, bx ;// dá dano caso não seja fatal
     jmp EndMov

fatal:
     mov Health, 0
     mov isDead, 1
     jmp EndMov


EndMov:
     ret
MonstroMoveCheck ENDP

;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: PlayerMove
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Lê a entrada do jogador e move o personagem
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
PlayerMove PROC uses eax esi edx ebx 
         
     mov esi, OFFSET Map    

KeyWait:
     mov eax, 50
     call Delay; // Sleep para timeslice
     call ReadKey
     jz KeyWait

     cmp  dx, 0026h
     je KeyUp
     cmp dx, 0025h
     je KeyLeft
     cmp dx, 0027h
     je KeyRight
     cmp dx, 0028h
     je KeyDown
     cmp dx, 0051h
     je Quit
     jmp KeyWait

KeyUp:
     mov ax, posHeroi
     cmp ax, 77
     jbe KeyWait      ;// Aguarda outra tecla caso inválido

     ;// Checa se existe uma parede:
     sub eax, 78
     mov bl, PAREDECHAR
     cmp [esi + eax], bl
     je KeyWait
     ;// Move caso válido
	 inc Movimentos
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovUp
     ;// Outras colisões
     jmp colisao

KeyDown:
     mov ax, posHeroi
     mov bx, 1482
     cmp ax, bx
     jae KeyWait;   // Aguarda outra tecla caso inválido

     ;// Checa se existe uma parede:
     add eax, 78
     mov bl, PAREDECHAR
     cmp[esi + eax], bl
     je KeyWait
     ;// Move caso válido
	 inc Movimentos
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovDown
     jmp colisao

KeyLeft:
     mov ax, PosHeroi
     mov bl, 78
     div bl             ;// pos/78 - Resto fica em AH
     cmp ah, 0
     je KeyWait         ;// se pos%78 = 0, então não é valido

     mov ax, posHeroi
     ;// Checa se existe uma parede:
     dec ax
     mov bl, PAREDECHAR
     cmp [esi+eax], bl
     je KeyWait
     ;// Move caso válido
	 inc Movimentos
     mov bl, VAZIOCHAR
     cmp [esi + eax], bl
     je MovLeft
     jmp colisao

KeyRight:
     mov ax, PosHeroi
     inc ax         ;// ax = pos+1
     mov bl, 78
     div bl         ;// (pos+1)/78 - Resto fica em AH
     cmp ah, 0
     je KeyWait     ;// se (pos+1)%78 = 0, então não é valido

     mov ax, posHeroi
     ;// Checa se existe uma parede:
     inc ax
     mov bl, PAREDECHAR
     cmp[esi + eax], bl
     je KeyWait
     ;// Move caso válido
	 inc Movimentos
     mov bl, VAZIOCHAR
     cmp[esi + eax], bl
     je MovRight
     jmp colisao

Colisao:
     ;// Colisão com escada
     mov bl, ESCADACHAR
     cmp[esi + eax], bl
     je colisaoEscada
     ;// Colisão com bau
     mov bl, BAUCHAR
     cmp[esi + eax], bl
     je colisaoBau
	;// Colisão com monstro
     mov bl, MONSTROCHAR
     cmp[esi + eax], bl
     je colisaoMonstro
	

MovUp:
     sub posHeroi, 78
     mov ax, posHeroi
     mov bl, VAZIOCHAR
     mov [esi + eax + 78], bl   ;// Limpa posição atual
     mov bl, HEROICHAR
     mov [esi + eax], bl ; // Adiciona o heroi na nova posição
     jmp EndInput

MovDown :
     add posHeroi, 78
     mov ax, posHeroi
     mov bl, VAZIOCHAR
     mov[esi + eax - 78], bl   ;// Limpa posição atual
     mov bl, HEROICHAR
     mov[esi + eax], bl ; // Adiciona o heroi na nova posição
     jmp EndInput

MovLeft :
     dec posHeroi
     mov ax, posHeroi
     mov bl, VAZIOCHAR
     mov[esi + eax + 1], bl;// Limpa posição atual
     mov bl, HEROICHAR
     mov[esi + eax], bl; // Adiciona o heroi na nova posição
     jmp EndInput

MovRight :
     inc posHeroi
     mov ax, posHeroi
     mov bl, VAZIOCHAR
     mov[esi + eax - 1], bl;// Limpa posição atual
     mov bl, HEROICHAR
     mov[esi + eax], bl; // Adiciona o heroi na nova posição
     jmp EndInput

colisaoEscada:
     mov inStairs, 1
     jmp EndInput

colisaoBau:
     mov bl, VAZIOCHAR
     mov [esi+eax], bl  ;// Limpa a posição do bau
	 inc BausCnt		;// Incrementa o contador de baús abertos
     mov eax, 2
     call RandomRange
     ;// Adiciona Ouro
     cmp eax, 0
     je addGold
     ;// Adiciona vida
     cmp eax, 1
     je addHealth

colisaoMonstro:
     movzx ebx, Level
     cmp Health, bx   ;// compara a vida atual com o dano (dano=level)
     jbe fatal
	 ;// Som de golpe
	 push eax
	 mov al, AudioConf
	 cmp al, 1
	 jne MUTE10
	 invoke PlaySound, offset auPunch, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE10:
	 pop eax
     sub Health, bx
     add Gold, bx
	 inc Abates
     mov bl, VAZIOCHAR
     mov [esi+eax], bl ;// Remove o monstro
     jmp EndInput
fatal:
     mov Health, 0
     mov isDead, 1
     jmp EndInput

addGold:
	 ;// Som de dinheiro
	mov al, AudioConf
	cmp al, 1
	jne MUTE11
	invoke PlaySound, offset auCoin, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE11:
     mov eax, 3          
     call RandomRange    
     inc eax             ;// gera um número aleatório entre 1 e 3
     mul Level           ;// multiplica pelo level e adiciona no ouro
     add Gold, ax
     jmp EndInput

addHealth:
	 ;// Som de poção
	mov al, AudioConf
	cmp al, 1
	jne MUTE12
	invoke PlaySound, offset auPotion, NULL, SND_FILENAME or SND_NODEFAULT or SND_ASYNC
MUTE12:
     mov al, Level
     call RandomRange              ;// gera um numero aleatorio entre 1 e o Level atual
     inc eax
     add eax, dword PTR Level      ;// adiciona o level atual e adiciona o resultado como vida
     add Health, ax
     jmp EndInput

Quit:
     mov isDead, 1
     jmp EndInput

EndInput:     
     ret
PlayerMove ENDP


;// -------------------------------------------------------------------------
;//  PROCEDIMENTO: main
;// -------------------------------------------------------------------------
;//	 OBJETIVO: Procedimento principal do jogo
;//  PARÂMETROS: Não Possui
;//  RETORNO: Não Possui
;// -------------------------------------------------------------------------
main PROC
     call Randomize;// Randomiza a seed
	invoke SetConsoleTitle, OFFSET ctitle	;// Muda o título do terminal
	call HideCursor							;// Esconde o cursor piscante
	mov cl, 0								;// Inicia o seletor do menu na primeira opção
	call ShowMenu							;// Mostra o menu principal

main ENDP
END main