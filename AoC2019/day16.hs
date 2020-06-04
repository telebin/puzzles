module Main (main) where
import Data.List (foldl', intercalate, zipWith, repeat)

repeatMulti repCnt array = rep repCnt array
  where rep _ [] = []
        rep 0 (x:xs) = rep repCnt xs
        rep cnt a@(x:xs) = x : rep (cnt - 1) a

explode :: Integral n => n -> [n]
explode = internal []
  where internal arr 0 = arr
        internal arr n = internal (mod n 10 : arr) (div n 10)

implode :: Integral n => [n] -> n
implode = foldl' (\a b -> a * 10 + b) 0

calculatePhase :: [Integer] -> [Integer]
calculatePhase digits = internal [] (length digits)
  where internal result 0 = result
        internal result counter = internal (lastDigit (sum $ zipWith (*) digits basePattern) : result) (counter - 1)
          where basePattern = drop 1 $ cycle $ repeatMulti counter [0, 1, 0, -1]
                lastDigit = (`mod` 10) . abs

times :: Integral i => i -> (a -> a) -> a -> a
times 0 _ input = input
times count f input = times (count - 1) f (f input)

part1 = implode . take 8 . times 100 calculatePhase . explode
part2 input = implode $ take 8 $ drop offset $ times 1 calculatePhase $ take (10000 * length exploded) $ cycle $ exploded
  where exploded = explode input
        offset = implode (take 7 exploded)

main = do
--  print $ part1 80871224585914546619083218645595 == 24176176
--  print $ part1 19617804207202209144916044189917 == 73745418
--  print $ part1 69317163492948606335995924319873 == 52432133
  print $ part2 03036732577212944063491565474664 -- == 84462026
--  print $ part2 02935109699940807407585447034323 -- == 78725270
--  print $ part2 03081770884921959731165446850517 -- == 53553731
--  input <- getContents
--  print $ part1 (read input)

