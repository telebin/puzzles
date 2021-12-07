module Main where

import qualified Data.List as L
import qualified Data.List.Split as S

type Point = (Int, Int)
type Line = (Point, Point)

expand :: [Line] -> [Point]
expand = foldl1 (++) . map expandLine
  where
   expandLine ((x1, y1), (x2, y2)) = L.unfoldr expandOne (x1, y1)
     where
       expandOne (x, y)
         | x * dx <= x2 * dx && y * dy <= y2 * dy = Just ((x, y), (x+dx, y+dy))
         | otherwise = Nothing
       dx = signum (x2 - x1)
       dy = signum (y2 - y1)

sameX ((x1, _), (x2, _)) = x1 == x2
sameY ((_, y1), (_, y2)) = y1 == y2
diagonal ((x1, y1), (x2, y2)) = abs (x2-x1) == abs (y2-y1)

part1 :: [Line] -> Int
part1 = length . filter ((> 1) . length) . L.group . L.sort . expand . filter (or . sequence [sameX, sameY])

part2 :: [Line] -> Int
part2 = length . filter ((> 1) . length) . L.group . L.sort . expand . filter (or . sequence [sameX, sameY, diagonal])

main = do
    contents <- readFile "day5input.txt"
    let linez = map ((\(s:e:[]) -> (s,e)) . map (read . \v -> "(" ++ v ++ ")") . S.splitOn " -> ") $ lines contents
    print $ part1 linez
    print $ part2 linez --(filter (or . sequence [sameX, sameY, diagonal]) linez :: [Line])


