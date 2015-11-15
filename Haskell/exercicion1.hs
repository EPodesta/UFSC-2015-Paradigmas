f x = case x of
		0 -> 1
		1 -> 5
		2 -> 2
		_ -> 1

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort lt ++ [x] ++ quicksort ge where {lt = [y | y <- xs, y < x]; ge = [y | y <- xs, y >= x]}