# banking-simulation

## Poisson
Simplified the Poisson distribution based upon [this article](https://preshing.com/20111007/how-to-generate-random-timings-for-a-poisson-process/).
The rewrite goes
```textmate
1 -F(x) <=> e exp(-lambda x)
ln (1 -F(x)) <=> -lambda x
x = - ln(1-F(x))/ lambda

with x between 0 and 1, uniform distribution
```

## Beta distribution
Just took over the formula, noticed there are haskell libraries for it but decided not to use them, too involved for what is needed.

## Tests
A few simple tests

## Strucutre

The `Types` package contains some records with a few functions on them, but not core modules

The `Arrivals` module contains the Poisson distribution to generate random arrivals.

The `WaitTimes` module contains the beta distribution with the possibility to generate wait times. Not sure about the correctness of the implementation, it seems to generate shortish wait times which don't seem fully realistic. Don't really see an issue with it so I assumed this was the objective.

The `Queueing` module keeps track of the queues. There is some issue in there that I can't get ironed out, with the average queue size turning to 0 sometimes, which it should not.

The `Bank` module contains constants and the concept of serving customers

The `MonteCarlo` module does the lightweight monte carlo simulation by having several runs and averaging out over those runs.

The `Report` module is just a wrapper around the report record with a few extras and prettyprinting functionality.