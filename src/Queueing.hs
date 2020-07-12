module Queueing where

import CustomerEvent
import Data.List as List
import ServedCustomer
import Util

type MaxAndAverageQueueSize = (Int, Int)

data QueueEvent = QueueEvent {inQ :: Int, outQ :: Int} deriving (Show, Eq)

data Queue = Queue {size :: Int, unqueueTimes :: [Int]} deriving (Show, Eq)

emptyQueue :: Queue
emptyQueue = Queue 0 []

calculateQueueEvents :: [ServedCustomer] -> [QueueEvent]
calculateQueueEvents =
  foldl
    ( \queueEvents servedCustomer ->
        let inTime = arrivalTime . customerEvent $ servedCustomer
         in let servTime = servingTime servedCustomer
             in if servTime > inTime
                  then queueEvents ++ [QueueEvent inTime servTime]
                  else queueEvents
    )
    []

handleQueueEvent :: QueueEvent -> Queue -> Queue
handleQueueEvent queueEvent queue =
  let inQEvent = inQ queueEvent
   in let unqueued = List.filter (<= inQEvent) $ unqueueTimes queue
       in let queueSizeAtInQEvent = size queue - length unqueued
           in let unqueueTimesAtInQEvent = unqueueTimes queue \\ unqueued
               in Queue (queueSizeAtInQEvent + 1) (unqueueTimesAtInQEvent ++ [outQ queueEvent])

updateQueueSize :: [Int] -> Queue -> QueueEvent -> ([Int], Queue)
updateQueueSize currentQueueSizes queue queueEvent =
  let newQueue = handleQueueEvent queueEvent queue
   in let newQueueSizes = currentQueueSizes ++ [size newQueue]
       in (newQueueSizes, newQueue)

--Average queue size interpreted as IF there is a queue it will be on average .... It seemed to make more sense as my
--queue is often empty
calculateQueueSizes :: [QueueEvent] -> MaxAndAverageQueueSize
calculateQueueSizes events =
  let (queueSizes, _) = foldl (uncurry updateQueueSize) ([], emptyQueue) events
   in let maxSize = safeMaximum queueSizes
       in let avgQsize = safeAverage queueSizes
           in (maxSize, avgQsize)
