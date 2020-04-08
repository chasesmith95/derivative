# Synthetic Crypto Derivatives
This set of smart contracts facilitates the creation of a mixture of short and long positions for any asset, with a variety of different payout functions.

## Motivation
There exists a problem in the decentralized finance world.
- Centralized
- Inefficient
- Limited by exchanges
- Low liquidity

## Our Solution
Our Synthetic derivatives place all of the control.
- Decentralized  
- Versatile
- Cost Effective
- High liquidity

## Architecture

### Vault Manager
The Vault Manager contract holds the Canonical Payout contracts and Oracle contracts that the derivatives use. Holds address to the Vault Builder Contract. Builds and deploys a Vault contract given the oracle address, the payout contract address, and the time interval.

### Vault
The Vault acts as the facilitator and organizer of derivative contracts, it can also create derivatives, and add them to its list of derivatives.The derivative contract is modeled on the ERC20 contract (with the same functionality). The derivative uses a price oracle to establish pricing.

### Oracle Contracts   
The oracle contract is completely responsible for the getting accurate prices. We utilize the chainlink Aggregator API, but it is not required, as long as the Oracle matches the interface.

### Payout Contracts
The payout contract determines the weighting of the shorts and the longs of the derivative. The only function that is used by the Vault contract, is `calculateWeights()` at the settlement date.
The only function that is changed in the payout contract is the payoff function itself. These payoff functions can take different forms, and act as continuous functions on intervals.
