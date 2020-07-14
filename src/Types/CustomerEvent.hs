module Types.CustomerEvent where

data CustomerEvent = CustomerEvent {arrivalTime :: Int, timeNeeded :: Int} deriving (Show)