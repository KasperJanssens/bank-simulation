module UtilSpec where

import Test.Hspec
import Util

spec :: Spec
spec = describe "Accumulate should work correctly" $ do
        it "Empty list means max and average zero" $ do
          accumulate [] `shouldBe` (0, 0)