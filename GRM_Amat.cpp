
 
#include <RcppArmadillo.h>
// [[Rcpp::depends("RcppArmadillo")]]

// [[Rcpp::export]]
 arma::mat times(arma::mat A) {
    int n= A.n_rows;
    int k= A.n_cols;
  arma::mat W = arma::mat(A.begin(), A.n_rows, A.n_cols, false) + 1; 
  arma::rowvec freq= arma::mean(W, 0)/2;//freq <- apply(X + 1, 2, function(x) {mean(x)})/2
  arma::rowvec f = 1-freq; 
  arma::rowvec Z = freq % f;
  double X = arma::mean(Z);
  double varA = 2 * X;//var.A <- 2 * mean(freq * (1 - freq))
  arma::mat C; C.ones(n,1);//one <- matrix(1, n, 1)
  arma::mat E = arma::mean(W, 0)/2;E.reshape(k,1);//A<-matrix(freq, m, 1)
  arma::mat fm = C*E.t();//freq.mat
  arma::mat M = A + 1 - 2*fm;
    arma::mat K = (M*M.t())/varA/k;
  //MAF = join_cols(out,out+1);
  return K; // Matrix multiplication, not element-wise
}






