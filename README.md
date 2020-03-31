# Synthetic Crypto Derivatives
This set of smart contracts facilitates the creation of a mixture of short and long positions for any asset, with a variety of different payout functions.


### Master Contract
The master contract holds the Canonical Payout contracts and Oracle contracts that the derivatives use. Holds address to the Vault Builder Contract.

### Vault Builder
Builds and deploys a Vault contract given the oracle address, the payout contract address, and the time interval.

## Vault
The Vault acts as the facilitator and organizer of derivative contracts, it can also create derivatives, and add them to its list of derivatives.The derivative contract is modeled on the ERC20 contract (with the same functionality). The derivative uses a price oracle to establish pricing.

### Instance Variables
- Name
- Collateral Asset
- Oracle Contract Address
- Payout Contract Address
- Time Interval [preissuance start time, issuance time, settlement time]
- shorts => ERC20 Contract Address
- longs => ERC20 Contract Address

### Public Functions
- constructor()
- issueDerivative()
- settle()
- withdrawCollateral()
- addCollateral()

## Oracle Contract   
The oracle contract is completely responsible for the getting accurate prices.

- constructor()
### Variables
- Name
- Data reference address
- constructor()
### Public Functions
- getLatestAnswer()
- getPreviousAnswer()
- getPreviousTimestamp()
- getLatestTimestamp()


## Payout Contract
The payout contract determines the weighting of the shorts and the longs of the derivative. The only function that is used by the Vault contract, is `calculateWeights()` at the settlement date.

### Public Functions
- constructor()
- calculateWeights()

### Private Functions
- Weight function
- Payout function(s)
