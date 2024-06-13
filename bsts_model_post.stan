
data {
  int<lower=0> N; // number of observations
  vector[N] y; // observed data
}

parameters {
  real mu; // level
  real beta; // slope
  real<lower=0> sigma; // observation noise
  real<lower=0, upper=1> phi; // autoregressive coefficient
  real gamma; // seasonal effect
  real B; // regression coefficient
}


model {
  // Priors
  mu ~ normal(350, 100); // Centered around the middle of the observed range
  // beta ~ normal(0, 10); // Slope with a reasonable range
  sigma ~ normal(120, 20); // Keeping this the same
  phi ~ beta(2, 2); // Keeping this the same
  // gamma ~ normal(0, 10); // Seasonal effect with a reasonable range
  // B ~ normal(0, 10); // Regression coefficient with a reasonable range

  // Likelihood
  for (n in 2:N) {
    y[n] ~ normal(mu + beta * n + phi * y[n-1] + gamma * sin(2 * pi() * n / 365) + B, sigma);
  }
}

generated quantities {
  vector[N] y_sim;
  y_sim[1] = normal_rng(mu, sigma); // Initial value
  for (n in 2:N) {
    y_sim[n] = normal_rng(mu + beta * n + phi * y_sim[n-1] + gamma * sin(2 * pi() * n / 365) + B, sigma);
  }
}
