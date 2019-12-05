digitsArr :: Integral n => n -> [n]
digitsArr = digits []
  where
    digits :: Integral n => [n] -> n -> [n]
    digits arr 0 = []
    digits arr n = digits arr (div n 10) ++ [mod n 10]

narcissistic :: Integral n => n -> Bool
narcissistic n = n == (sum $ map (^ (length digits)) digits)
  where digits = (digitsArr n)

main = do
  print $ narcissistic 7    
  print $ narcissistic 12   
  print $ narcissistic 370  
  print $ narcissistic 371  
  print $ narcissistic 1634 
