module Main where

import Data.List (transpose, partition)
import qualified Data.List.Split as S

boardWins board = or [rowWins board, rowWins $ transpose board]
  where
    rowWins = or . map (and . map snd)
unmarkedSum :: [[(Int, Bool)]] -> Int
unmarkedSum = sum . map (sum . map fst . filter (not . snd))

part1 :: [Int] -> [[[(Int, Bool)]]] -> Int
part1 (lucky:numbers) boards = goBoard newBoards
  where
    goBoard (board:rest)
      | boardWins board = lucky * unmarkedSum board
      | null rest       = part1 numbers newBoards
      | otherwise       = goBoard rest
    newBoards = map (map (map (\(n,s) -> if n == lucky then (n, True) else (n,s)))) boards

part2 :: [Int] -> [[[(Int, Bool)]]] -> Int
part2 (lucky:numbers) boards 
    | null filteredBoards = lucky * unmarkedSum (head newBoards)
    | otherwise           = part2 numbers filteredBoards
  where
    filteredBoards = filter (not . boardWins) newBoards
    newBoards = map (map (map (\(n,s) -> if n == lucky then (n, True) else (n,s)))) boards

main = do
    contents <- readFile "day4input.txt"
    let (n: b) = lines contents
        numbers = map read (S.splitOn "," n)
        boards  = map (map (map (\s -> (read s :: Int, False)) . words)) $ filter (not . null) $ S.splitWhen (== "") b
    print $ part1 numbers boards
    print $ part2 numbers boards

