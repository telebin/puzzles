
gps :: Int -> [Double] -> Int
gps s = floor . (/ fromIntegral s) . (* 3600) . maximum . (0 :) . (\xs -> map (uncurry $ flip (-)) $ zip xs $ tail xs)

main = print $ gps 15 [0.0,0.19,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25]

