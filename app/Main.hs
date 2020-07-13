module Main where

import MonteCarlo
import WaitTimes
import qualified Report
import Data.List (sortOn)

main :: IO ()
main = do
  let openingTimeBank = 8 * 3600
  let numberOfSims = 1000
  waitTimeAndQueueSizesYellow <- runMonteCarlo yellowCustomerWaitTime openingTimeBank numberOfSims
  let yellowReport = Report.create waitTimeAndQueueSizesYellow "Yellow"
  Report.prettyPrint Report.Time yellowReport
  print ""
  waitTimeAndQueueSizesRed <- runMonteCarlo redCustomerWaitTime openingTimeBank numberOfSims
  let redReport = Report.create waitTimeAndQueueSizesRed "Red"
  Report.prettyPrint Report.Queue redReport
  print ""
  waitTimeAndQueueSizesBlue <- runMonteCarlo blueCustomerWaitTime openingTimeBank numberOfSims
  let blueReport = Report.create waitTimeAndQueueSizesBlue "Blue"
  let reports = [yellowReport, redReport, blueReport]
  let sortedReports = sortOn Report.diffAverageMax reports
  let minimumDiff = head sortedReports
  print "Customer with lowest difference between average and maximum wait times :"
  Report.prettyPrint Report.All minimumDiff

  return ()
