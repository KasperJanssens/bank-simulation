module MonteCarlo where

import Bank
import Queueing
import WaitTimes

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
