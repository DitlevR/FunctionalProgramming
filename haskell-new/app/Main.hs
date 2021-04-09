{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE BlockArguments #-}
module Main where

import Web.Scotty
import Database.MySQL.Base
import qualified System.IO.Streams as Streams


main :: IO ()
main = do
    putStrLn("Starting server at 4711....")
    scotty 4711 (do --ScottyM Monad
        get "/hello" (do --ActionM Monad
             text "Hello World!"
            )

        )

getData ::  =
               conn <- connect
                   defaultConnectInfo {ciUser = "username", ciPassword = "password", ciDatabase = "dbname"}
               (defs, is) <- query_ conn "SELECT * FROM some_table"
               print =<< Streams.toList ismodule Main where

import Lib
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
--import qualified Data.Text.Lazy as L

main :: IO ()
main = do
    putStrLn "Starting server at 4711"
    scotty 4711 $ do --scottyM monad
         get "/em1" $ do
            json em1



em1 :: Employee
em1 = Employee 1 "John" "John@johnmail.com"


data Employee = Employee
    { id :: Integer
    , name :: String
    , email :: String
    } deriving (Show, Generic)

instance ToJSON Employee

