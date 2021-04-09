{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE BlockArguments #-}
module Main where

import qualified Data.ByteString.Lazy as B
import Lib
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
import Data.Aeson.Text (encodeToLazyText)

--import qualified Data.Text.Lazy as L

main :: IO ()
main = do

    jsonFile :: FilePath
    jsonFile = "pizza.json"

    getJSON :: IO B.ByteString
    getJSON = B.readFile jsonFile
    putStrLn "Starting server at 4711"
    scotty 4711 $ do --scottyM monad
         get "/em1" $ do
            json em1




data Employee = Employee
    { id :: Integer
    , name :: String
    , email :: String
    } deriving (Show, Generic)

instance ToJSON Employee


data Department = Department
    { id :: Integer
    , description :: String
    , employee_id :: Integer
    } deriving (Show, Generic)

instance ToJSON Department