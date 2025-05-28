module Main where

import Modelo
import Logica
import System.IO
import Control.Exception (try, SomeException)
import Text.Read (readMaybe)
import System.Console.ANSI
import System.Directory (doesFileExist)
import Data.List (intercalate, nub, sortOn, isPrefixOf, findIndex, tails)
import System.Random (randomRIO, newStdGen, randomRs)
import Data.Char (toUpper, isSpace, toLower)
import Data.Maybe (isNothing, catMaybes, fromMaybe)
import Text.Printf (printf) -- Importa o printf nativo do Haskell

-- =============================================================================
-- Perguntas e Prêmios
-- =============================================================================

-- | Perguntas estáticas (aproximadamente metade das perguntas originais)
perguntasEstaticas :: [Pergunta]
perguntasEstaticas = [
    -- História
    Pergunta "Quem descobriu o Brasil?" ["Vasco da Gama", "Pedro Álvares Cabral", "Cristóvão Colombo", "Fernão de Magalhães"] 2 Historia,
    Pergunta "Em que ano o homem pisou na Lua pela primeira vez?" ["1965", "1969", "1971", "1975"] 2 Historia,
    Pergunta "Qual foi a principal causa da Guerra dos Cem Anos?" ["Disputa religiosa", "Crise econômica", "Disputa pelo trono francês", "Expansão territorial"] 3 Historia,
    Pergunta "Qual tratado pôs fim à Primeira Guerra Mundial?" ["Tratado de Tordesilhas", "Tratado de Versalhes", "Tratado de Madri", "Pacto de Varsóvia"] 2 Historia,
    Pergunta "Quem foi o primeiro presidente do Brasil?" ["Dom Pedro II", "Getúlio Vargas", "Marechal Deodoro da Fonseca", "Prudente de Morais"] 3 Historia,
    Pergunta "Qual a cor do cavalo branco de Napoleão?" ["Preto", "Marrom", "Branco", "Malhado"] 3 Historia,
    Pergunta "Qual civilização antiga construiu as pirâmides de Gizé?" ["Romana", "Grega", "Egípcia", "Mesopotâmica"] 3 Historia,
    Pergunta "Quem foi a primeira mulher a voar sozinha sobre o Atlântico?" ["Amelia Earhart", "Valentina Tereshkova", "Bessie Coleman", "Harriet Quimby"] 1 Historia,
    -- Ciências
    Pergunta "O que significa H2O?" ["Ácido Sulfúrico", "Oxigênio", "Hidrogênio", "Água"] 4 Ciencias,
    Pergunta "Quantos planetas existem no Sistema Solar (reconhecidos pela UAI)?" ["7", "8", "9", "10"] 2 Ciencias,
    Pergunta "Qual o maior osso do corpo humano?" ["Fêmur", "Tíbia", "Úmero", "Crânio"] 1 Ciencias,
    Pergunta "Qual elemento químico tem o símbolo 'Fe'?" ["Ferro", "Flúor", "Fósforo", "Frâncio"] 1 Ciencias,
    Pergunta "O que é a 'singularidade' em um buraco negro?" ["O horizonte de eventos", "Um ponto de densidade infinita", "A radiação emitida", "A massa do buraco negro"] 2 Ciencias,
    Pergunta "Qual a função das mitocôndrias nas células?" ["Respiração celular e produção de ATP", "Síntese de proteínas", "Digestão celular", "Armazenamento de material genético"] 1 Ciencias,
    Pergunta "Qual a velocidade da luz no vácuo (aproximadamente)?" ["300.000 km/h", "300.000 m/s", "300.000 km/s", "300.000 mph"] 3 Ciencias,
    Pergunta "Qual gás é essencial para a respiração humana?" ["Nitrogênio", "Dióxido de Carbono", "Oxigênio", "Hélio"] 3 Ciencias,
    -- Cultura Pop
    Pergunta "Qual personagem da Disney perdeu o sapatinho de cristal?" ["Branca de Neve", "Aurora", "Cinderela", "Bela"] 3 CulturaPop,
    Pergunta "Qual o nome do melhor amigo do Harry Potter?" ["Draco Malfoy", "Neville Longbottom", "Hermione Granger", "Ron Weasley"] 4 CulturaPop,
    Pergunta "Qual banda lançou o álbum 'The Dark Side of the Moon'?" ["The Beatles", "Led Zeppelin", "Pink Floyd", "Queen"] 3 CulturaPop,
    Pergunta "Qual ator interpretou o Coringa no filme de 2008 'O Cavaleiro das Trevas'?" ["Jack Nicholson", "Jared Leto", "Joaquin Phoenix", "Heath Ledger"] 4 CulturaPop,
    Pergunta "Qual o nome do diretor do filme 'Pulp Fiction'?" ["Martin Scorsese", "Steven Spielberg", "Quentin Tarantino", "Christopher Nolan"] 3 CulturaPop,
    Pergunta "Qual artista pintou o teto da Capela Sistina?" ["Leonardo da Vinci", "Rafael Sanzio", "Donatello", "Michelangelo"] 4 CulturaPop,
    Pergunta "Qual o nome da nave espacial de Han Solo em Star Wars?" ["Enterprise", "Serenity", "Millennium Falcon", "Discovery"] 3 CulturaPop,
    Pergunta "Qual série de TV apresenta os personagens Ross, Rachel, Monica, Chandler, Joey e Phoebe?" ["Seinfeld", "Friends", "How I Met Your Mother", "The Big Bang Theory"] 2 CulturaPop,
    -- Esportes
    Pergunta "Qual time brasileiro tem mais títulos da Copa Libertadores?" ["São Paulo", "Palmeiras", "Santos", "Independiente (ARG)"] 4 Esportes,
    Pergunta "Qual jogador de futebol é conhecido como 'Rei'?" ["Maradona", "Messi", "Cristiano Ronaldo", "Pelé"] 4 Esportes,
    Pergunta "Qual tenista detém o recorde de mais títulos de Grand Slam individuais masculinos?" ["Roger Federer", "Rafael Nadal", "Novak Djokovic", "Pete Sampras"] 3 Esportes,
    Pergunta "Em que país nasceu o jogador de basquete Michael Jordan?" ["Canadá", "Estados Unidos", "Brasil", "Austrália"] 2 Esportes,
    Pergunta "Quantos jogadores compõem um time de vôlei em quadra?" ["5", "6", "7", "11"] 2 Esportes,
    Pergunta "Qual país sediou a Copa do Mundo FIFA de 2014?" ["África do Sul", "Alemanha", "Rússia", "Brasil"] 4 Esportes,
    Pergunta "Qual o nome do evento esportivo que reúne atletas de todo o mundo a cada 4 anos?" ["Copa do Mundo", "Olimpíadas", "Pan-Americano", "Liga dos Campeões"] 2 Esportes,
    Pergunta "Qual esporte utiliza um taco para rebater uma bola pequena e dura?" ["Tênis", "Críquete", "Beisebol", "Hóquei"] 3 Esportes,
    -- Videogames
    Pergunta "Qual o nome do personagem principal da franquia Mario?" ["Luigi", "Yoshi", "Bowser", "Mario"] 4 Videogames,
    Pergunta "Em qual jogo o personagem Kratos é o protagonista?" ["Devil May Cry", "God of War", "Dark Souls", "The Witcher"] 2 Videogames,
    Pergunta "Qual foi o primeiro console de videogame lançado comercialmente?" ["Atari 2600", "ColecoVision", "Magnavox Odyssey", "NES"] 3 Videogames,
    Pergunta "Qual empresa desenvolveu o console PlayStation?" ["Microsoft", "Nintendo", "Sega", "Sony"] 4 Videogames,
    Pergunta "Qual jogo popularizou o gênero Battle Royale?" ["Fortnite", "Apex Legends", "PUBG (PlayerUnknown's Battlegrounds)", "Call of Duty: Warzone"] 3 Videogames,
    Pergunta "Qual o nome do ouriço azul mascote da Sega?" ["Tails", "Knuckles", "Sonic", "Dr. Robotnik"] 3 Videogames,
    Pergunta "Qual jogo envolve construir e sobreviver em um mundo de blocos?" ["Terraria", "Roblox", "Stardew Valley", "Minecraft"] 4 Videogames,
    Pergunta "Qual franquia de luta é famosa pelo comando 'Hadouken'?" ["Mortal Kombat", "Tekken", "Street Fighter", "Super Smash Bros."] 3 Videogames,
    -- Jogos (Tabuleiro, Cartas, etc.)
    Pergunta "Quantas casas tem um tabuleiro de xadrez?" ["32", "64", "81", "100"] 2 Jogos,
    Pergunta "Qual o nome do criador do jogo Minecraft?" ["Gabe Newell", "Markus Persson (Notch)", "Hideo Kojima", "Shigeru Miyamoto"] 2 Jogos,
    Pergunta "No jogo de Poker, qual a combinação de cartas mais valiosa?" ["Straight Flush", "Four of a Kind", "Full House", "Royal Flush"] 4 Jogos,
    Pergunta "Qual o objetivo do jogo Banco Imobiliário (Monopoly)?" ["Construir casas", "Levar os outros jogadores à falência", "Comprar todas as propriedades", "Pagar menos impostos"] 2 Jogos,
    Pergunta "Quantos lados tem um dado padrão?" ["4", "6", "8", "12"] 2 Jogos,
    Pergunta "Qual jogo de cartas envolve formar sequências ou trincas?" ["Truco", "Buraco/Canastra", "Paciência", "Blackjack (21)"] 2 Jogos,
    Pergunta "Qual peça do xadrez pode se mover em 'L'?" ["Torre", "Bispo", "Cavalo", "Rainha"] 3 Jogos,
    Pergunta "Qual jogo envolve adivinhar palavras ou frases desenhadas por outro jogador?" ["Imagem & Ação", "Detetive", "War", "Perfil"] 1 Jogos,
    -- Conhecimentos Gerais
    Pergunta "Qual o maior país do mundo em área territorial?" ["China", "Canadá", "Rússia", "Estados Unidos"] 3 ConhecimentosGerais,
    Pergunta "Qual o ponto mais alto da Terra?" ["Monte Kilimanjaro", "K2", "Monte Everest", "Monte Aconcágua"] 3 ConhecimentosGerais,
    Pergunta "Qual o nome do rio mais longo do mundo?" ["Rio Nilo", "Rio Amazonas", "Rio Yangtzé", "Rio Mississippi"] 2 ConhecimentosGerais,
    Pergunta "Qual a capital da Austrália?" ["Sydney", "Melbourne", "Brisbane", "Camberra"] 4 ConhecimentosGerais,
    Pergunta "Qual o oceano mais extenso do mundo?" ["Atlântico", "Índico", "Ártico", "Pacífico"] 4 ConhecimentosGerais,
    Pergunta "Quantos continentes existem na Terra (modelo mais comum)?" ["5", "6", "7", "8"] 3 ConhecimentosGerais,
    Pergunta "Qual a moeda oficial do Japão?" ["Won", "Yuan", "Dólar", "Iene"] 4 ConhecimentosGerais
    ]

