{-# language OverloadedStrings #-}
{-# language DeriveAnyClass #-}
{-# language DeriveGeneric #-}
module Main where

import Rubix
import Data.Aeson (ToJSON, FromJSON)
import GHC.Generics (Generic)
import qualified Data.Text as DT
import qualified Network.Wai as NW

data Message = Message 
  {
    message :: DT.Text
  } deriving (Generic, ToJSON, FromJSON)

rubixMessage :: Message
rubixMessage = Message{message="Hello RubiX!!!"}

-- Define a response handler
rubixHandler :: Handler NW.Response
rubixHandler = do
  let res = toResponse $ Json rubixMessage
  return res

-- Start the server
main :: IO ()
main = execute rubixHandler
