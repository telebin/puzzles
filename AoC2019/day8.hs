module Main (main) where

import Data.Function (on)
import Data.List (group, sort, minimumBy, foldl1', intercalate)
import Data.List.Split (chunksOf)

width = 25

part1 input = let min = minZeros input in min !! 1 * min !! 2
  where
    minZeros = minimumBy (compare `on` head) . map (map (length)) . filter (\a -> length a > 1) . map (group . sort) . chunksOf (width * 6)
part2 = foldl1' (zipWith (\upper lower -> if upper == '2' then lower else upper)) . chunksOf (width * 6)

main = do
  input <- getContents
--  print $ part1 input
  putStrLn $ intercalate "\n" $ chunksOf width $ map whiteMapper $ part2 (init input)
  where
    whiteMapper '1' = ' '
    whiteMapper c = c