-- | Lista de prêmios
premios :: [Int]
premios = [1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000]

-- =============================================================================
-- Funções de Interface e Utilidades Visuais (NOVA PALETA E DETALHES)
-- =============================================================================

-- | Limpa a tela do terminal
limparTela :: IO ()
limparTela = setCursorPosition 0 0 >> clearScreen

-- | Exibe uma linha divisória estilizada (verde)
linhaDivisoria :: IO ()
linhaDivisoria = putStrLn $ setSGRCode [SetColor Foreground Dull Green] ++ replicate 60 '━' ++ setSGRCode [Reset]

-- | Exibe um título centralizado com borda dupla (verde e ciano)
exibirTitulo :: String -> IO ()
exibirTitulo titulo = do
    let larguraTotal = 60
    let tituloFormatado = " " ++ titulo ++ " "
    let paddingTotal = larguraTotal - length tituloFormatado - 2 -- -2 para as bordas laterais
    let paddingAntes = paddingTotal `div` 2
    let paddingDepois = paddingTotal - paddingAntes
    let linhaSuperior = setSGRCode [SetColor Foreground Dull Green] ++ "╔" ++ replicate (larguraTotal - 2) '═' ++ "╗" ++ setSGRCode [Reset]
    let linhaInferior = setSGRCode [SetColor Foreground Dull Green] ++ "╚" ++ replicate (larguraTotal - 2) '═' ++ "╝" ++ setSGRCode [Reset]
    let linhaMeio = setSGRCode [SetColor Foreground Dull Green] ++ "║" ++ setSGRCode [Reset] ++
                    replicate paddingAntes ' ' ++
                    setSGRCode [SetColor Foreground Vivid Cyan, SetConsoleIntensity BoldIntensity] ++ tituloFormatado ++ setSGRCode [Reset] ++
                    replicate paddingDepois ' ' ++
                    setSGRCode [SetColor Foreground Dull Green] ++ "║" ++ setSGRCode [Reset]
    putStrLn linhaSuperior
    putStrLn linhaMeio
    putStrLn linhaInferior

