# Show do Julião - Jogo de Quiz em Haskell

## Visão Geral do Projeto

O "Show do Julião" é um jogo de quiz baseado em terminal desenvolvido em Haskell como projeto para a disciplina de Programação Funcional. O jogo simula um programa de TV onde os jogadores respondem perguntas de múltipla escolha em diversas categorias (ex.: História, Ciências, Cultura Pop, Esportes, Videogames, Jogos de Tabuleiro e Conhecimentos Gerais). Os jogadores podem ganhar prêmios virtuais, usar ajudas especiais (pular uma pergunta, eliminar duas opções incorretas ou consultar "universitários") e competir por um lugar no ranking de pontuações mais altas. O projeto demonstra conceitos fundamentais de programação funcional em Haskell, incluindo:

- **Listas**: Usadas para armazenar e manipular perguntas, com compreensão de listas e funções de ordem superior.
- **Tipos Algébricos**: Tipos personalizados (`Pergunta`, `Categoria`, `Ajuda`, `ShowJ`, `HighScore`) modelam o domínio do jogo.
- **Classes de Tipo**: Embora não explicitamente implementada no código fornecido, é implícito que uma classe de tipo personalizada pode ser usada para abstrações do domínio.
- **Tipos Abstratos de Dados (ADT)**: O tipo `ShowJ` encapsula o estado do jogo, com uma interface controlada para manipulação.
- **Modularização e IO**: O código é organizado em módulos (`Main`, `Modelo`, `Logica`), utilizando a mônada IO para interação com o usuário e persistência em arquivos.

O projeto atende aos requisitos descritos no documento "Trabalho de Programação Funcional em Haskell", incluindo design modular, interação via terminal e um sistema de pontuações altas persistido em arquivo.

## Funcionalidades

- **Menu Interativo**: Permite iniciar um novo jogo, adicionar/remover perguntas, listar perguntas por categoria, visualizar pontuações altas ou sair.
- **Sistema de Perguntas Dinâmico**: As perguntas são armazenadas em uma lista estática, mas podem ser adicionadas/removidas interativamente.
- **Mecânicas do Jogo**:
  - Responda perguntas para ganhar pontos e prêmios virtuais (até R$1.000.000).
  - Use até três ajudas: Pular, Eliminar duas opções incorretas ou Consultar Universitários.
  - As perguntas são embaralhadas aleatoriamente a cada sessão.
- **Pontuações Altas**: As 10 melhores pontuações são salvas em `highscores.txt` e exibidas em uma tabela formatada.
- **Interface Visual**: Baseada em terminal com cores ANSI e formatação estilizada para uma experiência polida.

## Descrição da Interface no Terminal

Como o jogo roda no terminal, não há telas gráficas, mas a interface é aprimorada com cores ANSI e layouts estruturados. Abaixo está uma representação textual das principais "telas":

1. **Menu Principal**:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ╔══════════════════════════════════════════════════════════╗
    SHOW DO JULIÃO
   ╚══════════════════════════════════════════════════════════╝
      ╔══════════════════════════════════════════════════╗
      ║                  MENU PRINCIPAL                  ║
      ╠══════════════════════════════════════════════════╣
      ║ 1. Iniciar Show                                  ║
      ║ 2. Adicionar Pergunta                            ║
      ║ 3. Remover Pergunta                              ║
      ║ 4. Listar Perguntas por Categoria                ║
      ║ 5. Ver High Scores                               ║
      ║ 6. Sair                                          ║
      ╚══════════════════════════════════════════════════╝
   
      Digite sua opção:
   ```

2. **Tela de Jogo** (exemplo de pergunta):
   ```
   Pontos: 2 | Prêmio Atual: R$2000 | Prêmio por Errar: R$1000
   Pergunta valendo R$5000
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Qual o maior país do mundo em área territorial?
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      1. China
      2. Canadá
      3. Rússia
      4. Estados Unidos
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Ajudas disponíveis: Pular, Eliminar, Universitarios
      Opções: [1-4] Responder | [P]arar | [A]judar
      Sua escolha:
   ```

3. **Pontuações Altas**:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ╔══════════════════════════════════════════════════════════╗
    HIGH SCORES
   ╚══════════════════════════════════════════════════════════╝
      Pos. | Nome                 | Pontos | Prêmio
      --------------------------------------------------
      1.   | Dara                 |     10 | R$1000000
      2.   | Kely                 |      5 | R$2000
      3.   | Bomba                |      1 | R$0
      4.   | Bela                 |      0 | R$0
   ```

## Instalação

### Pré-requisitos

