module FileParser 
    ( parseSources
    ) where

parseSources :: [String] -> IO [[String]]
parseSources retailers = do
    sources <- traverse (readFile . ("retailers/" ++)) retailers
    return $ map lines sources
