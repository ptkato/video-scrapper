{-# LANGUAGE OverloadedStrings #-}

module Scrapper 
    ( scrapper
    ) where

import Types

import Control.Lens ((^?), (^..), ix, only)
import Text.Taggy
import Text.Taggy.Lens

import qualified Data.Text.Lazy as LT

scrapper :: Target -> LT.Text -> Maybe String
scrapper t@(Target Kabum        _) = kabum        (show t)
scrapper t@(Target Pichau       _) = pichau       (show t)
scrapper t@(Target Terabyteshop _) = terabyteshop (show t)

kabum :: String -> LT.Text -> Maybe String
kabum link page =
    link <$ page ^? html . elements
       . allAttributed (ix "alt" . only "produto_disponivel")

pichau :: String -> LT.Text -> Maybe String
pichau link page =
    link <$ page ^? html . elements
        . allAttributed (ix "class" . only "stock unavailable")

terabyteshop :: String -> LT.Text -> Maybe String
terabyteshop link page =
    link <$ page ^? html . elements 
        . allAttributed (ix "title" . only "Produto dispon\195\173vel no estoque.")
