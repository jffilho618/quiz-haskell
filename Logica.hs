module Logica where

import Modelo
import System.Random (randomRIO, newStdGen)
import Data.List ((\\), nub)
import System.Random.Shuffle (shuffle')

-- | Busca perguntas por categoria usando compreensão de listas
buscarPorCategoria :: [Pergunta] -> Categoria -> [Pergunta]
buscarPorCategoria ps cat = [p | p <- ps, categoria p == cat]

-- | Lista todas as perguntas usando função de ordem superior (usada em Main)
listarPerguntas :: [Pergunta] -> String
listarPerguntas ps = unlines $ map formatarPerguntaParaLista ps

-- | Formata uma pergunta para exibição na lista (movido de Main para cá)
formatarPerguntaParaLista :: Pergunta -> String
formatarPerguntaParaLista p = 
    "\n\ESC[1;37mQ: " ++ texto p ++ "\ESC[0m" ++
    unlines (zipWith (\i o -> "  " ++ show i ++ ". " ++ o ++ if i == correta p then " \ESC[1;32m(Correta)\ESC[0m" else "") [1..] (opcoes p)) ++
    "  Categoria: " ++ show (categoria p)

-- | Embaralha perguntas usando System.Random.Shuffle
embaralharPerguntas :: [Pergunta] -> IO [Pergunta]
embaralharPerguntas ps = do
    gen <- newStdGen
    return $ shuffle' ps (length ps) gen

-- | Calcula resultado final
calcularResultadoFinal :: ShowJ -> String
calcularResultadoFinal estado =
    "Pontuação Final: " ++ show (pontuacao estado) ++ "/" ++ show (length (perguntas estado)) ++
    "\nPrêmio Final: R$" ++ show (premio estado)

-- | Calcula o prêmio de consolação ao errar
calcularPremioErro :: Int -> Int
calcularPremioErro pontos = calcularPremio (pontos `div` 2) -- Exemplo: metade dos pontos

-- | Elimina duas opções incorretas, retornando as duas que sobram (a correta e uma incorreta)
-- Retorna uma lista de tuplas: [(Índice Original, Texto da Opção)]
eliminarOpcoes :: Pergunta -> IO [(Int, String)]
eliminarOpcoes p = do
    let indices = [1..length (opcoes p)]
    let corretaIdx = correta p
    let incorretasIndices = indices \\ [corretaIdx] -- Usa o operador (\\) corretamente
    
    -- Escolhe aleatoriamente UM índice incorreto para manter
    idxIncorretaManter <- randomRIO (0, length incorretasIndices - 1)
    let incorretaEscolhidaIdx = incorretasIndices !! idxIncorretaManter

    -- Pega os textos das opções correspondentes
    let opcaoCorreta = (corretaIdx, opcoes p !! (corretaIdx - 1))
    let opcaoIncorreta = (incorretaEscolhidaIdx, opcoes p !! (incorretaEscolhidaIdx - 1))

    -- Embaralha as duas opções restantes para não dar dica da ordem
    gen <- newStdGen
    return $ shuffle' [opcaoCorreta, opcaoIncorreta] 2 gen

-- | Simula consulta aos universitários com ~80% de chance de acerto
consultarUniversitarios :: Pergunta -> IO String
consultarUniversitarios p = do
    let corretaIdx = correta p
    let numOpcoes = length (opcoes p)
    let indicesIncorretos = [1..numOpcoes] \\ [corretaIdx]
    
    -- Gera um número entre 1 e 100
    chanceAcerto <- randomRIO (1, 100) :: IO Int
    
    sugestaoFinalIdx <- if chanceAcerto <= 80 -- 80% de chance de sugerir a correta
                        then return corretaIdx
                        else do -- 20% de chance de sugerir uma incorreta aleatória
                            idxIncorretaAleatoria <- randomRIO (0, length indicesIncorretos - 1)
                            return $ indicesIncorretos !! idxIncorretaAleatoria

    let sugestaoTexto = opcoes p !! (sugestaoFinalIdx - 1)
    
    return $ "Os universitários pensam um pouco... e sugerem a opção " ++ show sugestaoFinalIdx ++ ": " ++ sugestaoTexto