- **Haskell Platform ou GHC + Cabal**:
  - Instale a Haskell Platform (recomendada para iniciantes) ou o GHC (Glasgow Haskell Compiler) com o Cabal.
  - Versões mínimas: GHC >= 7.10, Cabal >= 3.0.
- **Sistema Operacional**: Instruções fornecidas para Windows e Linux.

### Instalando Dependências

O projeto utiliza as seguintes bibliotecas Haskell (especificadas em `quiz-juliao.cabal`):
- `base` (>= 4.7 && < 5)
- `ansi-terminal` (>= 0.11)
- `random` (>= 1.2)
- `directory`
- `random-shuffle`

#### No Windows

1. **Instalar a Haskell Platform**:
   - Baixe e instale a Haskell Platform em [haskell.org/platform](https://www.haskell.org/platform/windows.html).
   - Alternativamente, instale GHC e Cabal separadamente:
     ```bash
     choco install ghc cabal
     ```
     (Requer o gerenciador de pacotes Chocolatey; instale em [chocolatey.org](https://chocolatey.org/install)).

2. **Atualizar o Cabal**:
   ```bash
   cabal update
   ```

3. **Clonar ou Baixar o Projeto**:
   - Se usar Git:
     ```bash
     git clone <url-do-repositório>
     cd quiz-juliao
     ```
   - Ou baixe e extraia os arquivos do projeto manualmente.

4. **Instalar Dependências**:
   - Navegue até o diretório do projeto e execute:
     ```bash
     cabal install --only-dependencies
     ```

#### No Linux

1. **Instalar GHC e Cabal**:
   - No Ubuntu/Debian:
     ```bash
     sudo apt-get update
     sudo apt-get install ghc cabal-install
     ```
   - No Fedora:
     ```bash
     sudo dnf install ghc cabal-install
     ```
   - Para outras distribuições, consulte [haskell.org/downloads](https://www.haskell.org/downloads/) ou use `ghcup`:
     ```bash
     curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
     ```

2. **Atualizar o Cabal**:
   ```bash
   cabal update
   ```

3. **Clonar ou Baixar o Projeto**:
   - Se usar Git:
     ```bash
     git clone <url-do-repositório>
     cd quiz-juliao
     ```
   - Ou baixe e extraia os arquivos do projeto manualmente.

4. **Instalar Dependências**:
   - Navegue até o diretório do projeto e execute:
     ```bash
     cabal install --only-dependencies
     ```

## Executando o Projeto

1. **Navegar até o Diretório do Projeto**:
   ```bash
   cd quiz-juliao
   ```

2. **Compilar o Projeto**:
   ```bash
   cabal build
   ```

3. **Executar o Jogo**:
   ```bash
   cabal run quiz
   ```
   - Isso compila e inicia o jogo, exibindo o menu principal no terminal.

4. **Instruções de Jogabilidade**:
   - Selecione opções digitando o número correspondente (1-6) no menu principal.
   - Durante o jogo:
     - Digite 1-4 para responder a uma pergunta.
     - Digite `P` para parar e manter o prêmio acumulado.
     - Digite `A` para usar uma ajuda (se disponível).
   - Para adicionar/remover perguntas, siga as instruções e digite `0` para cancelar a qualquer momento.
   - As pontuações altas são salvas automaticamente em `highscores.txt` após cada jogo.

## Estrutura do Projeto

- **Main.hs**: Ponto de entrada; gerencia o menu principal, o loop do jogo e a interface com o usuário.
- **Modelo.hs**: Define os tipos algébricos (`Pergunta`, `Categoria`, `Ajuda`, `ShowJ`, `HighScore`) e funções principais do estado do jogo.
- **Logica.hs**: Implementa a lógica do jogo, incluindo filtragem de perguntas, embaralhamento, ajudas e cálculos de pontuação.
- **quiz-juliao.cabal**: Arquivo de configuração do Cabal, especificando dependências e configurações de build.
- **highscores.txt**: Armazena as 10 melhores pontuações em formato legível.

## Observações

- O jogo assume um terminal que suporta códigos de escape ANSI para cores e formatação. No Windows, certifique-se de usar um terminal compatível (ex.: PowerShell, Windows Terminal) com suporte a ANSI (Windows 10+ deve funcionar).
- O projeto usa uma lista estática de perguntas em `Main.hs`, mas suporta adição/remoção dinâmica durante a execução.
- As pontuações altas são persistidas em `highscores.txt` e carregadas automaticamente ao iniciar o jogo.

## Autores

- **Bomba** (mantenedor, conforme especificado em `quiz-juliao.cabal`)

## Licença

Este projeto não possui licença (conforme especificado em `quiz-juliao.cabal`).