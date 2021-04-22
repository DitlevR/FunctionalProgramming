import Control.Applicative 


--Functor
data Maybe2 a = Just2 a | Nothing2 deriving Show

instance Functor Maybe2 where
  fmap func (Just2 a) = Just2 (func a)
  fmap func Nothing2 = Nothing2

-- We take a function added to a wrapped value
-- Function could be (+3) and added it to (Just2 8)
-- When we fmap this it comes out to Just2 11 
-- fmap (+3) (Just 8)
-- Just 11


half x = if even x
  then Just (x `div` 2)
  else Nothing
 
-- (Just 4) >>= half 
-- Just 2
-- When we use >>= symbol we take the value from a wrapped vaule 
-- And apply it to our function. 


f1 :: Int -> Int -> Int 
f1 x y = x+y 

-- f1 <$> (Just 2) <*> (Just 2) 
-- Just 4
--
-- fmap f1 1 2 
 
