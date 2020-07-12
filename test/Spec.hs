import Test.Hspec
import qualified QueueingSpec
import qualified UtilSpec

main :: IO ()
main = hspec $ do
  QueueingSpec.queueEventConsumptionSpec
  QueueingSpec.queueEventGenerationSpec
  UtilSpec.spec
