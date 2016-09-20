Program FLAPPY_BIRD;
{--------------------------------------------------------
FLAPPY BIRD - versão 1.0
---------------------------------------------------------
/-------------------------------------------------------\
|INSTITUTO FEDERAL DA BAHIA - CAMPUS CAMAÇARI           |
|AUTORES: Mauricio Taffarel e Jonathan Xavier           |
|CURSO: Técnico em Eletrotécnica                        |
|DATA: 22/04/2016                                       |
|CONTATO: mauruciotaffarel@gmail.com                    |
|CONTATO: jonatthannxavierr@gmail.com                   |
\-------------------------------------------------------/
O game possui o objetivo de simular uma interface gráfica
de um jogo através de movimentos dos caracteres especiais
contidos na tabela ASCII para obteção de desenhos como os
canos, as bordas, o pássaro e os demais itens do mesmo.

O jogo foi criado para fins didáticos no Pascalzim, então
o código é livre para edição e sem licença, portanto pode
ser editado e melhorado. Por favor se houver qualquer bug
pode nos avisar em um dos contatos acima!

PS1: Devido a linearidade do código o pássaro descreve um
movimento constante em sua queda e deste modo complicando
a aplicação de efeito de aceleração da gravidade.

PS2: Jogo funciona com cores mais apresentáveis na versão
6.0.1 do Pascalzim, pois no jogo foi utilizado um comando
de cor de fundo do texto e a versão 6.0.2 ou superior não
permite o uso de cores claras como LIGHTGREEN, mas só irá
mudar a percepção das cores de alguns lugares.

--------------------------------------------------------}

//-------------------------------------------------------


Const TEMPO_CARREGAMENTO=10;

Type VETOR_POSICAO = array[1..4] of integer;
REGISTRO_PONTUACAO = record
  Nome : string[3];
  Placar : integer;
end;
ALFABETO = 'A'..'Z';
ARMAZENA_PONTOS = file of REGISTRO_PONTUACAO;



//----------------------------------------------------------------

{-----------------------------------------------------------------|
| DESENHO DA GRADE DE SELEÇÃO: Desenha a grade de seleção em sua  |
|                              respectiva posição ou a apaga na   |
|                              na posição anterior.               |
|-----------------------------------------------------------------}

