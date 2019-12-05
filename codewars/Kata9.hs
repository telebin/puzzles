primes :: Integral n => n -> [n]
primes n = filter isPrimeMaybe [100000..100000+n]

fastPow :: Integral n => n -> n -> n -> n
fastPow base exp modulo = fastpow' (base `mod` modulo) exp modulo 1
  where fastpow' b 0 m r = r
        fastpow' b e m r = fastpow' (b * b `mod` m) (e `div` 2) m (if even e then r else (r * b `mod` m))
-- fastPow base 1 m = mod base m
-- fastPow base pow m | even pow = mod ((fastPow base (div pow 2) m) ^ 2) m
--                    | odd  pow = mod ((fastPow base (div (pow-1) 2) m) ^ 2 * base) m

isPrimeMaybe :: Integral a => a -> Bool
isPrimeMaybe n = fastPow a (n-1) n == 1
  where a = n `div` 4 - 1

isPrimeSure :: Integral a => a -> Bool
isPrimeSure n = all (/= 0) $ map (mod n) $ [2..rt]
  where rt = isqrt n

isqrt :: (Integral a) => a -> a
isqrt = floor . sqrt . fromIntegral

main = do
  putStrLn "-----"
  print $ length $ primes 1000000

