library(rootSolve)
rm(list = ls())

# Create a random metapop structure
set.seed(1)
n = 25
r = 0.25
XY = cbind(runif(n), runif(n))

distMat = as.matrix(dist(XY, method = 'euclidean', upper = T, diag = T))
adjMat = matrix(0, nr = n, nc = n)
adjMat[distMat < r] = 1
diag(adjMat) = 0

# Plot the random metapop
dev.new(height = 11, width = 12)
par(mar=c(5,6,2,1))
plot(XY[,1],XY[,2],xlab = "X", ylab = "Y",cex.lab = 1.5,cex=2,cex.axis = 1.25,pch=21)
adjVec = stack(as.data.frame(adjMat))[,1]
XX = expand.grid(XY[,1],XY[,1])
YY = expand.grid(XY[,2],XY[,2])
XX = subset(XX,adjVec==1)
YY = subset(YY,adjVec==1)
arrows(x0 = XX[,1],x1=XX[,2],y0 = YY[,1], y1 = YY[,2], length = 0,lwd = 0.1, col = "grey")

# Model to solve
Levins = function(p,adjMat,c,e,d) {

	# Colonization rate
	C = p%*%(c*adjMat)

	# Destroyed habitats have a 0 colonization rate
	C[d==1] = 0

	# Difference between candidate p and the solution 
	px = C/(C + e) - p

	return(px)
}

get_px = function(adjMat,c,e,d) {

	# Function to optimize
	p_function = function(p) Levins(p,adjMat,c,e,d)

	# Initial conditions
	Start = numeric(n) + 1 - e/c 

	# Extract roots
	multiroot(p_function, start = Start, positive=TRUE)[[1]]
}

# Run an example
d = numeric(n)
d[1:5] = 1
eq_px = get_px(adjMat,c=0.5,e=0.1,d=d)

RK = rank(eq_px)
col = heat.colors(n = n)
vec.col = numeric(n)
for(i in 1:n) vec.col[i] = col[RK[i]]
vec.col[d==1] = "black"

points(XY[,1],XY[,2],pch=21,bg=vec.col,cex=2)

# dev.copy2pdf(file = "spatial_network.pdf")

#=======================


# Function to generate random candidates
s_fn = function(d) {

	# Vector of patch positions
	id = c(1:length(d)) 

	# Pick one destroyed patch at random
	x1 = sample(x=id[d==1],size=1)

	# Pick one residual patch at random 
	x2 = sample(x=id[d==0],size=1)	

	# Swap they status
	d[c(x1,x2)] = d[c(x2,x1)]

	return(d)
}

# Function to compute value to optimize
h_fn = function(adjMat,c,e,d) mean(get_px(adjMat,c,e,d)[d==0])

# SA algorithm
SA = function(adjMat,c,e,d0,T,T_drop,ncycles) {

	hist = matrix(nr = ncycles, nc = 3)

	# Evaluate starting conditions
	h0 = h_fn(adjMat,c,e,d0)

	# Loop for ncycles 
	for(step in 1:ncycles) {

		# Draw candidate patches to destroy
		d1 = s_fn(d0)

		# Evaluate function
		h1 = h_fn(adjMat,c,e,d1)

		# Compute difference
		diff = h1 - h0

		# Take a decision
		# Accept proposition if it improves the criterion
		if(diff > 0) {
			d0 = d1
			h0 = h1
		}		

		# Accept a bad proposition with a certain probability
		else if(diff < 0) {
			p = exp(diff/T)

			if(runif(1) < p) {
				d0 = d1
				h0 = h1
			}			
		} 

		# Record the result
		hist[step,1] = step
		hist[step,2] = T
		hist[step,3] = h0

		# Update temperature (assuming a linear cooling function)
		T = (1-T_drop)*T
	}
	# Return
	return(list(hist, d0))
}	




# Example

d0 = numeric(n)
d0[1:15] = 1

c = 0.12
e = 0.1
T = 1
T_drop = 0.1
ncycles = 100
test = SA(adjMat,c,e,d0,T,T_drop,ncycles)

#dev.new(width =12, height = 10)
#par(mar = c(5,6,2,1))
#plot(test[[1]][,1],test[[1]][,3], type ="l", xlab = "Cycle", ylab = "Occupancy", lwd = 2, cex.axis = 1.25, cex.lab = 1.5)

df = as.numeric(test[[2]])
eq_px = get_px(adjMat,c,e,d=df)
RK = rank(eq_px)
col = heat.colors(n = n)
vec.col = numeric(n)
for(i in 1:n) vec.col[i] = col[RK[i]]
vec.col[df==1] = "black"
points(XY[,1],XY[,2],pch=21,bg=vec.col,cex=2)


