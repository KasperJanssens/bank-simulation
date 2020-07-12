module Arrivals where

import Data.Maybe (fromMaybe)
import Safe (lastMay)
import System.Random (randomRIO)

arrival :: Double -> Double -> Double
arrival lambda randomNbr = - (log (1 - randomNbr) / lambda)

randomBetween0And1 :: IO Double
randomBetween0And1 = randomRIO (0, 1)

--TODO check whether there isn't something in the libs that suits better, monad-loops should have something.
randomArrival :: (Int -> Bool) -> [Int] -> Double -> IO [Int]
randomArrival stopFunction arrivalTimes lambda = do
  randomNbr <- randomBetween0And1
  let arrivalTimeInInterval = round (arrival lambda randomNbr)
  let lastArrivalTime = fromMaybe 0 $ lastMay arrivalTimes
  let absoluteArrivalTime = lastArrivalTime + arrivalTimeInInterval
  if stopFunction absoluteArrivalTime
    then return arrivalTimes
    else randomArrival stopFunction (arrivalTimes ++ [absoluteArrivalTime]) lambda
