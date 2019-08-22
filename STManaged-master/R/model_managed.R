# Model
## input
 # - temperature (env1)
 # - initial state (y, neighborhood)
 # - parameters for a defined temperature (pars)
## Ouput
 # - dominant state

 model_fm <- function(t, y, params, managInt) {
 	with(as.list(c(t, y, params, managInt)), {

    # managInt (1. plantation, 2. harvest, 3. thinning, 4. enrichement)
		naturalSuccession <- 1 - managInt[1] # plantation
		naturalColonization <- 1 - managInt[4] # enrichement planting
		naturalHarvest <- 1 - managInt[2]

 		# Fraction of empty patches converted into the different states following a disturbance
 		pB <- alphab * (B + M)
 		pT <- alphat * (T + M)
 		pM <- pB * pT
 		pB_ <- pB * (1 - pT)
 		pT_ <- pT * (1 - pB)

 		# Regeneration state
 		R <- 1 - B - T - M

 		# Differential equations describing the dynamics of the state variables
    dBdt <- pB_ * naturalSuccession * R + theta * (1 - thetat) * M - ((betat * (T + M) * naturalColonization) + managInt[4]) * B - ((epsB * naturalHarvest) + managInt[2]) * B
		dTdt <- ((pT_ * naturalSuccession) + managInt[1]) * R + (theta * thetat + managInt[3] * (1 - theta)) * M - betab * (B + M) * T - epsT * T
		dMdt <- pM  * naturalSuccession * R + betab * (B + M) * T + ((betat * (T + M) * naturalColonization) + managInt[4]) * B - (theta * (1 - thetat) + (theta * thetat + managInt[3] * (1 - theta))) * M - epsM * M
 		list(c(dBdt, dTdt, dMdt))
 		})
 	}

  #################################
  # Wrapper to collect parameters for a given set of environmental conditions
  #################################
  logit_reverse <- function(x) exp(x) / (1 + exp(x))

  get_pars <- function(ENV1, ENV2, params, int) {

  	logit_alphab 	<- params["ab0", 1] + params["ab1", 1] * ENV1 + params["ab2", 1] * ENV2 + params["ab3", 1] * ENV1^2 + params["ab4",1]*ENV2^2 + params["ab5",1]*ENV1^3 + params["ab6",1]*ENV2^3
  	logit_alphat 	<- params["at0", 1] + params["at1", 1] * ENV1 + params["at2", 1] * ENV2 + params["at3", 1] * ENV1^2 + params["at4",1]*ENV2^2 + params["at5",1]*ENV1^3 + params["at6",1]*ENV2^3
  	logit_betab 	<- params["bb0", 1] + params["bb1", 1] * ENV1 + params["bb2", 1] * ENV2 + params["bb3", 1] * ENV1^2 + params["bb4",1]*ENV2^2 + params["bb5",1]*ENV1^3 + params["bb6",1]*ENV2^3
  	logit_betat 	<- params["bt0", 1] + params["bt1", 1] * ENV1 + params["bt2", 1] * ENV2 + params["bt3", 1] * ENV1^2 + params["bt4",1]*ENV2^2 + params["bt5",1]*ENV1^3 + params["bt6",1]*ENV2^3
  	logit_theta		<- params["th0", 1] + params["th1", 1] * ENV1 + params["th2", 1] * ENV2 + params["th3", 1] * ENV1^2 + params["th4",1]*ENV2^2 + params["th5",1]*ENV1^3 + params["th6",1]*ENV2^3
  	logit_thetat	<- params["tt0", 1] + params["tt1", 1] * ENV1 + params["tt2", 1] * ENV2 + params["tt3", 1] * ENV1^2 + params["tt4",1]*ENV2^2 + params["tt5",1]*ENV1^3 + params["tt6",1]*ENV2^3
  	logit_epsB 		<- params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3
  	logit_epsT 		<- params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3
  	logit_epsM 		<- params["e0", 1]  + params["e1", 1]  * ENV1 + params["e2", 1]  * ENV2 + params["e3", 1]  * ENV1^2 + params["e4",1] *ENV2^2 + params["e5",1] *ENV1^3 + params["e6",1] *ENV2^3

  	alphab <- 1-(1-logit_reverse(logit_alphab))^int
  	alphat <- 1-(1-logit_reverse(logit_alphat))^int
  	betab  <- 1-(1-logit_reverse(logit_betab))^int
  	betat  <- 1-(1-logit_reverse(logit_betat))^int
  	theta  <- 1-(1-logit_reverse(logit_theta))^int
  	thetat <- 1-(1-logit_reverse(logit_thetat))^int
  	epsB    <- 1-(1-logit_reverse(logit_epsB))^int
  	epsT    <- 1-(1-logit_reverse(logit_epsT))^int
  	epsM   <- 1-(1-logit_reverse(logit_epsM))^int

  	return(c(alphab = alphab, alphat = alphat, betab = betab, betat = betat, theta = theta, thetat = thetat, epsB = epsB, epsT = epsT, epsM = epsM))

  }
