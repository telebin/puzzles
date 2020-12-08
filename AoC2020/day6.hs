module Main where

import Data.List

join :: [String] -> [String]
join = snd . foldl reductor ("", [])
  where
    reductor :: (String, [String]) -> String -> (String, [String])
    reductor (cur, result) "" = ("", cur : result)
    reductor (cur, result) el = (cur ++ el, result)

main = do
    contents <- readFile "day6input.txt"
    print $ sum $ map (length . nub) $ join $ lines contents

