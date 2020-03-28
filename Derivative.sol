pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Storage
 * @dev Store & retreive value in a variable
 */
contract Derivative {
    string name;
    string symbol;

    address[] users;
    mapping(address => uint256) shorts;
    mapping(address => uint256) longs;
    uint256 totalShort;
    uint256 totalLong;

    mapping(address => uint256) balances;
    address baseAsset; //0xdac17f958d2ee523a2206206994597c13d831ec7

    uint256 assetPrice;
    address oracleAddress;

    enum DerivativeState { SETTLING, TRADING, ISSUING }
    uint256 timestamp;

    uint256 issuingDuration; //seconds
    uint256 tradingDuration;
    uint256 settlingDuration;

        //modifiers

        //onlyOwner
        modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
            _;
        }

        modifier isSettling { require(this.State == DerivativeState.SETTLING, "Must be settling." );
          _;
        }

        modifier isIssuing { require(this.State == DerivativeState.ISSUING, "Must be issuing." );
          _;
        }

        modifier isTrading { require(this.State == DerivativeState.TRADING , "Must be trading to run this function."); _;  }

        modifier stateEnded { require(this.timeStamp <= block.timeStamp, "State must have completed." )}

      /**
     * @dev Create a new derivative for an asset and range
     * @param {probability, settlementTime,
     */
constructor(bytes[] memory derivativeAssetData) public {
      vaultFee = 100
      oracle = "" //does this need to be created?
      baseAsset = 0xdac17f958d2ee523a2206206994597c13d831ec7
      name = ""
      symbol = ""
      tradingDuration = 1
      issuingDuration = 1
      settlingDuration = 1
  }

function derivativeStateTransition() public {
          let newState := this.State
          switch this.State
            case DerivativeState.ISSUING {
              newState = DerivativeState.TRADING
              this.assetPrice
              this.timeStamp = block.timeStamp + this.tradingDuration
           }

            case DerivativeState.TRADING {
              newState = DerivativeState.SETTLING
              this.timeStamp = block.timeStamp +  this.settlingDuration
            }

            case DerivativeState.SETTLING {
              let isSettled := this.settleAllPositions()
              if (isSettled) {
                newState = DerivativeState.ISSUING
                this.timeStamp = block.timeStamp + this.issuingDuration
              }
            }
}


function receive(address contract, address from, uint256 amount) private external returns (bool) {
  if (contract.transferFrom(from, this, amount)) {
    transferFrom(contract, this, amount)
    return true
  }
  return false
}

function issueDerivative(address purchaser, uint256 amount) public onlyIssuing {
        let amountAsset := amount/this.getPrice()
        this.shorts[user] += amountAsset
        this.userLongs[user] += amountAsset
}

function settleAllPositions() public onlyActive onlyOnEnd (bool) {
    while (this.users.length > 0) {
        user = this.users.pop()
        this.settle(user)
    }
    return true
}

    function settle(address user) private {
        let userLongs := this.longs[user]
        let userShorts := this.shorts[user]
        let change := (userLongs - userShorts)*this.getPrice()
        this.longs[user] = 0
        this.shorts[user] = 0
        this.totalLong -= userLongs
        this.totalShort -= userShorts
        this.balances[user] += change
   }

   function isSafeTransfer(address sender, address receiver, uint256 shorts, uint256 longs) public (bool) {
     if (this.longs[sender] >= longs && this.shorts[sender] >= shorts) {
     senderLongs = this.longs[sender] - longs
     senderShorts = this.shorts[sender] - shorts
     senderExposure = this.calculateExposure(senderLongs, senderShorts, this.getPrice())

     receiverLongs = this.longs[receiver] + longs
     receiverShorts = this.shorts[receiver] + shorts
     receiverExposure = this.calculateExposure(receiverLongs, receiverShorts, this.getPrice())
     return (receiverExposure < this.balances[receiver]) && (senderExposure < this.balances[receiver]) }
     else {
       return false
     }
   }

   function transferFrom(address from, address to, uint256 shorts, uint256 longs) public (bool) {
      if (this.isSafeTransfer(from, to, shorts, longs)) {
        this.longs[sender] -= longs
        this.longs[receiver] += longs
        this.shorts[sender]-= shorts
        this.shorts[receiver] += shorts
        return true
      } else {
        return false
      }
   }

    function getAccountBalance(user) public (uint256) {
        return this.balances[user]
    }

    function accountWithdrawal(uint256 amount) public external returns (bool) {
      if (amount <= this.balances[msg.sender]) {
          this.balances[msg.sender] -= amount
          this.baseAsset.transferFrom(this, msg.sender, amount)
      }
    }

    function accountDeposit(uint256 amount) public returns (bool) {
      receive(this.baseAsset, this, msg.sender, amount)
      this.accounts[] += amount
    }

    function setAccountBalance(address user, uint256 newBalance) {
        this.balances[user] = newBalance
    }

    function updatePrice() public external  {
      oracleTimeStamp = this.oracle.getLatestTimestamp()
      updatedPrice = this.getPrice()
      if (oracleTimeStamp === this.timeStamp) {
        updatedPrice = this.oracle.getLatestAnswer()
      }
      if (oracleTimeStamp > this.timestamp) {
        back = oracleTimeStamp - this.timestamp
        updatedPrice = this.oracle.getPreviousAnswer(back)
      }
      this.setPrice(updatedPrice)
    }

    function setPrice(uint256 newPrice) {
        this.price = newPrice
    }

    function getPrice() public returns (uint256) {
        return this.price
    }

    function updateExposure(address user) public {
        this.exposure[user] = calculateExposure(this.longs[user], this.shorts[user], this.getPrice())
    }

    function calculateExposure(uint256 longs, uint256 shorts, uint256 price) public returns (uint256) {
        return price * abs(shorts - longs)
    }

    function getExposure(address user) public returns (uint256) {
        return calculateExposure(this.longs[user], this.shorts[user], this.getPrice())///
    }
}
