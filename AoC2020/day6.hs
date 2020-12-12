module Main where

import Data.List hiding (group)

groupJoined :: [String] -> [String]
groupJoined = snd . foldl reductor ("", [])
  where
    reductor :: (String, [String]) -> String -> (String, [String])
    reductor (cur, result) "" = ("", cur : result)
    reductor (cur, result) el = (cur ++ el, result)

group :: [String] -> [[String]]
group = map (dropWhile (== "")) . groupBy (\_ r -> r /= "")

main = do
    contents <- readFile "day6input.txt"
    print $ sum $ map (length . nub) $ groupJoined $ lines contents ++ [""]
    print $ sum $ map (length . foldl1 intersect) $ group $ lines contents
    --print $ group $ lines contents

