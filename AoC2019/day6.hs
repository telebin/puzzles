module Main (main) where

import Data.Maybe (fromJust)
import Data.List (find, foldl', (\\))
import Data.List.Split (splitOn)

data Object = Object String String deriving (Show, Eq)

getObjectByName :: String -> [Object] -> Object
getObjectByName name = fromJust . find (\(Object n _) -> n == name)

constructObjects :: [(String, String)] -> [Object]
constructObjects = internal []
  where
    internal :: [Object] -> [(String, String)] -> [Object]
    internal done [] = done
    internal done ((par, name):todo) = internal (Object name par : done) todo

countOrbits :: [Object] -> Int
countOrbits objs = foldl' (\acc o -> acc + countObjOrbits o) 0 objs
  where
    countObjOrbits :: Object -> Int
    countObjOrbits (Object _ "COM") = 1
    countObjOrbits (Object _ pname) = 1 + countObjOrbits (getObjectByName pname objs)

pathToCOM :: Object -> [Object] -> [Object]
pathToCOM (Object _ "COM") _ = []
pathToCOM (Object _ pname) objs = let parent = getObjectByName pname objs in parent : pathToCOM parent objs

part1 = countOrbits
part2 objects = length (youPath \\ sanPath) + length (sanPath \\ youPath)
  where
    youPath = pathToCOM (getObjectByName "YOU" objects) objects
    sanPath = pathToCOM (getObjectByName "SAN" objects) objects

main = do
  input <- getContents
  let objects = (constructObjects . map (\[l, r] -> (l, r)) . map (splitOn ")") . words) input
--  print $ part1 objects
  print $ part2 objects
