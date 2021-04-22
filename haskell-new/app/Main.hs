{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import qualified Data.ByteString.Lazy as B
import Lib
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics
import Data.Aeson.Text (encodeToLazyText)

main :: IO ()
main = do


    putStrLn "Starting server at 4711"
    scotty 4711 $ do --scottyM monad
         get "/em1" $ do
            json em1
         get "/dp1" $ do
            json dp1


em1 :: Employee
em1 = Employee 1 "John" "johnmail@mail.com"
dp1 :: Department
dp1 = Department "1st Floor" "PR"

data Employee = Employee
    { id :: Int
    , name :: String
    , email :: String
    } deriving (Show, Generic)

instance ToJSON Employee
instance FromJSON Employee

data Department = Department
    { location :: String
    , dname :: String
    } deriving (Show, Generic)
instance ToJSON Department
instance FromJSON Department




