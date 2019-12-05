import Data.Char

uppers = ['A'..'Z']
lowers = ['a'..'z']
alphabetLen = length uppers

rot :: Char -> Int -> Char
rot x i
  | isLetter x = 
    let alphabet = if isUpper x then uppers else lowers 
    in alphabet !! mod (ord x - ord (head alphabet) + i) alphabetLen
  | otherwise = x

movingShift :: String -> Int -> [String]
movingShift xs = code 5 (ceiling (fromIntegral (length xs) / 5.0)) . shift xs
  where
    shift [] _ = []
    shift (x:xs) i = rot x i : (shift xs (i + 1))
    code 1 _ str = [str]
    code p c str = take c str : code (p - 1) c (drop c str)

demovingShift :: [String] -> Int -> String
demovingShift xs i = unshift (concat xs) i
  where
    unshift [] _ = []
    unshift (x:xs) i = rot x (-i) : (unshift xs (i + 1))

u = "I should have known that you would have a perfect answer for me!!!"
v = ["J vltasl rlhr ","zdfog odxr ypw"," atasl rlhr p ","gwkzzyq zntyhv"," lvz wp!!!"]
main = print $ demovingShift v 1

