module Main where

type Movement = (String, Int)
type Coords   = (Int, Int, Int)

main = do
    contents <- readFile "day2input.txt"
    let instrs = map (movementize.words) (lines contents)
        (x, y, _) = foldl move (0,0,0) instrs
    print (x * y)
  where
    movementize :: [String] -> Movement
    movementize [x,y] = (x, read y)
    move :: Coords -> Movement -> Coords
    move (x, y, aim) ("forward", m) = (x + m, y + aim * m, aim)
    move (x, y, aim) ("down", m)    = (x, y, aim + m)
    move (x, y, aim) ("up", m)      = (x, y, aim - m)

