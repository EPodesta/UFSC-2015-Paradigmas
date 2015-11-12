import random
def build(c, r):
	columns = c
	rows = r
	matrix = [[0 for x in range(columns)] for x in range(rows)]
	for x in range(rows):
		for y in range(columns):
			matrix[x][y] = random.randint(0, 1)
			print "In row %d and column %d the value is %d" % (x, y, matrix[x][y])
	return matrix

def run(mx):
	for j in range(len(mx)):
		for i in range(len(mx[j])):
			if j == len(mx)-1:
				mx[i][j] += mx[i][j-1]
			else:
				mx[i][j] += mx[i][j+1]

column = int(raw_input("Inform the number of column: "))
row = int(raw_input("Inform the number of row: "))

mx = build(column, row)
run(mx)
for i in range(len(mx)):
	for j in range(len(mx[i])):
		print "In row %d and column %d the new value is %d" % (i, j, mx[i][j])