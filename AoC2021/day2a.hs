module Main where

type Movement = (String, Int)
type Coords   = (Int, Int)

main = do
    contents <- readFile "day2input.txt"
    let instrs = map (tuplify.words) (lines contents)
        (x, y) = foldl move (0,0) instrs
    print (x * y)
  where
    tuplify :: [String] -> Movement
    tuplify [x,y] = (x, read y)
    move :: Coords -> Movement -> Coords
    move (x, y) ("forward", m) = (x + m, y)
    move (x, y) ("down", m)    = (x, y + m)
    move (x, y) ("up", m)      = (x, y - m)