-- | Centraliza texto em um espaço definido (usado internamente se necessário)
centralizarTexto :: Int -> String -> String
centralizarTexto largura txt =
    let len = length txt
        espacosTotal = largura - len
        espacosAntes = espacosTotal `div` 2
        espacosDepois = espacosTotal - espacosAntes
    in replicate espacosAntes ' ' ++ txt ++ replicate espacosDepois ' '

-- | Exibe o menu principal com detalhes visuais
exibirMenuPrincipal :: IO ()
exibirMenuPrincipal = do
    exibirTitulo "SHOW DO JULIÃO"
    putStrLn $ setSGRCode [SetColor Foreground Vivid Magenta] ++ "   ╔══════════════════════════════════════════════════╗" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Magenta] ++ "   ║                  MENU PRINCIPAL                  ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Magenta] ++ "   ╠══════════════════════════════════════════════════╣" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 1. Iniciar Show                                  ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 2. Adicionar Pergunta                            ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 3. Remover Pergunta                              ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 4. Listar Perguntas por Categoria                ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 5. Ver High Scores                               ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Yellow] ++ "   ║ 6. Sair                                          ║" ++ setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Vivid Magenta] ++ "   ╚══════════════════════════════════════════════════╝" ++ setSGRCode [Reset]
    putStr $ "\n" ++ setSGRCode [SetColor Foreground Vivid Cyan] ++ "   Digite sua opção: " ++ setSGRCode [Reset]

-- | Exibe o status atual do jogo (pontuação, prêmios)
exibirStatusJogo :: ShowJ -> Int -> IO ()
exibirStatusJogo estado nivel = do
    let premioAtual = premio estado
    let premioErro = calcularPremioErro (pontuacao estado) -- Usa Logica.calcularPremioErro
    let premioNivel = premios !! min nivel (length premios - 1)
    putStrLn $ setSGRCode [SetColor Foreground Dull Magenta] ++
               "   Pontos: " ++ show (pontuacao estado) ++
               " | Prêmio Atual: R$" ++ show premioAtual ++
               " | Prêmio por Errar: R$" ++ show premioErro ++
               setSGRCode [Reset]
    putStrLn $ setSGRCode [SetColor Foreground Dull Yellow] ++
               "   Pergunta valendo R$" ++ show premioNivel ++
               setSGRCode [Reset]
    linhaDivisoria

