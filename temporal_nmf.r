
#' nmf
#' 
#' @importFrom cluster pam
#' @export
#'
setMethod(
  'nmf',
  signature(
    x = 'matrix',
    stages = 'factor'
  ),
  function(x, stages, K = 5, beta = 100, gamma = 1, burnin = 100, epochs = 2000){

    eps <- 1e-10

  	n_stages <- nlevels(stages)

  	N <- nrow(x) # number of SNPs
  	M <- table(stages) # number of samples at each stage

  	gt2num <- c('0/0' = 0, '0/1' = 0.5, '1/1' = 1)
    x <- gt2num[x] %>% 
      matrix(nrow = N, ncol = sum(M), dimnames = dimnames(x))

  	X <- lapply(seq_len(n_stages), function(s) x[, stages == levels(stages)[s]])
    for (s in seq_len(n_stages)){
      rownames(X[[s]]) <- rownames(x)
      colnames(X[[s]]) <- colnames(x)[stages == levels(stages)[s]]
    }

  	# initialize the strain panel for each group (each year)
  	U <- lapply(seq_len(n_stages), function(s) runif(N * K) %>% matrix(nrow = N, ncol = K))

  	# initlize the composition matrix for each sample
  	V <- lapply(seq_len(n_stages), function(s) runif(K * M[s]) %>% matrix(nrow = K, ncol = M[s]))

    for (epoch in seq_len(epochs)){

      if (epoch < burnin){
        gamma_current <- 0
      }else{
        gamma_current <- gamma
      }

      for (s in seq_len(n_stages)){

        if (s == n_stages){
          U[[s]] <- U[[s]] * (
            (X[[s]] %*% t(V[[s]]) + 3 * gamma_current * U[[s]]^2 + eps) / 
            (U[[s]] %*% (V[[s]] %*% t(V[[s]])) + 2 * gamma_current * U[[s]]^3 + gamma_current * U[[s]]  + eps)
          )
        }else{
          U[[s]] <- U[[s]] * (
            (X[[s]] %*% t(V[[s]]) + beta * U[[s + 1]] + 3 * gamma_current * U[[s]]^2 + eps) / 
            (U[[s]] %*% (V[[s]] %*% t(V[[s]])) + beta * U[[s]] + 2 * gamma_current * U[[s]]^3 + gamma_current * U[[s]]  + eps)
          )
        }

        V[[s]] <- V[[s]] * (
          (t(U[[s]]) %*% X[[s]] + eps) / 
          (t(U[[s]]) %*% U[[s]] %*% V[[s]] + eps) 
        )

        # scale colSums(V[[s]]) to one
        V[[s]] <- as.matrix(V[[s]] %*% Diagonal(x = 1 / (colSums(V[[s]]) + eps)) )

      }

      loss_reconstruct <- sum(sapply(seq_len(n_stages), function(s) norm(X[[s]] - U[[s]] %*% V[[s]], 'F')^2))
      loss_temporal <- sum(sapply(seq_len(n_stages - 1), function(s) norm(U[[s]] - U[[s + 1]], 'F')^2))
      loss_binary <- sum(sapply(seq_len(n_stages), function(s) norm(U[[s]]^2 - U[[s]], 'F')^2))

      if (epoch %% 100 == 0){
        sprintf(
          'iter=%4.d/%4.d | gamm=%.3f | reconst=%13.7f | temporal=%13.7f | binary=%13.7f | total=%13.7f\n', 
          epoch,
          epochs, 
          gamma_current,
          loss_reconstruct,
          beta * loss_temporal,
          gamma_current * loss_binary,
          loss_reconstruct + beta * loss_temporal + gamma_current * loss_binary
        ) %>% message()
      }
    }

    for (s in seq_len(n_stages)){
      rownames(U[[s]]) <- rownames(x)
    }

    for (s in seq_len(n_stages)){
      colnames(V[[s]]) <- colnames(X[[s]])
    }

    new('temporalNMF',
      X = X,
      U = U,
      V = V,
      stages = stages,
      K = K
    )
  }
) # nmf
