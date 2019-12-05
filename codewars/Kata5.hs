getMiddle :: String -> String
getMiddle s = take (2 - (mod sLen 2)) $ drop (ceiling (fromIntegral sLen / 2 - 1)) s
  where sLen = length s

main = print $ getMiddle "testing"

