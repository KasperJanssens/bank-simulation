module WaitTimes where

import CustomerEvent
import ServedCustomer
import Util

type WaitTimeFunction = Double -> Int

type MaxAndAverageWaitTime = (Int, Int)

calculateWaitTime :: ServedCustomer -> Int
calculateWaitTime servedCustomer =
  servingTime servedCustomer - (arrivalTime . customerEvent) servedCustomer

calculateWaitTimes :: [ServedCustomer] -> MaxAndAverageWaitTime
calculateWaitTimes servedCustomers =
  let waitTimes = fmap calculateWaitTime servedCustomers
   in let averageWaitTime = safeAverage waitTimes
       in let maxWaitTime = safeMaximum waitTimes
           in (maxWaitTime, averageWaitTime)

customerWaitTime :: Int -> Int -> Double -> Int
customerWaitTime alfa beta randomNumber =
  let alfaPart = randomNumber ^^ (alfa - 1)
   in let betaPart = (1 - randomNumber) ^^ (beta - 1)
       in round $ 200.0 * alfaPart * betaPart

yellowCustomerWaitTime :: WaitTimeFunction
yellowCustomerWaitTime = customerWaitTime 2 5

redCustomerWaitTime :: WaitTimeFunction
redCustomerWaitTime = customerWaitTime 2 2

blueCustomerWaitTime :: WaitTimeFunction
blueCustomerWaitTime = customerWaitTime 5 1
