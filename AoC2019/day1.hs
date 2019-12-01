module Main (main) where

calculateFuel :: (RealFrac f, Integral i) => f -> i
calculateFuel = (+ (-2)) . floor . (/ 3)

calculateFuelForFuel :: (Integral a) => a -> a
calculateFuelForFuel fuel = 
  let
    fuelToAdd = calculateFuel $ fromIntegral fuel
  in
    if fuelToAdd <= 0 then fuel else fuel + calculateFuelForFuel fuelToAdd

main :: IO ()
main = do
  weights <- getContents
  -- print $ sum $ map (calculateFuel . read) $ words weights
  print $ sum $ map (calculateFuelForFuel . calculateFuel . read) $ words weights

