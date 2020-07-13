module Report where

import Queueing (MaxAndAverageQueueSize)
import Util
import WaitTimes (MaxAndAverageWaitTime)

data ReportType = Queue | Time | All

data Report = Report {timeMax :: Int, timeAvg :: Int, queueMax :: Int, queueAvg :: Int, customerType :: String}

diffAverageMax :: Report -> Int
diffAverageMax report = queueMax report - queueAvg report

create :: [(MaxAndAverageWaitTime, MaxAndAverageQueueSize)] -> String -> Report
create waitTimeAndQueueSizes customerType = do
  let (timeMax, timeAvg) = accumulate $ fst <$> waitTimeAndQueueSizes
  let (queueMax, queueAvg) = accumulate $ snd <$> waitTimeAndQueueSizes
  Report timeMax timeAvg queueMax queueAvg customerType

showWaitingTimes :: Report -> String
showWaitingTimes report = "Waiting times : average is " ++ show (timeAvg report) ++ " seconds, maximum is " ++ show (timeMax report)++ " seconds"

showQueueSize :: Report -> String
showQueueSize report = "Queue size : average is " ++ show (queueAvg report) ++ ", maximum is " ++ show (queueMax report)

prettyPrint :: ReportType -> Report -> IO ()
prettyPrint Time report = do
  print $ customerType report ++ " customer"
  print . showWaitingTimes $ report
prettyPrint Queue report = do
  print $ customerType report ++ " customer"
  print . showQueueSize $ report
prettyPrint All report = do
  print $ customerType report ++ " customer"
  print . showWaitingTimes $ report
  print . showQueueSize $ report
