module QueueingSpec where

import Test.Hspec
import Queueing
import Types.ServedCustomer

queueEventConsumptionSpec :: Spec
queueEventConsumptionSpec = describe "queue calculation should work" $ do
  it "always maximum 1" $ do
    let queueEvents = [QueueEvent 0 2, QueueEvent 2 4, QueueEvent 4 6]
    calculateQueueSizes queueEvents `shouldBe` (1, 1)
  it "max overlap means 3" $ do
    let queueEvents = [QueueEvent 0 4, QueueEvent 1 5, QueueEvent 2 6]
    calculateQueueSizes queueEvents `shouldBe` (3, 2)


queueEventGenerationSpec :: Spec
queueEventGenerationSpec = describe "should be able to create correct queue events from served customer events" $ do
  it "No queue events" $ do
    let servedCustomersEvent = [createDummyServedCustomer 0 0, createDummyServedCustomer 4 4, createDummyServedCustomer 8 8]
    let actualQueueEvents = calculateQueueEvents servedCustomersEvent
    actualQueueEvents `shouldBe` []
  it "all queue events" $ do
    let servedCustomersEvent = [createDummyServedCustomer 0 2, createDummyServedCustomer 4 6, createDummyServedCustomer 8 12]
    let actualQueueEvents = calculateQueueEvents servedCustomersEvent
    actualQueueEvents `shouldSatisfy` \l -> length l == 3
  it "some queue events" $ do
    let servedCustomersEvent = [createDummyServedCustomer 0 2, createDummyServedCustomer 2 2, createDummyServedCustomer 4 6, createDummyServedCustomer 4 4, createDummyServedCustomer 8 12]
    let actualQueueEvents = calculateQueueEvents servedCustomersEvent
    actualQueueEvents `shouldSatisfy` \l -> length l == 3