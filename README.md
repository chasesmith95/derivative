# Synthetic Crypto Derivatives

This set of smart contracts facilitates the creation of a mixture of short and long positions for any asset.

### Oracle Creation
Oracles are used, and can be created from ...


## Vault
The Vault acts as the facilitator and organizer of derivative contracts, it can also create derivatives, and add them to its list of derivatives.

### createDerivative()

### issueDerivative()

### getDerivatives()

### getDerivative()

### addFunds(derivative, amount)

### withdrawFunds(amount)

## Derivative  
The derivative contract is modeled on the ERC20 contract (with the same functionality). The derivative uses a price oracle to establish pricing.

### transfer()

### issueDerivative()


## Usage

### Creating a derivative

```

```

### Adding an account

```

```

### Issuing derivative to an account

```

```

### Trading derivatives

```

```

## Next Steps
Convert to ERC721 NFTs for positions (short, long, interval, and offset) that users hold, to enable positions to be held at a variety of overlapping intervals.
