module Main (main) where

import Data.List (intercalate)

foodChain = [
    ("antelope", "grass"),
    ("big-fish", "little-fish"),
    ("bug", "leaves"),
    ("bear", "big-fish"),
    ("bear", "bug"),
    ("bear", "chicken"),
    ("bear", "cow"),
    ("bear", "leaves"),
    ("bear", "sheep"),
    ("chicken", "bug"),
    ("cow", "grass"),
    ("fox", "chicken"),
    ("fox", "sheep"),
    ("giraffe", "leaves"),
    ("lion", "antelope"),
    ("lion", "cow"),
    ("panda", "leaves"),
    ("sheep", "grass")
  ]

split :: String -> [String]
split [] = [""]
split (c:cs) | c == ','  = "" : rest
             | otherwise = (c : head rest) : tail rest
  where rest = split cs

runChain :: [String] -> [String] -> [String] -> [String]
runChain chain l rs@(pred:r)
  | eats last l = runChain ((pred ++ " eats " ++ last l) : chain) [] (init l ++ rs)
  | eats head r = runChain ((pred ++ " eats " ++ head r) : chain) [] (l ++ pred : tail r)
  | null r = intercalate "," rs : chain
  | otherwise = runChain chain (l ++ [pred]) r
  where
    eats :: ([String] -> String) -> [String] -> Bool
    eats _ [] = False
    eats fn xs = fn xs `elem` menu
    menu = [ snd x | x <- foodChain, fst x == pred ]

whoEatsWho :: String -> [String]
whoEatsWho zoo = reverse $ runChain [zoo] [] (split zoo)

main = print $ whoEatsWho "fox,bug,chicken,grass,sheep"
