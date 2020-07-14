module Types.ServedCustomer where

import Types.CustomerEvent

data ServedCustomer = ServedCustomer {customerEvent :: CustomerEvent, servingTime :: Int} deriving (Show)

createDummyServedCustomer :: Int -> Int -> ServedCustomer
createDummyServedCustomer inQ = ServedCustomer (CustomerEvent inQ 42)