module Main where

import Data.List ((\\), sort)
import Data.List.Split (splitOn)
import Data.Map ((!), fromList)

(∧) :: Eq a => [a] -> [a] -> [a]
(∧) = filter . (\array -> flip elem array)

analyze (patterns, output) = foldl1 ((+) . (*10)) $ map ((digits !) . sort . map (wiring !)) output
  where
    one   = head $ filter ((==2) . length) patterns
    seven = head $ filter ((==3) . length) patterns
    four  = head $ filter ((==4) . length) patterns
    zero  = head $ filter ((==4) . length . (\\ adg)) seg6s
    nine  = head $ filter ((==1) . length . (\\ one) . (\\ adg)) seg6s
    two   = head $ filter ((==1) . length . (\\ nine)) seg5s
    seg5s = filter ((==5) . length) patterns
    seg6s = filter ((==6) . length) patterns
    adg   = foldl1 (∧) seg5s
    dg    = adg \\ [a]
    a     = head $ seven \\ one
    b     = head $ (four \\ one) \\ dg
    c     = head $ one ∧ two
    d     = head $ dg ∧ four
    e     = head $ two \\ nine
    f     = head $ one \\ two
    g     = head $ dg ∧ zero
    wiring= fromList [(a,'a'),(b,'b'),(c,'c'),(d,'d'),(e,'e'),(f,'f'),(g,'g')]
    digits= fromList [("cf",1),("acf",7),("bcdf",4),("acdeg",2),("abdfg",5),("acdfg",3),("abcefg",0),("abdefg",6),("abcdfg",9),("abcdefg",8)]

main :: IO ()
main = do
    content <- readFile "day8input.txt"
    let rights = lines content >>= map length . words . last . splitOn " | "
    print $ length $ filter (flip elem [2,3,4,7]) rights

    let entries = map (analyze . (\(p:out:_) -> (words p, words out)) . splitOn " | ") $ lines content
    print $ sum entries

