module Main where

import Bank
import Data.Maybe (fromMaybe)
import Queueing
import Safe (maximumMay)
import Util
import WaitTimes

report :: [(MaxAndAverageWaitTime, MaxAndAverageQueueSize)] -> IO ()
report waitTimeAndQueueSizes = do
  let (timeMax, timeAvg) = accumulate $ fst <$> waitTimeAndQueueSizes
  let (queueMax, queueAvg) = accumulate $ snd <$> waitTimeAndQueueSizes
  print "Total wait time maximum"
  print timeMax
  print "Total wait time Average"
  print timeAvg
  print "Total queue size maximum"
  print queueMax
  print "Total queue size Average"
  print queueAvg

main :: IO ()
main = do
  let openingTimeBank = 8 * 3600
  let numberOfMonteCarloSims = 1000
  waitTimeAndQueueSizes <- runMonteCarlo yellowCustomerWaitTime openingTimeBank numberOfMonteCarloSims
  report waitTimeAndQueueSizes
  waitTimeAndQueueSizes <- runMonteCarlo redCustomerWaitTime openingTimeBank numberOfMonteCarloSims
  report waitTimeAndQueueSizes
  waitTimeAndQueueSizes <- runMonteCarlo blueCustomerWaitTime openingTimeBank numberOfMonteCarloSims
  report waitTimeAndQueueSizes

singleRun :: WaitTimeFunction -> Int -> IO (MaxAndAverageWaitTime, MaxAndAverageQueueSize)
singleRun waitTimeFunction totalOpeningTime = do
  servedCustomers <- bankSession waitTimeFunction totalOpeningTime
  let queueEvents = calculateQueueEvents servedCustomers
  let maxAndAverageQueueSize = calculateQueueSizes queueEvents
  let maxAndAverageWaitTimes = calculateWaitTimes servedCustomers
  return (maxAndAverageWaitTimes, maxAndAverageQueueSize)

runMonteCarlo :: WaitTimeFunction -> Int -> Int -> IO [(MaxAndAverageWaitTime, MaxAndAverageQueueSize)]
runMonteCarlo = runMonteCarlo' []

runMonteCarlo' :: [(MaxAndAverageWaitTime, MaxAndAverageQueueSize)] -> WaitTimeFunction -> Int -> Int -> IO [(MaxAndAverageWaitTime, MaxAndAverageQueueSize)]
runMonteCarlo' experiments _ _ 0 = return experiments
runMonteCarlo' experiments waitTimeFunction totalOpeningTime n = do
  newExperiment <- singleRun waitTimeFunction totalOpeningTime
  runMonteCarlo' (experiments ++ [newExperiment]) waitTimeFunction totalOpeningTime (n -1)
