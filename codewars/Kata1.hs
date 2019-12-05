powerize :: Integer -> [Integer] -> Integer
powerize pow [x] = x ^ pow
powerize pow (x:xs) = x ^ pow + powerize (pow + 1) xs

digitsArr :: Integer -> [Integer]
digitsArr = digits []
  where
    digits :: [Integer] -> Integer -> [Integer]
    digits arr 0 = []
    digits arr n = digits arr (div n 10) ++ [mod n 10]

n = 695
p = 2
main = print $ 
  if rem powerized n == 0
  then div powerized n
  else -1
  where
    powerized = powerize p (digitsArr n)
