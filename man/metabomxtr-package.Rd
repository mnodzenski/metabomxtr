\name{metabomxtr-package}
\alias{metabomxtr-package}
\alias{metabomxtr}
\docType{package}
\title{
A package to run mixture models on truncated normal or lognormal data 
}
\description{
The functions in this package return optimized parameter estimates and negative log-likelihoods for mixture models of truncated normal or lognormal data. 
}
\details{
\tabular{ll}{
Package: \tab metabomxtr\cr
Type: \tab Package\cr
Version: \tab 1.7.1\cr
Date: \tab 2016-06-06\cr
License: \tab GPL-2\cr
}
The function mxtrmodLL calculates the negative log-likelihood of mixture models. The function mxtrmodstart returns starting parameter estimates to be used when optimizing the mixture model parameters. The function mxtrmod returns optimized mixture model parameter estimates and the negative log-likelihood of the model. The function mxtrmodLRT performs likelihood ratio tests of full vs. reduced mixture models. The function mixnorm performs per-metabolite batch normalization using a mixture model with batch-specific thresholds and run order correction if desired.
}
\author{
Michael Nodzenski, Anna Reisetter, Denise Scholtens

Maintainer: Michael Nodzenski <michael.nodzenski@northwestern.edu>
}
\references{
Moulton LH, Halsey NA. A mixture model with detection limits for regression analyses of antibody response to vaccine. Biometrics. 1995 Dec;51(4):1570-8.
}

\keyword{ package }
\examples{
###Run mixture model analyses

#Create sample data
set.seed(123)
yvar<-rlnorm(200)
these<-sample(1:100,20)
yvar[these]<-NA
logyvar<-log(yvar)
y2var<-rlnorm(200)
those<-sample(1:200,25)
y2var[those]<-NA
logy2var<-log(y2var)
pred1<-sample(0:1,200,replace=TRUE)
pred2<-sample(1:10,200,replace=TRUE)
pred3<-sample(0:1,200,replace=TRUE)
pred3miss<-sample(1:200,50)
pred3[pred3miss]<-NA
testdata<-data.frame(cbind(yvar,y2var,logyvar,logy2var,pred1,pred2,pred3))

#Get the names of the response variables 
ynames<-names(testdata)[3:4]

#Run a full mixture model on each response variable 
fullMod<-~pred1+pred2+pred3|pred1+pred2+pred3
fullModRes<-mxtrmod(ynames=ynames,mxtrModel=fullMod,data=testdata)
fullModRes

#Run a reduced mixture model on each response variable
redMod<-~pred2|pred2
redModRes<-mxtrmod(ynames=ynames,mxtrModel=redMod,data=testdata,fullModel=fullMod)
redModRes

#Compare models using likelihood ratio test
mxtrmodLRT(fullModRes,redModRes)

###Perform mixture model normalization

#load control data set 
data(euMetabCData)

#load experimental data 
data(euMetabData)

#specify target metabolites
ynames <- c("betahydroxybutyrate","pyruvic_acid","malonic_acid","aspartic_acid")

#run mixture model normalization 
euMetabNorm <- mixnorm(ynames,
                        batch="batch",
                        mxtrModel=~pheno+batch|pheno+batch,
                        batchTvals=c(10.76,11.51,11.36,10.31,11.90),
                        cData=euMetabCData,
                        data=euMetabData)

}