Procedure GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy :integer; CRIAR_GRADE : boolean);
var i :integer;
Begin
  textbackground(blue);
  textcolor(white);
  // Quinas Laterais Esquerdas da Grade ---------------------------------------------
  gotoxy(POSICAOx_GRADE-1,POSICAOy_GRADE);
  if CRIAR_GRADE then write(#218) else write(' ');
  gotoxy(POSICAOx_GRADE-1,POSICAOy_GRADE+TAMy+2);
  if CRIAR_GRADE then write(#192) else write(' ');
  
  // Linhas da Grade ---------------------------------------------
  for i:=POSICAOx_GRADE to POSICAOx_GRADE+TAMx do
  begin
    gotoxy(i,POSICAOy_GRADE);
    if CRIAR_GRADE then write(#196) else write(' ');
    gotoxy(i,POSICAOy_GRADE+TAMy+2);
    if CRIAR_GRADE then write(#196) else write(' ');
  end;
  
  for i:=POSICAOy_GRADE to POSICAOy_GRADE+TAMy do
  begin
    gotoxy(POSICAOx_GRADE-1,i+1);
    if CRIAR_GRADE then write(#179) else write(' ');
    gotoxy(POSICAOx_GRADE+TAMx+1,i+1);
    if CRIAR_GRADE then write(#179) else write(' ');
  end;
  
  //Quinas Laterais Direitas da Grade ----------------------------------------------
  gotoxy(POSICAOx_GRADE+TAMx+1,POSICAOy_GRADE);
  if CRIAR_GRADE then write(#191) else write(' ');
  gotoxy(POSICAOx_GRADE+TAMx+1,POSICAOy_GRADE+TAMy+2);
  if CRIAR_GRADE then write(#217) else write(' ');
  
End;

{-----------------------------------------------------------------|
|DESENHA PASSARO: O procedimento desenha o pássaro sempre que for |
|                 necessario dentro do jogo                       |
|-----------------------------------------------------------------}

Procedure DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO : integer);
begin
  textcolor(yellow);
  gotoxy(POSICAO_PASSARO,ALTURA_PASSARO);   write(#219);
  gotoxy(POSICAO_PASSARO,ALTURA_PASSARO+1); write(#219);
  gotoxy(POSICAO_PASSARO,ALTURA_PASSARO+2); write(#219);
  
  textcolor(red);
  gotoxy(POSICAO_PASSARO+1,ALTURA_PASSARO+2); write(#219);
  textbackground(red); textcolor(lightred); write(#196);
  
  textcolor(white);
  gotoxy(POSICAO_PASSARO+1,ALTURA_PASSARO);   write(#219,#219);
  gotoxy(POSICAO_PASSARO+1,ALTURA_PASSARO+1); write(#219);
  textbackground(15); textcolor(black); write(#254);
end;
{-----------------------------------------------------------------|
|LIMPAR REGIÃO RETANGULAR DA TELA: Procedimento limpa uma área da |
|                                  tela com tamanho definido      |
|-----------------------------------------------------------------}
Procedure LIMPAR_TELA();
var i,j :integer;
Begin
  textbackground(blue);
  for i:=12 to 68 do
  begin
    for j:=11 to 25 do
    begin
      gotoxy(i,j); write(' ');
    end;
  end;
End;
{-----------------------------------------------------------------|
|DESENHO MENU INSTRUCOES: Procedimento que desenha o texto do menu|
|                         de instrucoes do jogo                   |
|-----------------------------------------------------------------}
Procedure MENU_INSTRUCOES();
Var i,j,POSICAOy_TEXTO :integer;
Tecla : char;
Begin
  LIMPAR_TELA();
  
  // Sombras da área de Instrução --------------------------------
  
  textcolor(black);
  for i:=18 to 63 do
  begin
    gotoxy(i,23);write(#219);
  end;
  
  for i:=13 to 23 do
  begin
    gotoxy(64,i); write(#219);
  end;
  
  // Área do texto da Instrunção ---------------------------------
  textbackground(10);
  for i:=17 to 63 do
  begin
    for j:=12 to 22 do
    begin
      gotoxy(i,j); write(' ');
    end;
  end;
  
  POSICAOy_TEXTO := 16;
  
  // Texto da Instrução ------------------------------------------
  textcolor(black);
  gotoxy(18,13);               write('          FLAPPY BIRD - Como Jogar           ');
  gotoxy(18,POSICAOy_TEXTO);   write(' O objetivo no jogo é ganhar o maior número  ');
  gotoxy(18,POSICAOy_TEXTO+1); write(' possível de pontos, controlando um pássaro  ');
  gotoxy(18,POSICAOy_TEXTO+2); write(' com a barra de espaço sem deixá-lo colidir  ');
  gotoxy(18,POSICAOy_TEXTO+3); write(' nos canos.                                  ');
  textcolor(5);
  gotoxy(18,21); write('   APERTE A TECLA ESC PARA VOLTAR AO MENU   ');
  textcolor(15); textbackground(blue);
  gotoxy(18,25); write('   By: MAURICIO TAFFAREL e JONATHAN XAVIER   ');
  
  Tecla := #32;
  while (Tecla <> #27)do
  begin
    if (keypressed) then
    Tecla := readkey;
  end;
  
End;
{-----------------------------------------------------------------|
|DESENHO DAS CAIXAS DE OPÇÕES: Desenha as caixas verdes que são os|
|                              botões dos sub menus.              |
|-----------------------------------------------------------------}
Procedure CAIXA_OPCAO(TAMx,TAMy :integer);
var i,j: integer;
Begin
  LIMPAR_TELA();
  
  // Botões do Menu ----------------------------------------------
  textbackground(blue);
  textcolor(yellow);
  for i:=25 to 38 do
  begin
    for j:=14 to 16 do
    begin
      gotoxy(i,j); textbackground(10); write(' ');
      gotoxy(i,j+5); textbackground(10); write(' ');
      gotoxy(i+18,j); textbackground(10); write(' ');
      gotoxy(i+18,j+5); textbackground(10); write(' ');
    end;
  end;
  
  // Texto dos Botões --------------------------------------------
  textcolor(black);
  gotoxy(29,15); write('Início');
  gotoxy(46,15); write('Recordes');
    gotoxy(27,20); write('Instruções');
    gotoxy(48,20); write('Sair');
    
    GRADE_SELECAO(25,13,TAMx,TAMy,True);
  End;
  
  {-----------------------------------------------------------------|
  |DESENHO DO MENU PRINCIPAL: Procedimento desenha todos os itens do|
  |                           menu principal,título, canos e pássaro|
  |-----------------------------------------------------------------}
  
  Procedure MENU_PRINCIPAL ();
  var i,j,POSICAOx_TITULO,POSICAOy_TITULO,
  ALTURA_PASSARO,POSICAO_PASSARO :integer;
  Begin
    
    // Titulo do jogo -----------------------------------------------
    POSICAOx_TITULO:=9;
    POSICAOy_TITULO:=3;
    textbackground(blue); clrscr;
    textcolor(15);
    gotoxy(POSICAOx_TITULO,POSICAOy_TITULO);  write('  _____ _        _    ____  ______   __  ____ ___ ____  ____  ');
    gotoxy(POSICAOx_TITULO,POSICAOy_TITULO+1);write(' |  ___| |      / \  |  _ \|  _ \ \ / / | __ )_ _|  _ \|  _ \ ');
    gotoxy(POSICAOx_TITULO,POSICAOy_TITULO+2);write(' | |_  | |     / _ \ | |_) | |_) \ V /  |  _ \| || |_) | | | |');
    gotoxy(POSICAOx_TITULO,POSICAOy_TITULO+3);write(' |  _| | |___ / ___ \|  __/|  __/ | |   | |_) | ||  _ <| |_| |');
    gotoxy(POSICAOx_TITULO,POSICAOy_TITULO+4);write(' |_|   |_____/_/   \_\_|   |_|    |_|   |____/___|_| \_\____/ ');
    
    // Bordas do Título ---------------------------------------------
    textcolor(10);
    for i:=1 to 80 do
    begin
      gotoxy(i,1); write(#219);
      gotoxy(i,10); write(#219);
    end;
    for i:=2 to 9 do
    begin
      gotoxy(1,i); write(#219);
      gotoxy(80,i); write(#219);
    end;
    
    // Quinas da esquerda dos canos---------------------------------
    gotoxy(4,17);write(#219);
    gotoxy(70,17);write(#219);
    
    // Canos -------------------------------------------------------
    for i:=5 to 9 do
    begin
      for j:=17 to 25 do
      begin
        gotoxy(i,j); write(#219);
        gotoxy(i+66,j); write(#219);
      end;
    end;
    
    // Quinas da direita dos canos----------------------------------
    gotoxy(10,17); write(#219);
    gotoxy(76,17); write(#219);
    
    // Pássaros do menu --------------------------------------------
    ALTURA_PASSARO:=12;
    POSICAO_PASSARO:=6;
    
    for i:=1 to 2 do
    begin
      DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO);
      POSICAO_PASSARO:=72;
    end;
    
  end;
  
  {-----------------------------------------------------------------|
  |DESENHO DO MENU RECORDES:  Procedimento desenha todos os itens do|
    |                           menu de recordes e abre o arquivo para|
      |                           ler os recordes.                      |
        |-----------------------------------------------------------------}
        
        Procedure MENU_RECORDES();
          var i,j,POSICAOy_TEXTO : integer;
          DADOS_RECODES : array[1..7] of REGISTRO_PONTUACAO;
          ARQUIVO_RECORD : ARMAZENA_PONTOS;
            Tecla : char;
            Begin
              
              textcolor(black);
              textbackground(16);
              for i:=24 to 58 do
              begin
                gotoxy(i,23);write(#219); // Sombra horizontal inferior //
              end;
              
              for i:=13 to 23 do
              begin
                gotoxy(59,i); write(#219); // Sombra vertical direita //
              end;
              
              
              textbackground(10);
              for i:=23 to 58 do
              begin
                for j:=12 to 22 do
                begin
                  gotoxy(i,j); write(' '); // Área do texto //
                end;
              end;
              
              assign(ARQUIVO_RECORD, 'LogScore.bin');
                reset(ARQUIVO_RECORD);
                  if ( ioresult <> 0 )then rewrite(ARQUIVO_RECORD);  // Abre ou cria o arquivo para leitura //
                    
                    for i := 1 to 7 do
                    begin
                      read(ARQUIVO_RECORD, DADOS_RECODES[i]);
                        if (DADOS_RECODES[i].Nome = '')then DADOS_RECODES[i].Nome := '---';
                      end;
                      
                      close(ARQUIVO_RECORD);
                        
                        textcolor(black);
                        gotoxy(37,13); write('RECORDES');
                          
                          POSICAOy_TEXTO := 15;
                          textcolor(16); textbackground(10);  // Escreve na tela os recordes salvos //
                            for i := 1 to 7 do
                            begin
                              gotoxy(26,POSICAOy_TEXTO+i-1);   write(i,'§ ',upcase(DADOS_RECODES[i].Nome));
                                gotoxy(32,POSICAOy_TEXTO+i-1); write(' ------------------:',DADOS_RECODES[i].Placar:3);
                              end;
                              
                              
                              textcolor(15);  textbackground(blue);
                              gotoxy(20,25); write('   APERTE A TECLA ESC PARA VOLTAR AO MENU   ');
                              
                              Tecla := #32;
                              while (Tecla <> #27)do
                              begin
                                if (keypressed) then    // Condição para voltar ao menu principal //
                                Tecla := readkey;
                              end;
                            End;
                            
                            {------------------------------------------------------------------|
                            | Escrita do nome:  Procedimento responsável por simular a escrita |
                            |                   do nome do jogador que bate um recorde         |
                            |------------------------------------------------------------------}
                            Procedure ESCRITA_NOME(var NOME : string[3]);
                            var LETRAS_NOME : array[1..3] of char;
                            i,j,l : integer;
                            LETRA : ALFABETO;
                            TECLA : char;
                            begin
                              cursoron;  gotoxy(42,16);
                              j := 1;
                              l := 1;
                              LETRAS_NOME[1]:= ' ';
                              LETRAS_NOME[2]:= ' ';
                              LETRAS_NOME[3]:= ' ';
                              while true do   // Escrita de apenas três caracteres na tela //
                              begin
                                textbackground(black); textcolor(white); gotoxy(41+j,16);
                                TECLA := readkey;
                                
                                for LETRA := 'A' to 'Z' do
                                begin
                                  if upcase(TECLA) = LETRA then
                                    begin
                                      l := 1;
                                      LETRAS_NOME[j] := TECLA; write(upcase(TECLA));
                                        
                                        if (j < 3)then
                                        begin
                                          j := j + 1;
                                        end;
                                      end;
                                    end;
                                    
                                    if TECLA = #0 then
                                    begin
                                      TECLA := readkey;
                                      if TECLA = #75 then
                                      begin
                                        if (j > 1) and (j <= 3) then
                                        begin
                                          l := 1;
                                          j := j - 1;
                                        end;
                                      end
                                      else  if TECLA = #77 then
                                      begin
                                        if (j >= 1) and (j < 3) then
                                        begin
                                          l := 1;
                                          j := j + 1;
                                        end;
                                      end;
                                    end
                                    else if TECLA = #8 then
                                    begin
                                      if l < 3 then
                                      l := l + 1;
                                      if (j > 1) and (j <= 3) then
                                      begin
                                        if((l = 3)or(LETRAS_NOME[j] = ' '))then
                                        begin
                                          j := j - 1;
                                          gotoxy(41+j,16);
                                        end;
                                      end;
                                      LETRAS_NOME[j] := ' ';write(' ');
                                      
                                    end
                                    else if TECLA = #13 then
                                    begin
                                      if ((LETRAS_NOME[1] <> ' ')and(LETRAS_NOME[2] <> ' ')and(LETRAS_NOME[3] <> ' '))then
                                      begin
                                        break;
                                      end
                                      else
                                      begin
                                        gotoxy(30,25);textbackground(brown);
                                        textcolor(black);write('Digite apenas letras!');
                                      end;
                                    end;
                                    
                                  end;
                                  
                                  
                                  NOME := LETRAS_NOME[1] + LETRAS_NOME[2] + LETRAS_NOME[3];
                                  cursoroff;
                                end;
                                
                                {-----------------------------------------------------------------|
                                | Quadro da pontuação:  Função responsável por desenhar o quadro  |
                                |                       da pontuação do jogo                      |
                                |-----------------------------------------------------------------}
                                Function QUADRO_PONTUACAO(PONTUACAO :integer): boolean;
                                var i,j,X,POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy:integer;
                                PONTOS : array[1..7] of REGISTRO_PONTUACAO;
                                AUX : array[1..2] of REGISTRO_PONTUACAO;
                                RECORDE : ARMAZENA_PONTOS;
                                  Flag : boolean;
                                  TECLA : char;
                                  Begin
                                    POSICAOx_GRADE:=30;
                                    POSICAOy_GRADE:=19;
                                    TAMx:=9;
                                    TAMy:=2;
                                    X := 1;
                                    
                                    textcolor(brown);
                                    // Quinas laterais esquerdas do quadro //
                                    gotoxy(30,7); write(#201);
                                    gotoxy(30,18); write(#200);
                                    
                                    // Bordas horizontais //
                                    for i:=31 to 49 do
                                    begin
                                      gotoxy(i,7);write(#205);
                                      gotoxy(i,18);	write(#205);
                                    end;
                                    
                                    // Bordas verticais //
                                    for i:=8 to 17 do
                                    begin
                                      gotoxy(30,i);	write(#186);
                                      gotoxy(50,i); write(#186);
                                    end;
                                    
                                    // Quinas laterais direitas do quadro //
                                    gotoxy(50,7); write(#187);
                                    gotoxy(50,18); write(#188);
                                    
                                    textbackground(7);
                                    for j:=8 to 17 do
                                    begin
                                      for i:=31 to 49 do
                                      begin
                                        gotoxy(i,j);write(' '); // Área do texto //
                                      end;
                                    end;
                                    
                                    textbackground(blue);
                                    // Quinas esquerdas dos Botões inferiores //
                                    gotoxy(30,20);write(#201);  gotoxy(30,22);write(#200);
                                    gotoxy(41,20);write(#201);  gotoxy(41,22);write(#200);
                                    
                                    // Botões inferiores //
                                    for i:=31 to 38 do
                                    begin
                                      gotoxy(i,20);	   write(#205); gotoxy(i,22);    write(#205);
                                      gotoxy(i+11,20); write(#205); gotoxy(i+11,22); write(#205);
                                    end;
                                    
                                    // Quinas direitas e bordas dos Botões inferioes//
                                    gotoxy(39,20);write(#187); gotoxy(30,21);write(#186);
                                    gotoxy(39,21);write(#186); gotoxy(50,20);write(#187);
                                    gotoxy(50,22);write(#188); gotoxy(41,21);write(#186);
                                    gotoxy(50,21);write(#186); gotoxy(39,22);write(#188);
                                    textcolor(15);
                                    gotoxy(31,21); write(' REPLAY ');
                                    gotoxy(42,21); write(' VOLTAR ');
                                    
                                    // Texto do quadro //
                                    textcolor(green); textbackground(7);
                                    gotoxy(36,9); write('GAME OVER');
                                    gotoxy(32,12); write('PONTUAÇAO: ');
                                    textcolor(red);write(PONTUACAO);
                                    
                                    
                                    assign(RECORDE,'LogScore.bin');
                                      reset(RECORDE);
                                        if (ioresult <> 0 ) then rewrite(RECORDE); // Abre ou cria o arquivo para leitura //
                                          for i := 1 to 7 do
                                          begin
                                            read(RECORDE,PONTOS[i]);
                                            end;
                                            
                                            close(RECORDE);
                                              
                                              for i:= 1 to 7 do
                                              begin
                                                if (PONTUACAO > PONTOS[i].Placar)then   // Verifica se o jogador superou um recorde //
                                                  begin
                                                    textcolor(green); gotoxy(34,14); write('NOVO RECORDE!');
                                                      textcolor(blue); gotoxy(36,16); write('Nome: ');
                                                      textbackground(black); write('   ');
                                                      textbackground(7);
                                                      
                                                      AUX[1].Placar := PONTOS[i].Placar;
                                                      AUX[1].Nome := PONTOS[i].Nome;
                                                      PONTOS[i].Placar := PONTUACAO;
                                                      
                                                      ESCRITA_NOME(PONTOS[i].Nome);
                                                      
                                                      if (i < 7)then  // Salva o novo recorde em determinada posição do registro //
                                                        begin
                                                          for j := i+1 to 7 do
                                                          begin
                                                            AUX[2].Placar := PONTOS[j].Placar;
                                                            AUX[2].Nome := PONTOS[j].Nome;
                                                            PONTOS[j].Placar := AUX[1].Placar;
                                                            PONTOS[j].Nome :=  AUX[1].Nome;
                                                            AUX[1].Placar :=  AUX[2].Placar;
                                                            AUX[1].Nome :=  AUX[2].Nome;
                                                          end;
                                                        end;
                                                        FLAG := true;
                                                      end;
                                                      if (FLAG) then break;
                                                    end;
                                                    
                                                    
                                                    rewrite(RECORDE);  // Salva o registro com o novo recorde no arquivo //
                                                      for i:= 1 to 7 do
                                                      begin
                                                        write(RECORDE,PONTOS[i]);
                                                        end;
                                                        close(RECORDE);
                                                          
                                                          // Opção para voltar ao menu ou reiniciar jogo //
                                                          GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);
                                                          while(true) do
                                                          begin
                                                            TECLA:=readkey;
                                                            
                                                            if TECLA = #0 then
                                                            begin
                                                              TECLA := readkey;
                                                              if (TECLA = #77)then
                                                              begin
                                                                if (X<2) then
                                                                begin
                                                                  GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);// Apaga a grade //
                                                                  POSICAOx_GRADE:=POSICAOx_GRADE+11;    // Atribui o valor //
                                                                  GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade //
                                                                  X := X+1;                                            // Atribui nova posicao //
                                                                end;
                                                              end
                                                              else if(TECLA = #75)then
                                                              begin
                                                                if (X>1) then
                                                                begin
                                                                  GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);
                                                                  POSICAOx_GRADE:=POSICAOx_GRADE-11;
                                                                  GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);
                                                                  X := X-1;
                                                                end;
                                                              end;
                                                            end;
                                                            
                                                            if(TECLA = #13)then break;
                                                            
                                                            
                                                          end;
                                                          
                                                          if (X = 2)then QUADRO_PONTUACAO := true;
                                                          
                                                          
                                                        End;
                                                        
                                                        {------------------------------------------------------------------|
                                                        | Desenho de canos: A cada interação os canos serão desenhados por |
                                                      |                   esta função, recebendo assim sua abertura      |
                                                      |										aleatória a cada novo "nascimento"             |
                                                      |------------------------------------------------------------------}
                                                      
                                                      Procedure DESENHA_CANOS(var POSICAO, ALTURA_ALEATORIA :VETOR_POSICAO; cont:integer);
                                                      var i,j,l :integer;
                                                      k,t :VETOR_POSICAO; // Altura aleatória //
                                                      
                                                      begin
                                                        
                                                        k[cont]:=ALTURA_ALEATORIA[cont];
                                                        
                                                        
                                                        if(POSICAO[cont]>=2)then
                                                        begin // Quinas laterais esquerdas do cano //
                                                          textbackground(10); gotoxy(POSICAO[cont]-1,ALTURA_ALEATORIA[cont]-1); write(' ');
                                                          textcolor(black); gotoxy(POSICAO[cont]-1,ALTURA_ALEATORIA[cont]+9); write('_');
                                                        end;
                                                        
                                                        if ( POSICAO[cont] >= 76) then    // Define a largura inicial para causar o efeito de saída do cano //
                                                        begin                             // na lateral direita.                                            //
                                                          t[cont] := 80 - POSICAO[cont];
                                                        end
                                                        else
                                                        begin
                                                          t[cont] := 4;
                                                        end;
                                                        
                                                        for i := POSICAO[cont] to (POSICAO[cont] + t[cont]) do  // Desenha os canos com uma abertura de altura aleatória //
                                                        begin
                                                          
                                                          for j:=2 to 24 do
                                                          begin
                                                            
                                                            if ((j<k[cont]) or (j>= k[cont] + 9 )) then
                                                            begin
                                                              textbackground(10);
                                                              //-----------
                                                              if (j=(k[cont]-2)) or (j=(k[cont]+9))  then
                                                              begin
                                                                
                                                              if ((POSICAO[cont] <= 1) and(POSICAO[cont] >= -4)) then 
                                                            begin                                                               
                                                              for l := 1 to POSICAO[cont] + 4 do
                                                              begin
                                                                gotoxy(l,j); write('_');   // Desenha o topo dos canos com o efeito de saída da tela//
                                                              end;
                                                              
                                                            end
                                                            else
                                                            begin
                                                              gotoxy(i,j); write('_');           // Desenha o topo dos canos //
                                                            end;                                 
                                                            
                                                            
                                                          end
                                                          else
                                                          begin
                                                            
                                                          if (POSICAO[cont] <= 1) then               
                                                        begin                                   
                                                          for l := 1 to POSICAO[cont] + 4 do
                                                          begin
                                                            textbackground(10); gotoxy(l,j); write(' ');    // Desenha os canos em linhas verticais dependendo da posição //
                                                          end;                                             // no inicio da tela, gerando o efeito de saída.               //
                                                        end
                                                        else
                                                        begin
                                                          textbackground(10); gotoxy(i,j); write(' '); // Desenha o corpo dos canos em linhas verticais dependendo da //
                                                        end;                                           // posição apartir do final da tela mantendo a abetura.        //
                                                        
                                                      end;
                                                    end;
                                                    
                                                    
                                                    //-----------------------------------------
                                                    
                                                    if ((j<k[cont]-1) or (j>k[cont]+9)) then // Sombras do cano //
                                                    begin
                                                      if (i = 75)then
                                                      begin
                                                        textbackground(blue); textcolor(black);
                                                        gotoxy(POSICAO[cont]+5,j);  write(#219);
                                                      end
                                                      else if (i < 75)then
                                                      begin
                                                        textbackground(blue); textcolor(black);
                                                        gotoxy(POSICAO[cont]+5,j);  write(#219,' ');
                                                      end;
                                                    end;
                                                    
                                                  end;
                                                end;
                                                
                                                //--------------------------------------------------------------------
                                                
                                                
                                                if (POSICAO[cont] <= 75) then // Quinas laterais direitas do cano //
                                                begin
                                                  textbackground(10); gotoxy(POSICAO[cont]+5,k[cont]-1); write(' ');
                                                  textcolor(black); gotoxy(POSICAO[cont]+5,k[cont]+9); write('_');
                                                end;
                                                
                                                if (POSICAO[cont] <= 74) then
                                                begin
                                                  textbackground(blue);
                                                  
                                                  // Sombras das quinas do cano ---------------------------------------------
                                                  gotoxy(POSICAO[cont]+6,k[cont]-1); write(#223,' ');
                                                  gotoxy(POSICAO[cont]+6,k[cont]-2); write(#220,' ');
                                                  
                                                  gotoxy(POSICAO[cont]+6,k[cont]+9); write(#220,' ');
                                                  gotoxy(POSICAO[cont]+6,k[cont]+10); write(#223,' ');
                                                  if POSICAO[cont] = 74 then
                                                  begin
                                                    gotoxy(1,25); textbackground(6); write(' ');
                                                  end;
                                                end;
                                                
                                                textbackground(blue);
                                                // Limpa os canos na posição do início da tela ------------------------------
                                                if POSICAO[cont]=-4 then
                                                begin
                                                  for i:=1 to 2 do
                                                  begin
                                                    for j:=2 to 24 do
                                                    begin
                                                      gotoxy(i,j); write(' ');
                                                    end;
                                                  end;
                                                end;
                                              End;
                                              
                                              {-----------------------------------------------------------------|
                                              | BATIDA DO PASSARO:  Função que retorna se o passaro bateu ou não|
                                              |                     e define a pontuação.                       |
                                              |-----------------------------------------------------------------}
                                              
                                                function BATIDA_PONTUACAO(POSICAO, ALTURA_ALEATORIA:VETOR_POSICAO; var ALTURA_PASSARO,POSICAO_PASSARO :integer) :boolean;
                                              var i :integer;
                                              Begin
                                                if ((ALTURA_PASSARO<3) or (ALTURA_PASSARO=23)) then BATIDA_PONTUACAO:=true; // Verifica se o pássaro bateu no teto ou no chão //
                                                for i:=1 to 4 do
                                                begin
                                                  if (((POSICAO[i]>=4) and (POSICAO[i]<=12)) and ((ALTURA_PASSARO<=ALTURA_ALEATORIA[i]) or (ALTURA_PASSARO>=ALTURA_ALEATORIA[i]+7))) then BATIDA_PONTUACAO:=true; // Verifica se o pássaro bateu na parte interna do cano //
                                                  if POSICAO[i]=13 then  // Verifica se o pássaro bateu na lateral externa do cano //
                                                  begin
                                                    if ((ALTURA_PASSARO>=ALTURA_ALEATORIA[i]-3) and (ALTURA_PASSARO<=ALTURA_ALEATORIA[i]-1)) or ((ALTURA_PASSARO>=ALTURA_ALEATORIA[i]+7) and (ALTURA_PASSARO<=ALTURA_ALEATORIA[i]+9)) then BATIDA_PONTUACAO:=true;
                                                  end;
                                                end;
                                              End;
                                              
                                              {-----------------------------------------------------------------|
                                              | ANIMAÇÃO DESAFIO : EM BREVE TEREMOS UM DESAFIO EXTRA VERSÃO 2.0 |
                                              |                                                                 |
                                              |                                                                 |
                                              |-----------------------------------------------------------------}
                                              Procedure ANIMACAO_DESAFIO();
                                              Begin
                                              End;
                                              
                                              {-----------------------------------------------------------------|
                                              | MOVIMENTO DO JOGO: Função onde está todo o funcionamento do jogo|
                                              |                    como o pulo, queda do pássaro e movimento dos|
                                              |                    canos.                                       |
                                              |-----------------------------------------------------------------}
                                                Procedure MOVIMENTO_JOGO(TEMPO:integer);
                                              
                                              var i,j,cont,contador,PONTUACAO,POSICAO_MINIMA,NUMERO_CANO,
                                              ALTURA_PASSARO,POSICAO_PASSARO : integer;
                                              POSICAO,ALTURA_ALEATORIA :VETOR_POSICAO;
                                              q,w,e,r,p,BATEU_CANO :boolean;
                                              TECLA :char;
                                              Begin
                                                
                                                while true do
                                                
                                                begin
                                                  
                                                  cont:=1;
                                                  PONTUACAO:=0; 
                                                  contador:=1; // Contador das iterações
                                                  NUMERO_CANO:=1;
                                                  q:=false;
                                                  w:=false;
                                                  e:=false;
                                                  BATEU_CANO := False;
                                                  POSICAO[2]:=0;
                                                  POSICAO[3]:=0;
                                                  POSICAO[4]:=0;
                                                  
                                                  textbackground(blue);
                                                  clrscr;
                                                  
                                                  // Desenho do chão --------------------------------------
                                                  for i:=1 to 80 do
                                                  begin
                                                    textbackground(brown);
                                                    gotoxy(i,25); write(' ');
                                                    if i>=15 then
                                                    begin
                                                      textcolor(lightgreen);
                                                      gotoxy(i,1); write(#219);
                                                    end;
                                                  end;
                                                  gotoxy(1,1);
                                                  
                                                  // Desenho inicial do pássaro -----------------------------------
                                                  POSICAO_PASSARO:=10;
                                                  ALTURA_PASSARO:=12;
                                                  
                                                  DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO);
                                                  
                                                  // Verificação da Barra de Espaço------------------------
                                                  
                                                  textbackground(brown);
                                                  
                                                  gotoxy(32,25); write('PRESSIONE ESPACO');
                                                  
                                                  while true do
                                                  begin
                                                    if readkey = ' ' then
                                                    begin
                                                      gotoxy(32,25); write('                ');
                                                      break;
                                                    end
                                                    
                                                    else if readkey <> ' ' then
                                                    begin
                                                      for i:=1 to 2 do
                                                      begin
                                                        textcolor(yellow);
                                                        gotoxy(32,25); write('PRESSIONE ESPACO');
                                                        delay(120);
                                                        textcolor(black);
                                                        gotoxy(32,25); write('PRESSIONE ESPACO');
                                                        delay(120);
                                                      end;
                                                    end;
                                                    
                                                  end;
                                                  
                                                  // Início da iteração do jogo ---------------------------
                                                  
                                                  
                                                  repeat
                                                    
                                                    // Pintando borda de cima inicialmente
                                                    if cont<15 then
                                                    begin
                                                      textbackground(10); gotoxy(15-cont,1); write(' '); // Fechamento do buraco de "entrada" //
                                                    end
                                                    else if cont=16 then
                                                    begin
                                                      for i:=1 to 80 do
                                                      begin
                                                        textcolor(10);
                                                        gotoxy(i,1); write(#219);
                                                      end;
                                                    end;
                                                    
                                                    textcolor(blue); textbackground(blue);
                                                    
                                                    if keypressed then
                                                    begin
                                                      TECLA := readkey;
                                                    end;
                                                    
                                                    if(TECLA = ' ') then  // PULO //
                                                    begin
                                                      
                                                      
                                                      
                                                      if not BATEU_CANO then  // Verifica se o pássaro está numa posição permitida para que seja  //
                                                      begin                   // desenhado, pois isto é realizado antes da verificação da batida. //
                                                        for j:=1 to 4 do
                                                        begin
                                                          if ((POSICAO[j]<=11) and (POSICAO[j]>=6)) then
                                                          begin
                                                            p:=true;
                                                            NUMERO_CANO:=j;
                                                          end;
                                                        end;
                                                        
                                                        if ((ALTURA_PASSARO-ALTURA_ALEATORIA[NUMERO_CANO]<=2)and p) then
                                                        begin
                                                          BATEU_CANO:=true;
                                                          ALTURA_PASSARO:=ALTURA_ALEATORIA[NUMERO_CANO];
                                                          
                                                        end
                                                        else
                                                        begin
                                                          ALTURA_PASSARO:=ALTURA_PASSARO-3;
                                                          if (ALTURA_PASSARO<=2) then ALTURA_PASSARO:=2;
                                                        end;
                                                        
                                                        DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO);
                                                        for i := 1 to 3 do
                                                        begin
                                                          gotoxy(POSICAO_PASSARO,ALTURA_PASSARO+i+2 );  textbackground(blue); write('   ');
                                                        end;
                                                        
                                                        
                                                      end
                                                      
                                                      
                                                      
                                                      else
                                                      begin
                                                        for i:=1 to 4 do  // Evita que o cano seja desenhado por cima do pássaro //
                                                        begin
                                                          POSICAO_MINIMA:=ALTURA_ALEATORIA[i];
                                                          if POSICAO[i]<=POSICAO_MINIMA then
                                                          begin
                                                            ALTURA_PASSARO:=ALTURA_ALEATORIA[i];
                                                            
                                                          end;
                                                        end;
                                                        DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO);
                                                        for i := 1 to 3 do
                                                        begin
                                                          gotoxy(POSICAO_PASSARO,ALTURA_PASSARO+i+2 );  textbackground(blue); write('   ');
                                                        end;
                                                      end;
                                                    end
                                                    
                                                    else  // GRAVIDADE
                                                    
                                                    begin
                                                      gotoxy(POSICAO_PASSARO,ALTURA_PASSARO-1); write('   ');
                                                      DESENHA_PASSARO(ALTURA_PASSARO,POSICAO_PASSARO);
                                                      ALTURA_PASSARO:=ALTURA_PASSARO+1;
                                                    end;
                                                    
                                                    // ----------------------------------------------------------
                                                    
                                                    
                                                    
                                                    // Desenho dos canos do jogo --------------------------------
                                                    
                                                    
                                                    // Primeiro cano
                                                    if ((POSICAO[4]=56) or (cont=1)) then
                                                    begin
                                                      POSICAO[1] := 80;
                                                      r:=true;
                                                    end;
                                                    
                                                    if ((POSICAO[1]=-5){or (PONTUACAO=98) //Teste para versão 2.0}  ) then r := false;
                                                    
                                                    if r then
                                                    begin
                                                      contador:=1;
                                                      if POSICAO[contador]=80 then
                                                      begin
                                                        ALTURA_ALEATORIA[contador]:=random(11)+4;
                                                      end;
                                                      
                                                      DESENHA_CANOS(POSICAO,ALTURA_ALEATORIA,contador);
                                                      POSICAO[contador]:=POSICAO[contador]-1;
                                                    end;
                                                    
                                                    
                                                    // Segundo cano
                                                    if (POSICAO[1]=56) then
                                                    begin
                                                      POSICAO[2]:=80;
                                                      e:=true;
                                                    end;
                                                    if (POSICAO[2]=-5) then e:=false;
                                                    if e then
                                                    begin
                                                      contador:=2;
                                                      if POSICAO[contador]=80 then
                                                      begin
                                                        ALTURA_ALEATORIA[contador]:=random(11)+4;
                                                      end;
                                                      
                                                      DESENHA_CANOS(POSICAO,ALTURA_ALEATORIA,contador);
                                                      POSICAO[contador]:=POSICAO[contador]-1;
                                                    end;
                                                    
                                                    
                                                    // Terceiro cano
                                                    if (POSICAO[2]=56) then
                                                    begin
                                                      POSICAO[3]:=80;
                                                      w:=true;
                                                    end;
                                                    if (POSICAO[3]=-5) then w:=false;
                                                    if w then
                                                    begin
                                                      contador:=3;
                                                      if POSICAO[contador]=80 then
                                                      begin
                                                        ALTURA_ALEATORIA[contador]:=random(11)+4;
                                                      end;
                                                      
                                                      DESENHA_CANOS(POSICAO,ALTURA_ALEATORIA,contador);
                                                      POSICAO[contador]:=POSICAO[contador]-1;
                                                    end;
                                                    
                                                    // Quarto cano
                                                    if (POSICAO[3]=56) then
                                                    begin
                                                      POSICAO[4]:=80;
                                                      q:=true;
                                                    end;
                                                    if (POSICAO[4]=-5) then q:=false;
                                                    
                                                    if q then
                                                    begin
                                                      contador:=4;
                                                      if POSICAO[contador]=80 then
                                                      begin
                                                        ALTURA_ALEATORIA[contador]:=random(11)+4;
                                                      end;
                                                      DESENHA_CANOS(POSICAO,ALTURA_ALEATORIA,contador);
                                                      POSICAO[contador]:=POSICAO[contador]-1;
                                                    end;
                                                    
                                                    if PONTUACAO=100 then ANIMACAO_DESAFIO();
                                                    
                                                    TECLA := 'm';
                                                    delay(TEMPO);
                                                    inc(cont);
                                                    p:=false;
                                                    
                                                    for i:=1 to 4 do
                                                    begin
                                                      if POSICAO[i]=10 then
                                                      begin
                                                        textbackground(brown); textcolor(yellow );
                                                        PONTUACAO:=PONTUACAO+1;
                                                        gotoxy(33,25); write('PONTUAÇÃO: ',PONTUACAO); write(#7);
                                                      end;
                                                    end;
                                                    
                                                  until (BATIDA_PONTUACAO(POSICAO, ALTURA_ALEATORIA,ALTURA_PASSARO,POSICAO_PASSARO));
                                                  
                                                  textbackground(blue);
                                                  if( QUADRO_PONTUACAO(PONTUACAO)) then break;
                                                end;
                                              End;
                                              
                                              
                                              
                                              {-----------------------------------------------------------------|
                                              | Iniciar Jogo: Desenha uma barra de progresso para uma ilustração|
                                              |               que carregamento                                  |
                                              |-----------------------------------------------------------------}
                                              
                                              procedure INICIAR_JOGO();
                                              var i,j, POSICAOx_GRADE, POSICAOy_GRADE,y,TEMPO,TAMx,TAMy :integer;
                                              TECLA :char;
                                              begin
                                                
                                                LIMPAR_TELA();
                                                
                                                // DIFICULDADE -------------------------------------------------
                                                textcolor(15);
                                                gotoxy(30,14); write('SELECIONE A DIFICULADE');
                                                gotoxy(37,17); write(' FÁCIL ');
                                                gotoxy(37,19); write(' MÉDIO ');
                                                gotoxy(37,21); write('DIFÍCIL');
                                                
                                                POSICAOx_GRADE:=37;
                                                POSICAOy_GRADE:=16;
                                                y:=1; 
                                                TAMx:=6;
                                                TAMy:=0;
                                                GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);
                                                
                                                while(true) do
                                                begin
                                                  TECLA:=readkey;
                                                  case TECLA of
                                                    
                                                    #80:
                                                    begin
                                                      if (y<3) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);// Apaga a grade
                                                        POSICAOy_GRADE:=POSICAOy_GRADE+2;    // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade
                                                        y:=y+1;                                            // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    #72:
                                                    begin
                                                      if (y>1) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);// Apaga a grade
                                                        POSICAOy_GRADE:=POSICAOy_GRADE-2;       // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade
                                                        y:=y-1;                                            // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    
                                                    #13: break;
                                                    
                                                    
                                                  end;
                                                end;
                                                
                                                if y=1 then TEMPO:=75;
                                                if y=2 then TEMPO:=50;
                                                if y=3 then TEMPO:=25;
                                                
                                                LIMPAR_TELA();
                                                
                                                // Carregamento ------------------------------------------------
                                                gotoxy(35,15);
                                                textcolor(white);
                                                writeln('Carregando');
                                                textcolor(12);
                                                
                                                gotoxy(19,17); write(#218);
                                                gotoxy(19,20); write(#192);
                                                
                                                for i:=20 to 59 do
                                                begin
                                                  gotoxy(i,17);write(#196);
                                                  gotoxy(i,20); write(#196);
                                                end;
                                                
                                                gotoxy(60,17); write(#191);
                                                gotoxy(60,20); write(#217);
                                                
                                                for i:=18 to 19 do
                                                begin
                                                  gotoxy(19,i); write(#179);
                                                  gotoxy(60,i); write(#179);
                                                end;
                                                
                                                for j:=20 to 59 do
                                                begin
                                                  textcolor(10);
                                                  delay(TEMPO_CARREGAMENTO); // Delay de cada barrinha do carregar
                                                  gotoxy(j,18); write(#219);
                                                  gotoxy(j,19); write(#219);
                                                  
                                                end;
                                                
                                                gotoxy(35,15);
                                                textcolor(white);
                                                writeln('Carregado!');
                                                delay(1200);
                                                
                                                
                                                MOVIMENTO_JOGO(TEMPO); // Chamada do jogo em si
                                                
                                                
                                              end;
                                              
                                              
                                              {-----------------------------------------------------------------|
                                              |OPCAO DO MENU PRINCIPAL: Procedimento que define o que o usuário |
                                              |                         irá escolher entre os submenus do jogo  |
                                              |-----------------------------------------------------------------}
                                              
                                              function OPCAO_MENU(): boolean;
                                              var i,j,x,y,POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy :integer;
                                              TECLA :char;
                                              begin
                                                x:=1; // Posições iniciais representativas da grade
                                                y:=1;
                                                TAMx:=13;
                                                TAMy:=2;
                                                CAIXA_OPCAO(TAMx,TAMy);
                                                POSICAOx_GRADE:=25; // Posições iniciais da grade
                                                POSICAOy_GRADE:=13;
                                                while(true) do
                                                begin
                                                  TECLA:=readkey;
                                                  case TECLA of
                                                    #77:
                                                    begin
                                                      if (x<2) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);  // Apaga a grade
                                                        POSICAOx_GRADE:=POSICAOx_GRADE+18; // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True); // Desenha nova grade
                                                        x:=x+1;                                       // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    #75:
                                                    begin
                                                      if (x>1) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);  // Apaga a grade
                                                        POSICAOx_GRADE:=POSICAOx_GRADE-18; // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade
                                                        x:=x-1;                                        // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    #80:
                                                    begin
                                                      if (y<2) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);  // Apaga a grade
                                                        POSICAOy_GRADE:=POSICAOy_GRADE+5; // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade
                                                        y:=y+1;                                        // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    #72:
                                                    begin
                                                      if (y>1) then
                                                      begin
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,False);   // Apaga a grade
                                                        POSICAOy_GRADE:=POSICAOy_GRADE-5; // Atribui o valor
                                                        GRADE_SELECAO(POSICAOx_GRADE,POSICAOy_GRADE,TAMx,TAMy,True);  // Desenha nova grade
                                                        y:=y-1;                                        // Atribui nova posicao
                                                      end;
                                                    end;
                                                    
                                                    #13: break;
                                                    
                                                  end;
                                                end;
                                                
                                                if ((x=1) and (y=1)) then
                                                begin
                                                  textbackground(green);
                                                  for i:=25 to 38 do
                                                  begin
                                                    for j:=14 to 16 do
                                                    begin
                                                      gotoxy(i,j);  write(' ');
                                                    end
                                                  end;
                                                  textcolor(black);
                                                  gotoxy(29,15); write('Início');
                                                  delay(100);
                                                  
                                                  
                                                  INICIAR_JOGO();
                                                  
                                                end;
                                                
                                                
                                                
                                                if ((x=1) and (y=2)) then
                                                begin
                                                  textbackground(green);
                                                  for i:=25 to 38 do
                                                  begin
                                                    for j:=14 to 16 do
                                                    begin
                                                      gotoxy(i,j+5);  write(' ');
                                                      
                                                    end;
                                                  end;
                                                  
                                                  textcolor(black);
                                                  gotoxy(27,20); write('Instruções');
                                                  delay(100);
                                                  
                                                  MENU_INSTRUCOES();
                                                  if OPCAO_MENU() then
                                                  OPCAO_MENU := true;
                                                end;
                                                
                                                if ((x=2) and (y=1)) then
                                                begin
                                                  textbackground(green);
                                                  for i:=25 to 38 do
                                                  begin
                                                    for j:=14 to 16 do
                                                    begin
                                                      gotoxy(i+18,j); write(' ');
                                                    end;
                                                  end;
                                                  
                                                  textcolor(black);
                                                  
                                                  gotoxy(46,15); write('Recordes');
                                                    delay(100);
                                                    
                                                    MENU_RECORDES();
                                                      if OPCAO_MENU() then
                                                      OPCAO_MENU := true;
                                                      
                                                    end;
                                                    
                                                    if ((x=2) and (y=2)) then
                                                    begin
                                                      textbackground(green);
                                                      for i:=25 to 38 do
                                                      begin
                                                        for j:=14 to 16 do
                                                        begin
                                                          gotoxy(i+18,j+5); write(' ');
                                                        end;
                                                      end;
                                                      textcolor(black);
                                                      gotoxy(48,20); write('Sair');
                                                      delay(100);
                                                      OPCAO_MENU := true;
                                                    end;
                                                    
                                                  end;
                                                  
                                                  
                                                  {-----------------------------------------------------------------|
                                                  |                        PROGRAMA PRINCIPAL                       |
                                                  |-----------------------------------------------------------------}
                                                  
                                                  Begin
                                                    cursoroff;
                                                    while true do
                                                    begin
                                                      MENU_PRINCIPAL ();
                                                      if (OPCAO_MENU()) then
                                                      break;
                                                    end;
                                                  End.
                                                  