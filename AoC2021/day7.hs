module Main where

import qualified Data.List as L
import qualified Data.List.Split as S

main :: IO ()
main = do
    contents <- readFile "day7input.txt"
    let crabs = map read (S.splitOn "," contents)
        positions = [minimum crabs..maximum crabs]
    print $ head $ L.sortOn snd $ positions >>= \pos -> [(pos, sum $ map (\c -> abs $ c-pos) crabs)]
    print $ head $ L.sortOn snd $ positions >>= \pos -> [(pos, sum $ map (move pos) crabs)]
  where
    move pos c =
        let amount = abs $ c-pos
            avgFuel = (1 + amount) / 2
        in floor $ avgFuel * amount