-- | Exibe a pergunta e suas opções
exibirPerguntaOpcoes :: Pergunta -> Maybe [(Int, String)] -> IO ()
exibirPerguntaOpcoes p maybeOpcoesRestantes = do
    putStrLn $ "\n" ++ setSGRCode [SetColor Foreground Dull White, SetConsoleIntensity BoldIntensity] ++ "   " ++ texto p ++ setSGRCode [Reset]
    linhaDivisoria
    case maybeOpcoesRestantes of
        Nothing -> -- Exibe todas as opções normalmente
            putStrLn $ unlines $ map (\(i, o) -> "   " ++ formatarOpcao i o) $ zip [1..] (opcoes p)
        Just opcoesRestantes -> -- Exibe apenas as opções restantes (após ajuda Eliminar)
            putStrLn $ unlines $ map (\(i, o) -> "   " ++ formatarOpcao i o) (sortOn fst opcoesRestantes) -- Ordena pelo índice original

-- | Formata uma única opção para exibição
formatarOpcao :: Int -> String -> String
formatarOpcao i o = setSGRCode [SetColor Foreground Dull Cyan] ++ show i ++ ". " ++ setSGRCode [Reset] ++ o

-- | Exibe as opções de ação do jogador (Responder, Parar, Ajudar)
exibirOpcoesAcaoJogador :: ShowJ -> Bool -> IO ()
exibirOpcoesAcaoJogador estado permiteAjuda = do
    linhaDivisoria
    putStrLn $ "   \ESC[1;36mAjudas disponíveis: " ++ formatarAjudas (ajudas estado) ++ "\ESC[0m"
    let opcoesBase = "[1-4] Responder | [P]arar"
    let opcoesComAjuda = if permiteAjuda && not (null (ajudas estado)) then opcoesBase ++ " | [A]judar" else opcoesBase
    putStrLn $ "   \ESC[1;34mOpções: " ++ opcoesComAjuda ++ "\ESC[0m"
    putStr $ "   \ESC[1;34mSua escolha: \ESC[0m"

-- | Formata a lista de ajudas para exibição
formatarAjudas :: [Ajuda] -> String
formatarAjudas [] = "Nenhuma"
formatarAjudas as = intercalate ", " (map show as)

-- | Pausa a execução e espera o usuário pressionar Enter
esperarEnter :: String -> IO ()
esperarEnter msg = do
    putStrLn $ "\n   " ++ setSGRCode [SetColor Foreground Dull White] ++ msg ++ setSGRCode [Reset]
    getLine
    return ()

-- | Exibe mensagem de sucesso
mensagemSucesso :: String -> IO ()
mensagemSucesso msg = putStrLn $ "   " ++ setSGRCode [SetColor Foreground Dull Green] ++ "✅ " ++ msg ++ setSGRCode [Reset]

-- | Exibe mensagem de erro/aviso
mensagemErro :: String -> IO ()
mensagemErro msg = putStrLn $ "   " ++ setSGRCode [SetColor Foreground Dull Red] ++ "❌ " ++ msg ++ setSGRCode [Reset]

-- | Exibe mensagem informativa
mensagemInfo :: String -> IO ()
mensagemInfo msg = putStrLn $ "   " ++ setSGRCode [SetColor Foreground Dull Blue] ++ "ℹ️ " ++ msg ++ setSGRCode [Reset]

-- =============================================================================
-- Lógica Principal do Jogo
-- =============================================================================

-- | Função principal
main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    setTitle "Show do Julião"
    limparTela
    -- MODIFICADO: Inicia o jogo diretamente com as perguntas estáticas
    let estadoInicial = novoShow perguntasEstaticas
    estadoComScores <- carregarHighScores estadoInicial -- Carrega high scores (se existirem)
    loop estadoComScores

-- | Loop principal do programa (menu)
loop :: ShowJ -> IO ()
loop estado = do
    limparTela
    exibirMenuPrincipal
    opcao <- getLine
    novoEstado <- case opcao of
        "1" -> iniciarShow estado
        "2" -> adicionarNovaPergunta estado
        "3" -> removerPerguntaInterativo estado
        "4" -> listarPorCategoria estado
        "5" -> exibirHighScores estado
        "6" -> mensagemInfo "Obrigado por jogar o Show do Julião! Até a próxima!" >> return estado
        _   -> mensagemErro "Opção inválida!" >> esperarEnter "Pressione Enter para continuar." >> return estado
    if opcao == "6" then return () else loop novoEstado

