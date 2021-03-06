{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Options.Applicative

import Vindinium
import Bot

import Data.String (fromString)
import Data.Text (pack, unpack)

data Cmd = Training Settings (Maybe Int) (Maybe Board)
         | Arena Settings
         deriving (Show, Eq)

cmdSettings :: Cmd -> Settings
cmdSettings (Training s _ _) = s
cmdSettings (Arena s) = s

settings :: Parser Settings
settings = Settings <$> (Key <$> argument (Just . pack) (metavar "KEY"))
                    <*> (fromString <$> strOption (long "url" <> value "http://vindinium.org"))
{-
trainingCmd :: Parser Cmd
trainingCmd = Training <$> settings
                       <*> optional (option (long "turns"))
                       <*> pure Nothing

arenaCmd :: Parser Cmd
arenaCmd = Arena <$> settings

cmd :: Parser Cmd
cmd = subparser
    ( command "training" (info trainingCmd
        ( progDesc "Run bot in training mode" ))
   <> command "arena" (info arenaCmd
        (progDesc "Run bot in arena mode" ))
    )
-}
runCmd :: Cmd -> IO ()
runCmd c  = do
    s <- runVindinium (cmdSettings c) $ do
        case c of
            (Training _ t b) -> playTraining t b bot
            (Arena _)        -> playArena bot

    putStrLn $ "Game finished: " ++ unpack (stateViewUrl s)

main :: IO ()
main = do
    runCmd $ Arena (Settings (Key "54z2frxh") "http://www.vindinium.org")
    --runCmd $ Arena (Settings (Key "k6r8v2e6") "http://www.vindinium.org")
    --runCmd $ Training (Settings (Key "uyiohnnz") "http://www.vindinium.org") (Just 50) Nothing
    {-
    execParser opts >>= runCmd
  where
    opts = info (cmd <**> helper) idm
    -}
