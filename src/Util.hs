module Util where

import Data.Maybe (fromMaybe)
import Safe (maximumMay)

accumulate :: [(Int, Int)] -> (Int, Int)
accumulate maxAndAverages =
  let maxOfMax = safeMaximum $ fst <$> maxAndAverages
   in let averageOfAverages = safeAverage (snd <$> maxAndAverages)
       in (maxOfMax, averageOfAverages)

safeMaximum :: [Int] -> Int
safeMaximum l = fromMaybe 0 $ maximumMay l

safeAverage :: [Int] -> Int
safeAverage [] = 0
safeAverage l = sum l `div` length l