iniciarShow :: ShowJ -> IO ShowJ
iniciarShow estado = do
    limparTela
    exibirTitulo "INICIANDO O SHOW"
    -- Usa as perguntas já carregadas no estado (que agora são as estáticas inicialmente)
    if null (perguntas estado)
        then mensagemErro "Nenhuma pergunta carregada!" >> esperarEnter "Pressione Enter para voltar." >> return estado
        else do
            putStr "   Digite seu nome para o placar: " >> hFlush stdout
            nomeInput <- getLine
            let nomeFinal = if null (trim nomeInput) then "Anônimo" else trim nomeInput
            perguntasEmbaralhadas <- embaralharPerguntas $ perguntas estado -- Usa Logica.embaralharPerguntas
            let estadoNovoJogo = estado { pontuacao = 0, premio = 0, ajudas = [Pular, Eliminar, Universitarios], respondidas = [], nomeJogadorAtual = Just nomeFinal } -- Armazena o nome
            estadoFinalJogo <- executarJogo estadoNovoJogo perguntasEmbaralhadas 0
            -- O nome já está no estadoFinalJogo, registrarHighScore vai usá-lo
            estadoComNovoScore <- registrarHighScore estadoFinalJogo
            return estadoComNovoScore -- Retorna o estado com o score atualizado, mas nomeJogadorAtual resetado por registrarHighScore

-- | Loop principal da execução do jogo (pergunta por pergunta)
executarJogo :: ShowJ -> [Pergunta] -> Int -> IO ShowJ
executarJogo estado [] _ = do
    limparTela
    exibirTitulo "FIM DE JOGO"
    mensagemSucesso "Parabéns! Você respondeu todas as perguntas disponíveis!"
    mensagemInfo $ calcularResultadoFinal estado -- Usa Logica.calcularResultadoFinal
    return estado
executarJogo estado (p:ps) nivel = executarPergunta estado p ps nivel Nothing

-- | Executa uma única pergunta
executarPergunta :: ShowJ -> Pergunta -> [Pergunta] -> Int -> Maybe [(Int, String)] -> IO ShowJ
executarPergunta estado p ps nivel maybeOpcoesRestantes = do
    limparTela
    exibirStatusJogo estado nivel
    exibirPerguntaOpcoes p maybeOpcoesRestantes
    exibirOpcoesAcaoJogador estado (isNothing maybeOpcoesRestantes)

    escolha <- getLine
    let indicesVisiveis = maybe [1..(length $ opcoes p)] (map fst) maybeOpcoesRestantes

    case map toUpper escolha of
        "P" -> handleParar estado
        "A" | isNothing maybeOpcoesRestantes && not (null (ajudas estado)) -> handleAjuda estado p ps nivel
        "A" -> mensagemErro "Ajuda não disponível ou já utilizada nesta pergunta." >> esperarEnter "Pressione Enter para tentar novamente." >> executarPergunta estado p ps nivel maybeOpcoesRestantes
        respStr -> case readMaybe respStr :: Maybe Int of
            Just r | r `elem` indicesVisiveis -> handleResposta estado p ps nivel r maybeOpcoesRestantes
            _ -> mensagemErro ("Escolha inválida! Use um número entre " ++ show (minimum indicesVisiveis) ++ " e " ++ show (maximum indicesVisiveis) ++ ", P ou A.") >> esperarEnter "Pressione Enter para tentar novamente." >> executarPergunta estado p ps nivel maybeOpcoesRestantes

-- | Lida com a decisão de parar o jogo
handleParar :: ShowJ -> IO ShowJ
handleParar estado = do
    mensagemSucesso $ "Você decidiu parar com R$" ++ show (premio estado)
    return estado

-- | Lida com a escolha de usar uma ajuda
handleAjuda :: ShowJ -> Pergunta -> [Pergunta] -> Int -> IO ShowJ
handleAjuda estado p ps nivel = do
    let ajudasDisponiveis = ajudas estado
    limparTela
    exibirTitulo "USAR AJUDA"
    putStrLn "   \ESC[1;36mEscolha uma ajuda disponível:\ESC[0m"
    let ajudasNumeradas = zip [1..] ajudasDisponiveis
    putStrLn $ unlines $ map (\(i, a) -> "     " ++ show i ++ ". " ++ show a) ajudasNumeradas
    putStrLn $ "     " ++ show (length ajudasNumeradas + 1) ++ ". Cancelar"
    putStr "   \ESC[1;34mDigite o número da ajuda: \ESC[0m"

    escolhaStr <- getLine
    case readMaybe escolhaStr :: Maybe Int of
        Just n | n > 0 && n <= length ajudasNumeradas -> do
            let ajudaEscolhida = snd (ajudasNumeradas !! (n-1))
            let novoEstado = usarAjuda estado ajudaEscolhida
            case ajudaEscolhida of
                Pular -> do
                    mensagemInfo "Pergunta pulada!"
                    esperarEnter "Pressione Enter para a próxima pergunta..."
                    executarJogo novoEstado ps nivel
                Eliminar -> do
                    opcoesRestantes <- eliminarOpcoes p -- Usa Logica.eliminarOpcoes
                    mensagemInfo $ "Eliminadas duas opções! Restaram: " ++ intercalate ", " (map (show . fst) opcoesRestantes)
                    esperarEnter "Pressione Enter para continuar..."
                    executarPergunta novoEstado p ps nivel (Just opcoesRestantes)
                Universitarios -> do
                    resultado <- consultarUniversitarios p -- Usa Logica.consultarUniversitarios
                    mensagemInfo $ "Consulta aos Universitários: " ++ resultado
                    esperarEnter "Pressione Enter para continuar..."
                    executarPergunta novoEstado p ps nivel Nothing
        Just n | n == length ajudasNumeradas + 1 -> do
            mensagemInfo "Uso de ajuda cancelado."
            esperarEnter "Pressione Enter para voltar à pergunta."
            executarPergunta estado p ps nivel Nothing
        _ -> do
            mensagemErro "Opção inválida!"
            esperarEnter "Pressione Enter para tentar novamente."
            executarPergunta estado p ps nivel Nothing

