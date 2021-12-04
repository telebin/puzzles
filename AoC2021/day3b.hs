module Main where

import Data.List (transpose, partition)

numberize :: [Int] -> Int
numberize = fst . foldr (\bit (i, exp) -> (i + bit * exp, exp * 2)) (0, 1)

mostCommonBits = map ((\(o,z) -> signum $ signum ((length o - length z) * 2 + 1) + 1) . partition (== 1)) . transpose 

go (i:[]) _   _  = i
go ints   pos fn = go (filter (\i -> i !! pos `fn` mostCommonBit) ints) (pos + 1) fn
  where
    mostCommonBit = mostCommonBits ints !! pos

main = do
    contents <- readFile "day3input.txt"
    let ints = map (map (\c -> if c == '1' then 1 else 0)) $ lines contents
    print $ numberize (go ints 0 (==)) * numberize (go ints 0 (/=))

