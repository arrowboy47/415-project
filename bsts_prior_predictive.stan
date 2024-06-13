
data {
  int<lower=0> N; // number of observations
}

parameters {
  real mu; // level
  real beta; // slope
  real<lower=0> sigma; // observation noise
  real<lower=0> phi; // autoregressive coefficient
  real<lower=0> gamma; // seasonal effect
  real B; // regression coefficient
}

model {
  // Priors
  mu ~ normal(0, 10);
  beta ~ normal(0.5, 1);
  sigma ~ inv_gamma(2.1, 1.1);
  phi ~ normal(0, 0.5);
  gamma ~ normal(0, 1);
  B ~ normal(0, 1);
}

generated quantities {
  vector[N] y_sim;
  y_sim[1] = normal_rng(mu + B, sigma);
  for (n in 2:N) {
    y_sim[n] = normal_rng(mu + beta * n + phi * y_sim[n-1] + gamma * sin(2 * pi() * n / 365) + B, sigma);
  }
}
