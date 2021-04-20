{-# LANGUAGE RecordWildCards #-}
module Types
    ( Target(..)
    , Host(..)
    , targetfy
    ) where

import Data.String
import Text.Parsec

data Host = Kabum | Pichau | Terabyteshop deriving Eq

data Target = Target
    { _host     :: Host
    , _resource :: String
    }

instance Show Host where
    show Kabum        = "https://www.kabum.com.br/"       
    show Pichau       = "https://www.pichau.com.br/"      
    show Terabyteshop = "https://www.terabyteshop.com.br/"

instance Show Target where
    show (Target h r) = show h ++ r

instance IsString Host where
    fromString "https://www.kabum.com.br/"        = Kabum
    fromString "https://www.pichau.com.br/"       = Pichau
    fromString "https://www.terabyteshop.com.br/" = Terabyteshop
    fromString s = error s

instance IsString Target where
    fromString = targetfy

targetfy :: String -> Target
targetfy s = let appendSlash x = x ++ "/" in
    case runParser (sepBy (many $ noneOf "/") (string "/")) () "" s of
        Right xs -> do
            let _host     = fromString . concatMap appendSlash . take 3 $ xs
                _resource = init       . concatMap appendSlash . drop 3 $ xs
            
            Target {..}
        Left x -> error $ show x
    



    