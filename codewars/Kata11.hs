import Data.List (cycle)

rotl n arr = take (length arr) $ drop n $ cycle arr

permute :: Int -> [a] -> [a] -> [[a]]
permute max perm [] = if length perm == max then [perm] else []
permute max perm (x:rest)
  | length perm == max = [perm]
  | otherwise = (\a -> (++) $ permute max (a : perm) rest) x $ permute max perm rest

v = "aabb"


main = do
  print $ permute 4 [] "abba"

