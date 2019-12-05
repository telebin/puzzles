explode :: Integral n => n -> [n]
explode 0 = []
explode n = explode (div n 10) ++ [mod n 10]

powerize :: Integral n => n -> [n] -> n
powerize _ [] = 0
powerize pow (x:xs) = x ^ pow + powerize (pow + 1) xs

sumDigPow :: Int -> Int -> [Int]
sumDigPow a b = filter (\num -> (powerize 1 $ explode num) == num) [a..b]

main = print $ sumDigPow 80 150

