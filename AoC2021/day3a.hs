module Main where

import Data.List (transpose, partition)

numberize :: [Int] -> Int
numberize = fst . foldr (\bit (i, exp) -> (i + bit * exp, exp * 2)) (0, 1)

main = do
    contents <- readFile "day3input.txt"
    let ints = transpose $ map (map (\c -> if c == '1' then 1 else 0)) $ lines contents
        bits = map ((\(o,z) -> signum $ signum (length o - length z) + 1) . partition (== 1)) ints
    print $ numberize bits * numberize (map (1-) bits)