-- | Lida com a resposta do jogador
handleResposta :: ShowJ -> Pergunta -> [Pergunta] -> Int -> Int -> Maybe [(Int, String)] -> IO ShowJ
handleResposta estado p ps nivel resposta maybeOpcoesRestantes = do
    let novoEstado = responderPergunta estado p resposta
    if resposta == correta p
        then do
            mensagemSucesso "Correto!"
            if premio novoEstado >= last premios
                then do
                    mensagemSucesso $ "Parabéns! Você ganhou o prêmio máximo de R$" ++ show (last premios) ++ "!"
                    return novoEstado
                else do
                    esperarEnter "Pressione Enter para a próxima pergunta..."
                    executarJogo novoEstado ps (nivel + 1)
        else do
            mensagemErro $ "Errado! A resposta correta era a " ++ show (correta p) ++ "."
            let premioConsolacao = calcularPremioErro (pontuacao estado) -- Usa Logica.calcularPremioErro
            mensagemInfo $ "Você perdeu tudo, mas leva R$" ++ show premioConsolacao ++ " como prêmio de consolação."
            return estado { premio = premioConsolacao }

-- =============================================================================
-- Funções de Gerenciamento de Perguntas (Adicionar, Remover, Listar) - COM CANCELAR
-- =============================================================================

-- | Adiciona uma nova pergunta, com opção de cancelar em cada etapa
adicionarNovaPergunta :: ShowJ -> IO ShowJ
adicionarNovaPergunta estado = do
    limparTela
    exibirTitulo "ADICIONAR NOVA PERGUNTA"
    maybePergunta <- coletarDetalhesPergunta
    case maybePergunta of
        Nothing -> mensagemInfo "Adição cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado
        Just novaPergunta -> do
            let estadoAtualizado = adicionarPergunta estado novaPergunta
            mensagemSucesso "Pergunta adicionada com sucesso!"
            esperarEnter "Pressione Enter para voltar ao menu."
            return estadoAtualizado

coletarDetalhesPergunta :: IO (Maybe Pergunta)
coletarDetalhesPergunta = do
    putStrLn "   (Digite '0' a qualquer momento para cancelar e voltar)" -- Modificado para cancelar com 0
    maybeTexto <- perguntar "   Texto da pergunta: "
    case maybeTexto of
        Nothing -> return Nothing
        Just txt -> do
            maybeOpcoes <- coletarOpcoes []
            case maybeOpcoes of
                Nothing -> return Nothing
                Just ops -> do
                    maybeCorreta <- perguntarInt "   Índice da resposta correta (1-4): " [1..4]
                    case maybeCorreta of
                        Nothing -> return Nothing
                        Just cor -> do
                            maybeCategoria <- perguntarCategoria
                            case maybeCategoria of
                                Nothing -> return Nothing
                                Just cat -> return $ Just (Pergunta txt ops cor cat)

-- | Coleta as 4 opções, permitindo cancelar
coletarOpcoes :: [String] -> IO (Maybe [String])
coletarOpcoes coletadas | length coletadas == 4 = return (Just coletadas)
coletarOpcoes coletadas = do
    maybeOpcao <- perguntar ("   Opção " ++ show (length coletadas + 1) ++ ": ")
    case maybeOpcao of
        Nothing -> return Nothing
        Just op -> coletarOpcoes (coletadas ++ [op])

-- | Pergunta uma string ao usuário, retorna Nothing se cancelar com "0"
perguntar :: String -> IO (Maybe String)
perguntar prompt = do
    putStr prompt
    input <- getLine
    if trim input == "0"
        then return Nothing
        else return (Just input)
-- | Pergunta um inteiro ao usuário dentro de um range, retorna Nothing se cancelar com "0" ou inválido
perguntarInt :: String -> [Int] -> IO (Maybe Int)
perguntarInt prompt rangeValido = do
    putStr prompt
    input <- getLine
    if trim input == "0"
        then return Nothing
        else case readMaybe input :: Maybe Int of
                 Just n | n `elem` rangeValido -> return (Just n)
                 _ -> mensagemErro ("Entrada inválida. Digite um número entre " ++ show (minimum rangeValido) ++ " e " ++ show (maximum rangeValido) ++ " ou '0' para cancelar.") >> perguntarInt prompt rangeValido-- | Pergunta a categoria ao usuário, retorna Nothing se cancelar
