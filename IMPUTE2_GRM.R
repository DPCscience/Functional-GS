#######################################################################################################################################
#                                    Intro on working with big tables using FF:
#
#                                             Dunia - Roberto - et.al
#
#######################################################################################################################################

# create and ff object from a table, in this case IMPUTE2.ready is a Dosage file with individuals as columns and markers as rows
CBSD_Impute2 <- read.table.ffdf(file = "IMPUTE2.ready", header=TRUE, sep="\t", first.rows= 100000, next.rows = 150000, VERBOSE = TRUE)

# Save the ffobject, this might take long and will create a lot of *ff files plus CBSD_ff.ffData and CBSD_ff.RData
# You will always have to setwd to the place where you create the *ff files in order to load the ff object
ffsave(CBSD_Impute2, file = "CBSD_ff")

# Loading the ff object
ffload("CBSD_ff")

# Virtual transpose (vt()) (where <ffobject> is the name of your object, for this example it is "CBSD_Impute2)
tff <- vt(CBSD_Impute2)

# Operations using ff objects
# If you want to do operation into the ffobject just add "[]" after it so for example to calculate the relationship matrix do:
library(rrBLUP)
I2_GRM <- A.mat(CBSD_Impute2[] -1)


#######################################################################################################################################













