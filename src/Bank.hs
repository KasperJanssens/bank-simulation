module Bank where

import Arrivals
import Control.Monad (foldM)
import CustomerEvent
import Data.Maybe (fromMaybe)
import Safe (lastMay)
import ServedCustomer
import System.Random (randomRIO)
import WaitTimes

serveCustomer :: Int -> CustomerEvent -> (Int, ServedCustomer)
serveCustomer freeTimeSlot customerEvent =
  let serveTime = max (arrivalTime customerEvent) freeTimeSlot
   in let newFreeTimeSlot = serveTime + timeNeeded customerEvent
       in (newFreeTimeSlot, ServedCustomer customerEvent serveTime)

serveCustomers :: [CustomerEvent] -> [ServedCustomer]
serveCustomers =
  snd
    . foldl
      ( \acc elem ->
          let (newFreeTimeSlot, servedCustomer) = serveCustomer (fst acc) elem
           in (newFreeTimeSlot, snd acc ++ [servedCustomer])
      )
      (0, [])

bankSession :: WaitTimeFunction -> Int -> IO [ServedCustomer]
bankSession customerFunction numberOfSecondsWorking =
  do
    arrivals <- randomArrival (> numberOfSecondsWorking) [] arrivalRateAtBank
    let numberOfArrivals = length arrivals
    randomNumbersForWaitTime <- generateNRandomNumbers numberOfArrivals
    let yellowWaitTimes = customerFunction <$> randomNumbersForWaitTime
    let customerEvents = uncurry CustomerEvent <$> zip arrivals yellowWaitTimes
    return $ serveCustomers customerEvents

arrivalRateAtBank :: Double
arrivalRateAtBank = 1 / 200

generateNRandomNumbers :: Int -> IO [Double]
generateNRandomNumbers n =
  foldM
    ( \acc _ -> do
        newRandomNumber <- randomBetween0And1
        return $ newRandomNumber : acc
    )
    []
    [1 .. n]
