
isSquare :: Integral n => n -> Bool
isSquare n
  | n < 0 = False
  | otherwise = rt == fromIntegral (floor rt)
      where rt = sqrt (fromIntegral n)

main = print $ isSquare 15