perguntarCategoria :: IO (Maybe Categoria)
perguntarCategoria = do
    putStrLn "   Categorias disponíveis:"
    let categoriasNumeradas = zip [1..] allCategorias
    putStrLn $ unlines $ map (\(i, c) -> "     " ++ show i ++ ". " ++ show c) categoriasNumeradas
    maybeIndice <- perguntarInt "   Digite o número da categoria: " [1..length allCategorias]
    case maybeIndice of
        Nothing -> return Nothing
        Just indice -> return $ Just (snd $ categoriasNumeradas !! (indice - 1))

removerPerguntaInterativo :: ShowJ -> IO ShowJ
removerPerguntaInterativo estado = do
    limparTela
    exibirTitulo "REMOVER PERGUNTA"
    if null (perguntas estado)
        then mensagemErro "Nenhuma pergunta para remover." >> esperarEnter "Pressione Enter para voltar." >> return estado
        else do
            putStrLn "   Digite parte do texto da pergunta a ser removida (ou deixe em branco para listar todas, ou 'CANCELAR'):"
            putStr "   > "
            termoBusca <- getLine
            let termoBuscaTrimmed = trim termoBusca
            if map toUpper termoBuscaTrimmed == "CANCELAR"
                then mensagemInfo "Remoção cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado
                else do
                    let perguntasEncontradas = if null termoBuscaTrimmed
                                                then perguntas estado -- Lista todas se busca vazia
                                                else filter (contemIgnoreCase termoBuscaTrimmed . texto) (perguntas estado)
                    case perguntasEncontradas of
                        [] -> do
                            let msg = if null termoBuscaTrimmed then "Nenhuma pergunta cadastrada." else "Nenhuma pergunta encontrada com esse termo."
                            mensagemErro msg >> esperarEnter "Pressione Enter para tentar novamente." >> removerPerguntaInterativo estado
                        [p] | not (null termoBuscaTrimmed) -> confirmarRemocao estado p -- Confirma só se buscou e achou uma
                        ps -> selecionarParaRemover estado ps -- Lista se busca vazia ou achou múltiplas

-- | Confirma a remoção de uma única pergunta encontrada
confirmarRemocao :: ShowJ -> Pergunta -> IO ShowJ
confirmarRemocao estado p = do
    putStrLn $ "\n   Pergunta encontrada: " ++ texto p
    putStr "   Confirmar remoção? (S/N): "
    confirmacao <- getLine
    case map toUpper confirmacao of
        "S" -> do
            let estadoAtualizado = removerPergunta estado (texto p)
            mensagemSucesso "Pergunta removida com sucesso!"
            esperarEnter "Pressione Enter para voltar."
            return estadoAtualizado
        _ -> mensagemInfo "Remoção cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado

-- | Permite ao usuário selecionar qual pergunta remover quando múltiplas são encontradas
selecionarParaRemover :: ShowJ -> [Pergunta] -> IO ShowJ
selecionarParaRemover estado ps = do
    putStrLn "\n   Múltiplas perguntas encontradas. Qual deseja remover?"
    let perguntasNumeradas = zip [1..] ps
    putStrLn $ unlines $ map (\(i, p) -> "     " ++ show i ++ ". " ++ texto p) perguntasNumeradas
    putStrLn $ "     " ++ show (length ps + 1) ++ ". Cancelar"
    maybeIndice <- perguntarInt "   Digite o número da pergunta: " [1..(length ps + 1)]
    case maybeIndice of
        Nothing -> mensagemInfo "Remoção cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado
        Just n | n > 0 && n <= length ps -> confirmarRemocao estado (snd $ perguntasNumeradas !! (n-1))
        Just _ -> mensagemInfo "Remoção cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado

-- | Verifica se a substring ocorre na string (ignorando case)
contemIgnoreCase :: String -> String -> Bool
contemIgnoreCase agulha palheiro = any (isPrefixOf (map toLower agulha)) (tails (map toLower palheiro))

-- | Lista perguntas por categoria
listarPorCategoria :: ShowJ -> IO ShowJ
listarPorCategoria estado = do
    limparTela
    exibirTitulo "LISTAR PERGUNTAS POR CATEGORIA"
    putStrLn "   Escolha a categoria para listar:"
    let categoriasNumeradas = zip [1..] allCategorias
    putStrLn $ unlines $ map (\(i, c) -> "     " ++ show i ++ ". " ++ show c) categoriasNumeradas
    putStrLn $ "     " ++ show (length allCategorias + 1) ++ ". Todas"
    putStrLn $ "     " ++ show (length allCategorias + 2) ++ ". Cancelar"
    maybeIndice <- perguntarInt "   Digite o número da categoria: " [1..(length allCategorias + 2)]

    case maybeIndice of
        Nothing -> mensagemInfo "Listagem cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado
        Just n | n == length allCategorias + 2 -> mensagemInfo "Listagem cancelada." >> esperarEnter "Pressione Enter para voltar." >> return estado
        Just n -> do
            let perguntasFiltradas = if n == length allCategorias + 1
                                        then perguntas estado -- Todas
                                        else let catEscolhida = snd (categoriasNumeradas !! (n-1))
                                             in filter ((== catEscolhida) . categoria) (perguntas estado)
            limparTela
            let titulo = if n == length allCategorias + 1 then "TODAS AS PERGUNTAS" else "PERGUNTAS - " ++ (map toUpper $ show $ snd $ categoriasNumeradas !! (n-1))
            exibirTitulo titulo
            if null perguntasFiltradas
                then mensagemInfo "Nenhuma pergunta encontrada nesta categoria."
                else putStrLn $ unlines $ map formatarPerguntaParaLista perguntasFiltradas -- Usa Logica.formatarPerguntaParaLista
            esperarEnter "Pressione Enter para voltar ao menu."
            return estado

