{-# LANGUAGE OverloadedStrings #-}

module Requisitioner 
    ( request
    ) where

import Types

import Control.Lens
import Network.Wreq (defaults, header, responseBody, responseHeaders)
import Network.Wreq.Session
import Network.Wreq.Types

import qualified Data.ByteString.Char8 as BS8
import qualified Data.ByteString.Lazy  as LBS

headers' :: Options
headers' = defaults
    & header "User-Agent"                .~ ["Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101 Firefox/87.0"]
    & header "Accept"                    .~ ["text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"]
    & header "Accept-Language"           .~ ["en-IE,en-AU;q=0.8,en-GB;q=0.7,en;q=0.5,fr-FR;q=0.3,pt-BR;q=0.2"]
    & header "Accept-Encoding"           .~ ["gzip, deflate, br"]
    & header "Connection"                .~ ["keep-alive"]
    & header "Referer"                   .~ ["https://www.google.com/"]
    & header "Upgrade-Insecure-Requests" .~ ["1"]
    & header "Pragma"                    .~ ["no-cache"]
    & header "Cache-Control"             .~ ["no-cache"]
    & header "TE"                        .~ ["Trailers"]

request :: Session -> Target -> IO LBS.ByteString
request sess t = do
    res <- getWith
        (headers' & header "Host" .~ [BS8.pack . show $ _host t]) 
        sess 
        (show t)

    return $ res ^. responseBody
