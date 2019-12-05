import qualified Data.List as L

explode :: Integral n => n -> [n]
explode 0 = []
explode n = explode (div n 10) ++ [mod n 10]

implode :: Integral n => [n] -> n
implode = foldl (\a -> \b -> a * 10 + b) 0

rotl n arr = take (length arr) $ drop n $ L.cycle arr

rotArr :: Integer -> [Integer] -> [Integer]
rotArr _ [_] = []
rotArr h xs = implode (h : rotated) : (rotArr newHead (tail rotated))
  where
    rotated = (rotl 1 xs)
    newHead = h * 10 + head rotated

maxRot :: Integer -> Integer
maxRot n = 
  maximum rotations
  where 
    e = explode n
    rotations = implode e : rotArr 0 e

main = do
  print $ maxRot 56789
  print $ maxRot 38458215 --85821534
  print $ maxRot 195881031 --988103115
  print $ maxRot 896219342 --962193428
  print $ maxRot 69418307 --94183076