-- =============================================================================
-- Funções de Persistência (Salvar/Carregar High Scores)
-- =============================================================================

-- Função trim auxiliar (definida localmente ou importar de Logica.hs se existir lá)
trim :: String -> String
trim = dropWhile isSpace . dropWhileEnd isSpace

dropWhileEnd :: (a -> Bool) -> [a] -> [a]
dropWhileEnd p = foldr (\x acc -> if p x && null acc then [] else x : acc) []

-- =============================================================================
-- Funções de Persistência (Salvar/Carregar High Scores)
-- =============================================================================

-- | Nome do arquivo para salvar/carregar high scores
arquivoHighScores :: String
arquivoHighScores = "highscores.txt"

-- | Salva os high scores no arquivo
salvarHighScores :: ShowJ -> IO ()
salvarHighScores estado = do
    resultado <- try (writeFile arquivoHighScores (unlines $ map show (highScores estado))) :: IO (Either SomeException ())
    case resultado of
        Left e -> putStrLn $ "\n   \ESC[1;31mErro ao salvar high scores: " ++ show e ++ "\ESC[0m"
        Right _ -> return ()

-- | Carrega os high scores do arquivo
carregarHighScores :: ShowJ -> IO ShowJ
carregarHighScores estado = do
    existe <- doesFileExist arquivoHighScores
    if not existe
        then return estado -- Nenhum arquivo, mantém scores vazios
        else do
            resultado <- try (readFile arquivoHighScores) :: IO (Either SomeException String)
            case resultado of
                Left _ -> return estado -- Erro na leitura, mantém scores vazios
                Right conteudo -> do
                    let scoresCarregados = catMaybes $ map (readMaybe :: String -> Maybe HighScore) (lines conteudo)
                    return estado { highScores = take 10 $ sortOn (negate . pontuacaoFinal) scoresCarregados }

-- | Exibe os high scores
exibirHighScores :: ShowJ -> IO ShowJ
exibirHighScores estado = do
    limparTela
    exibirTitulo "HIGH SCORES"
    let scores = take 10 $ sortOn (negate . pontuacaoFinal) (highScores estado)
    if null scores
        then mensagemInfo "Ainda não há recordes registrados."
        else do
            putStrLn "   Pos. | Nome                 | Pontos | Prêmio"
            putStrLn "   --------------------------------------------------"
            mapM_ (imprimirScore) (zip [1..] scores)
    esperarEnter "Pressione Enter para voltar ao menu."
    return estado

-- | Imprime uma linha de high score formatada usando Text.Printf.printf
imprimirScore :: (Int, HighScore) -> IO ()
imprimirScore (pos, score) = printf "   %2d. | %-20s | %6d | R$%7d\n" pos (nomeJogador score) (pontuacaoFinal score) (premioFinal score)

-- | Registra um novo high score se necessário, usando o nome do jogador atual
registrarHighScore :: ShowJ -> IO ShowJ
registrarHighScore estado = do
    let pontuacaoAtual = pontuacao estado
    let premioAtual = premio estado
    let nomeAtual = fromMaybe "Anônimo" (nomeJogadorAtual estado) -- Usa o nome armazenado
    let pioresScores = take 10 $ sortOn pontuacaoFinal (highScores estado)

    -- Verifica se a pontuação atual qualifica para o Top 10
    if length (highScores estado) < 10 || null pioresScores || pontuacaoAtual > pontuacaoFinal (head pioresScores)
        then do
            limparTela
            exibirTitulo "NOVO RECORDE!"
            mensagemInfo $ "Sua pontuação de " ++ show pontuacaoAtual ++ " (Prêmio: R$" ++ show premioAtual ++ ") entrou para o Top 10!"
            let novoScore = HighScore nomeAtual pontuacaoAtual premioAtual
            let scoresAtualizados = take 10 $ sortOn (negate . pontuacaoFinal) (novoScore : highScores estado)
            let estadoAtualizado = estado { highScores = scoresAtualizados, nomeJogadorAtual = Nothing } -- Reseta o nome do jogador atual
            salvarHighScores estadoAtualizado -- Salva imediatamente
            esperarEnter "Recorde registrado! Pressione Enter para continuar."
            return estadoAtualizado
        else do
            -- Mesmo que não entre no Top 10, o jogo acabou, então reseta o nome
            esperarEnter "Fim de jogo! Pressione Enter para voltar ao menu."
            return estado { nomeJogadorAtual = Nothing }

