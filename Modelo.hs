module Modelo where

-- | Tipo algébrico para categorias de perguntas
data Categoria = Historia 
               | Ciencias 
               | CulturaPop 
               | Esportes 
               | Videogames 
               | Jogos -- Jogos de tabuleiro, cartas, etc.
               | ConhecimentosGerais 
               deriving (Show, Eq, Read, Enum, Bounded) -- Adicionado Enum e Bounded para facilitar a listagem

-- | Lista de todas as categorias disponíveis (usado em Main.hs)
allCategorias :: [Categoria]
allCategorias = [minBound..maxBound]

-- | Tipo algébrico para perguntas (produto com campos)
data Pergunta = Pergunta
    { texto :: String
    , opcoes :: [String] -- Sempre 4 opções
    , correta :: Int    -- Índice da resposta correta (1-4)
    , categoria :: Categoria
    } deriving (Show, Read) -- Mantém Show e Read para salvar/carregar

-- | Tipo algébrico para ajudas disponíveis
data Ajuda = Pular | Eliminar | Universitarios deriving (Show, Eq, Read)

-- | Tipo para registrar pontuações mais altas
data HighScore = HighScore
    { nomeJogador :: String
    , pontuacaoFinal :: Int
    , premioFinal :: Int
    } deriving (Show, Read)

-- | Tipo abstrato para o estado do jogo
data ShowJ = ShowJ
    { perguntas :: [Pergunta]
    , pontuacao :: Int
    , premio :: Int
    , ajudas :: [Ajuda]
    , respondidas :: [Pergunta] -- Pode ser útil para evitar repetições, mas não usado ativamente agora
    , highScores :: [HighScore]
    , nomeJogadorAtual :: Maybe String -- Adicionado para armazenar o nome do jogador da partida atual
    }

-- | Cria um novo estado do jogo inicial
novoShow :: [Pergunta] -> ShowJ
novoShow ps = ShowJ
    { perguntas = ps
    , pontuacao = 0
    , premio = 0
    , ajudas = [Pular, Eliminar, Universitarios]
    , respondidas = []
    , highScores = [] -- Inicializa high scores vazio
    , nomeJogadorAtual = Nothing -- Inicializa sem nome de jogador
    }

-- | Adiciona uma pergunta ao estado
adicionarPergunta :: ShowJ -> Pergunta -> ShowJ
adicionarPergunta estado p = estado { perguntas = p : perguntas estado }

-- | Remove uma pergunta pelo texto (cuidado com textos duplicados)
removerPergunta :: ShowJ -> String -> ShowJ
removerPergunta estado txt = estado { perguntas = filter ((/= txt) . texto) (perguntas estado) }

-- | Registra uma resposta, atualizando pontuação e prêmio
responderPergunta :: ShowJ -> Pergunta -> Int -> ShowJ
responderPergunta estado p resp =
    if resp == correta p
        then let novaPontuacao = pontuacao estado + 1
             in estado { pontuacao = novaPontuacao
                       , premio = calcularPremio novaPontuacao -- Atualiza prêmio ao acertar
                       , respondidas = p : respondidas estado
                       }
        else estado { respondidas = p : respondidas estado } -- Apenas marca como respondida se errar

-- | Usa uma ajuda, removendo-a do estado
usarAjuda :: ShowJ -> Ajuda -> ShowJ
usarAjuda estado ajuda = estado { ajudas = filter (/= ajuda) (ajudas estado) }

-- | Calcula o prêmio com base na pontuação (número de acertos)
calcularPremio :: Int -> Int
calcularPremio pontos = case pontos of
    0 -> 0
    1 -> 1000
    2 -> 2000
    3 -> 5000
    4 -> 10000
    5 -> 20000
    6 -> 50000
    7 -> 100000
    8 -> 200000
    9 -> 500000
    _ -> 1000000 -- Para 10 ou mais acertos

-- Adiciona um novo high score, mantendo a lista ordenada e limitada (ex: top 10)
-- (A lógica de ordenação e limite será feita em Main ou Logica)
adicionarHighScore :: ShowJ -> HighScore -> ShowJ
adicionarHighScore estado score = estado { highScores = score : highScores estado }



