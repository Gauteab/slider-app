{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

import Control.Concurrent
import Control.Lens
import Control.Monad (forever)
import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map)
import qualified Data.Text as T
import qualified Network.WebSockets as WebSockets
import Network.WebSockets (Connection, ServerApp)

--- Model
data Client = Client
  { _value :: Float
  , _connection :: WebSockets.Connection
  }

makeLenses ''Client

data Model = Model
  { _nextId :: Int
  , _clients :: Map Int Client
  }

makeLenses ''Model

initialModel :: Model
initialModel = Model 0 Map.empty

--- Update
setClientValue :: Float -> Int -> Model -> Model
setClientValue newValue cid serverState =
  serverState & (clients . at cid . _Just . value) .~ newValue

averageValues = averageOf (clients . each . value)

averageOf path = uncurry (/) . foldlOf path f (0, 0)
  where
    f (sum, count) value = (sum + value, count + 1)

--- Application
main :: IO ()
main = do
  let address = "127.0.0.1"
      port = 9160
      route = "/"
  putStrLn $ "Listening on " ++ address ++ ":" ++ show port ++ route
  state <- newMVar initialModel
  WebSockets.runServer address port $ server state

server :: MVar Model -> ServerApp
server state pending =
  forever $ do
    connection <- WebSockets.acceptRequest pending
    clientId <- registerClient state connection
    print $ "Connected: " ++ show clientId
    forever $ do
      msg <- WebSockets.receiveData connection
      modifyMVar_ state $ pure . setClientValue (read $ T.unpack msg) clientId
      withMVar state printAverage

registerClient :: MVar Model -> Connection -> IO Int
registerClient state connection = do
  (Model i cs) <- readMVar state
  let newClient = Client 50 connection
      newModel = Model (i + 1) (Map.insert i newClient cs)
  swapMVar state newModel
  pure i

printAverage :: Model -> IO ()
printAverage serverState = do
  let msg = "Average: " ++ show (averageValues serverState)
  putStrLn msg
