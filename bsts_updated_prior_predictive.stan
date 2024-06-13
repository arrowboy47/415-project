
data {
  int<lower=0> N; // number of observations
}

parameters {
  real<lower=0> mu; // level
  real<lower=0> beta; // slope
  real<lower=0> sigma; // observation noise
  real<lower=0> phi; // autoregressive coefficient
  real<lower=0> gamma; // seasonal effect
  real B; // regression coefficient
}

model {
  // Priors
  mu ~ normal(350, 200); // Centered around the middle of the observed range
  beta ~ normal(0, 10); // Slope with a reasonable range
  sigma ~ inv_gamma(2.1, 1.1); // Keeping this the same
  phi ~ normal(0, 0.5); // Keeping this the same
  gamma ~ normal(0, 10); // Seasonal effect with a reasonable range
  B ~ normal(0, 10); // Regression coefficient with a reasonable range
}

generated quantities {
  vector[N] y_sim;
  y_sim[1] = normal_rng(mu + B, sigma); // First value for start of train
  for (n in 2:N) {
    y_sim[n] = normal_rng(mu + beta * n + phi * y_sim[n-1] + gamma * sin(2 * pi() * n / 365) + B, sigma);
  }
}
