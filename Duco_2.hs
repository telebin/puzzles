module Main (main) where

data Tree = Empty | Node Int Tree Tree

findLongestUnique :: Tree -> [Int] -> Int
findLongestUnique Empty values = length values
findLongestUnique (Node x l r) values
    | x `elem` values = length values
    | otherwise = max (findLongestUnique l (x:values)) (findLongestUnique r (x:values))

findLongestUniqueTCO :: Tree -> Int -> [(Tree, Int, [Int])] -> Int -> [Int] -> Int
findLongestUniqueTCO Empty _ [] maxo _ = maxo
findLongestUniqueTCO Empty _ ((nnode, ndepth, nvals):rest) maxo values = findLongestUniqueTCO nnode ndepth rest maxo nvals
findLongestUniqueTCO (Node x l r) depth toVisit maxo values
    | x `elem` values =
        if null toVisit then maxo
        else let (nnode, ndepth, nvals) = head toVisit in findLongestUniqueTCO nnode ndepth (tail toVisit) maxo nvals
    | otherwise = findLongestUniqueTCO l (depth + 1) ((r, depth + 1, x:values):toVisit) (max (depth + 1) maxo) (x:values)
findLUTCO t = findLongestUniqueTCO Empty 0 [(t, 0, [])] 0 []

a = Node 1 (Node 2 (Node 1 Empty Empty) (Node 2 Empty Empty)) (Node 3 (Node 2 Empty Empty) (Node 1 Empty Empty))
b = Node 1 (Node 2 (Node 1 (Node 4 Empty Empty) Empty) (Node 3 Empty (Node 4 Empty Empty))) (Node 3 (Node 2 Empty Empty) (Node 1 Empty (Node 10 (Node 1 Empty Empty) Empty)))
main = do
  print $ findLongestUnique a []
  print $ findLongestUnique b []
  print $ findLUTCO a
  print $ findLUTCO b
