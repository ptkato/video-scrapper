module Main where

import FileParser

import Requisitioner
import Scrapper
import Types

import Control.Concurrent
import Control.Monad
import Data.Foldable
import System.Random

import qualified Data.ByteString.Lazy    as LBS
import qualified Data.Text.Lazy          as LT
import qualified Data.Text.Lazy.Encoding as LTE
import qualified Network.Wreq.Session    as WS

main :: IO ()
main = do
    sources <- parseSources ["kabum", "pichau", "terabyteshop"]
    putStrLn "\n" >> mainGo sources

mainGo
    :: [[String]]
    -> IO ()
mainGo fs = do
    forever $ do
        sess <- WS.newSession

        for_ fs $ \retailers ->
            forkIO . for_ retailers $ \source -> do
                let target = targetfy source
                res <- LTE.decodeLatin1 <$> request sess target
                traverse_ putStrLn $ scrapper target res

                pause <- randomRIO (10000000, 20000000)
                threadDelay pause

        threadDelay 900000000
        return ()
