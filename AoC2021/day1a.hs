module Main where

import Data.List hiding (group)


main = do
    contents <- readFile "day1input.txt"
    let ints = map read $ words contents
    print $ incdec (head ints) (tail ints) (0,0)
  where
    incdec :: Int -> [Int] -> (Int,Int) -> (Int, Int)
    incdec c (n:rest) (inc,dec) 
      | null rest = (ninc,ndec) 
      | otherwise = incdec n rest (ninc,ndec)
      where
        ninc = if n > c then inc + 1 else inc
        ndec = if n < c then dec + 1 else dec

