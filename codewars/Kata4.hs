permute :: Int -> [a] -> [a] -> [[a]]
permute max perm [] = if length perm == max then [perm] else []
permute max perm (x:rest)
  | length perm == max = [perm]
  | otherwise = (\a -> (++) $ permute max (a : perm) rest) x $ permute max perm rest

chooseBestSum :: Int -> Int -> [Int] -> Maybe Int
chooseBestSum t k ls
  | length ls < k = Nothing
  | otherwise = Just $ maximum $ filter (<= t) $ map sum $ permute k [] ls

main = do
--  print $ length $ permute 3 [] [1..100]
  let ts = [50, 55, 56, 57, 58]
  print $ chooseBestSum 163 3 ts --(Just 163)
  let ts = [50]
  print $ chooseBestSum 163 3 ts --Nothing
  let ts = [91, 74, 73, 85, 73, 81, 87]
  print $ chooseBestSum 230 3 ts --(Just 228)
  print $ chooseBestSum 331 2 ts --(Just 178)
  print $ chooseBestSum 331 4 ts --(Just 331)

