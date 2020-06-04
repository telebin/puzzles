module Main (main) where

import Data.Function (on)
import Data.List (foldl', intercalate, nub)
import Data.List.Split (splitOn)
import qualified Data.Map as M

type Recipe = (Int, [(Int, String)])
type ReactionMap = M.Map String Recipe
type NeedMap = M.Map String (Int, Int)

parseReactions :: String -> ReactionMap
parseReactions = M.fromList . map parseReaction . map (splitOn " => ") . splitOn "\n"
  where parseReaction :: [String] -> (String, (Int, [(Int, String)]))
        parseReaction [a, b] = let (count, name) = parseOne $ words b in (name, (count, map (parseOne . words) $ splitOn "," a))
        parseOne [count, name] = (read count, name)

ingredients :: ReactionMap -> [(Int, String)]
ingredients = intercalate [] . map (snd . snd) . M.toList


--howMuchOre :: Int -> Recipe -> ReactionMap -> NeedMap -> NeedMap
-- fromList [("A",(10,[(10,"ORE")])),("B",(1,[(1,"ORE")])),("C",(1,[(7,"A"),(1,"B")])),("D",(1,[(7,"A"),(1,"C")])),("E",(1,[(7,"A"),(1,"D")])),("FUEL",(1,[(7,"A"),(1,"E")]))]
-- Recipe: (1,[(7,"A"),(11,"E")])
howMuchOre batch (_, ingrs) rm needMap = foldl' howMuchOre' needMap ingrs
  where howMuchOre' :: NeedMap -> (Int, String) -> NeedMap
        howMuchOre' nm (count, "ORE") = M.adjust (\(u, p) -> (u + count * batch, p + count * batch)) "ORE" nm
        howMuchOre' nm (count, ingredient) = howMuchOre neededBatches (rm M.! ingredient) rm adjustedNm
          where minimalBatch = fst $ rm M.! ingredient -- (10,[(10,"ORE")])
                (used, produced) = nm M.! ingredient
                neededBatches = ceiling (fromIntegral (batch * count - (produced - used)) / fromIntegral minimalBatch) -- 1 batch by 10
                production = neededBatches * minimalBatch -- needed missing As (10)
                adjustedNm = M.insert ingredient (used + count * batch, produced + production) nm


fn cnt nm reactions =
  let newNm = howMuchOre 1 (reactions M.! "FUEL") reactions nm
  in if (fst $ newNm M.! "ORE") > 1000000000000 then
       cnt
     else
       fn (cnt + 1) newNm reactions


part1 input = fst $ (howMuchOre 1 (reactions M.! "FUEL") reactions resources) M.! "ORE"
  where reactions = parseReactions input
        resources = M.fromList $ map (\ingr -> (ingr, (0, 0))) (nub $ map snd $ ingredients reactions)
part2 input = fn 0 resources reactions
  where reactions = parseReactions input
        resources = M.fromList $ map (\ingr -> (ingr, (0, 0))) (nub $ map snd $ ingredients reactions)
-- 1000000000000
-- 13312 ORE-per-FUEL example could produce 82892753 FUEL.
-- 180697 ORE-per-FUEL example could produce 5586022 FUEL.
-- 2210736 ORE-per-FUEL example could produce 460664 FUEL.

main = do
  input <- getContents
  print $ part1 test1
  print $ part1 test2
  print $ part1 test3 == 13312
  print $ part1 test4 == 180697
  print $ part1 test5 == 2210736
  print $ part1 (init input)
  print $ part2 test3
test1 = "10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL"
test2 = "9 ORE => 2 A\n8 ORE => 3 B\n7 ORE => 5 C\n3 A, 4 B => 1 AB\n5 B, 7 C => 1 BC\n4 C, 1 A => 1 CA\n2 AB, 3 BC, 4 CA => 1 FUEL"
test3 = "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"
test4 = "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG\n17 NVRVD, 3 JNWZP => 8 VPVL\n53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL\n22 VJHF, 37 MNCFX => 5 FWMGM\n139 ORE => 4 NVRVD\n144 ORE => 7 JNWZP\n5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC\n5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV\n145 ORE => 6 MNCFX\n1 NVRVD => 8 CXFTF\n1 VJHF, 6 MNCFX => 4 RFSQX\n176 ORE => 6 VJHF"
test5 = "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX"
