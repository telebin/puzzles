module Main (main) where

import Data.List (group)

digits :: Integral i => i -> [i]
digits = digitsInt []
  where
    digitsInt :: Integral i => [i] -> i -> [i]
    digitsInt arr 0 = arr
    digitsInt arr n = digitsInt (n `mod` 10 : arr) (div n 10)

range = [265275..781584]

pairs digits = zip digits $ tail digits

hasAtLeastDouble = any (uncurry (==))
isNonDecreasing = all (uncurry (<=))
hasOnlyDouble = any (== 1) . map length . group . filter (uncurry (==))

part1 = filter hasAtLeastDouble . filter isNonDecreasing . map (pairs . digits)
part2 = filter hasOnlyDouble . filter isNonDecreasing . map (pairs . digits)

main = print $ length $ part2 range
