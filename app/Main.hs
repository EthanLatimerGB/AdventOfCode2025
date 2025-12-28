module Main where

import System.Environment
import System.Exit (ExitCode (ExitFailure), exitWith)

data Direction = RightT | LeftT
        deriving (Show, Eq, Ord)

data Instruction = Instruction
        { direction :: Direction
        , distance :: Integer
        }
        deriving (Show, Eq, Ord)

instance Read Direction where
        readsPrec _ s = case s of
                ('L' : rest) -> [(LeftT, rest)]
                ('R' : rest) -> [(RightT, rest)]
                _ -> []

instance Read Instruction where
        readsPrec _ s = do
                (dir, s') <- readsPrec 0 s
                (dist, s'') <- readsPrec 0 s'
                return (Instruction{direction = dir, distance = dist}, s'')

--
-- Functions
--

readTextFile :: FilePath -> IO [String]
readTextFile fileLocation = do
        content <- readFile fileLocation
        return (lines content)

parseInstructions :: [String] -> [Instruction]
parseInstructions = map (\s -> read s :: Instruction)

getFileLocation :: IO [String] -> IO (Maybe String)
getFileLocation args = getFirstElem <$> args
    where
        getFirstElem :: [String] -> Maybe String
        getFirstElem [] = Nothing
        getFirstElem (x : _) = Just x

getFileContents :: IO(Maybe String) -> IO([String])
getFileContents fileLocation = case fileLocation of
        Nothing -> do
                        putStrLn "Error: Enter a input parameter for the file location"
                        exitWith (ExitFailure 2)
                Just l -> do
                        input <- readTextFile l 


--
-- Main
--

main :: IO ()
main = do
        let params = getArgs
        fileLocation <- getFileLocation params
        case fileLocation of
                Nothing -> do
                        putStrLn "Error: Enter a input parameter for the file location"
                        exitWith (ExitFailure 2)
                Just l -> do
                        input <- readTextFile l
                        let instructions = parseInstructions input
                        print instructions
