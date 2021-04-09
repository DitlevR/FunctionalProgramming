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
               print =<< Streams.toList is
