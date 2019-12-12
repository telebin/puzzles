module Main (main) where
import Data.List
import Data.List.Split (splitOn)
import Data.Maybe
import Data.Function

parseMap :: Num a => String -> [(a, a)]
parseMap = catMaybes . intercalate [] . byRow 0 . splitOn "\n"
  where byRow _ [] = []
        byRow y (row:rows) = byCol 0 y row : byRow (y + 1) rows
        byCol _ _ [] = []
        byCol x y (field:cols) = (if field == '#' then Just (x, y) else Nothing) : byCol (x + 1) y cols

detectionLv coord@(x1, y1) coords = (coord, group $ sort $ map calculateA cleanCoords)
  where cleanCoords = delete (x1, y1) coords
        calculateA coord@(x2, y2) = ((y2 - y1) / (x2 - x1), if x1 == x2 then y1 > y2 else x1 > x2)

part1 input =
  let coords = parseMap input
  in maximum $ map (length . snd) $ map (flip detectionLv coords) coords
part2 input =
  let coords = parseMap input
  in maximumBy (compare `on` length . snd) $ map (flip detectionLv coords) coords

main = do input <- getContents
          print $ part1 test1 == 8
          print $ part1 test2 == 33
          print $ part1 test3 == 35
          print $ part1 test4 == 41
          print $ part1 test5 == 210
--          print $ part1 (init input)
          print $ part2 test5 == 802


test1 = ".#..#\n.....\n#####\n....#\n...##"
test2 = "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####"
test3 = "#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###."
test4 = ".#..#..###\n####.###.#\n....###.#.\n..###.##.#\n##.##.#.#.\n....###..#\n..#.#..#.#\n#..#.#.###\n.##...##.#\n.....#.#.."
test5 = ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##"
