pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Storage
 * @dev Store & retreive value in a variable
 */
 contract VaultBuilder {
   constructor() {}
   function makeVault(address referenceDataAddress) public returns (uint256) {
     let oracle = new Vault(referenceDataAddress);
     return vault
   }
 }

contract Vault {
    enum VaultState { SETTLING, TRADING, ISSUING };

    string name;
    string symbol;
    address oracle;
    address payoutContract;
    address baseCollateralAsset; //0xdac17f958d2ee523a2206206994597c13d831ec7
    uint256 vaultIssuanceFee;

    uint256 activationTime; //seconds
    uint256 issuanceTime;
    uint256 settlementTime;
    uint256 issuanceDuration;
    uint256 preIssuanceDuration;
    bool isRepeating;

    uint256 conversionRatio;
    uint256 totalCollateral;

    uint256 startingPrice; //U0
    uint256 startingCollateralPrice; //S0
    uint256 startingWeight; //W0

    uint256 endingPrice; //UT
    uint256 endingCollateralPrice; //ST
    uint256 finalWeight; //WT



        //modifiers
        modifier onlyOwner { require(msg.sender == this.owner, "Function can only be run by the owner of this contract.");
            _;
        }
        modifier onlyActivated { require(this.state == VaultState.ACTIVATED, "Must be in the activated state." );
          _;
        }
        modifier onlyIssued { require(this.state == VaultState.ISSUED, "Must be in the issued state." );
          _;
        }
        modifier onlySettled { require(this.state == VaultState.SETTLED , "Must be settled."); _;  }
        modifier notSettled { require(this.state != VaultState.SETTLED , "Must not be settled."); _;  }

      /**
     * @dev Create a new derivative for an asset and range
     * @param {probability, settlementTime,
     */
constructor(bytes[] memory derivativeAssetData) public {
      super();
      name = "";
      symbol = "";
      oracle = "" ;//does this need to be created?
      vaultIssuanceFee = 100;
      baseAsset = 0xdac17f958d2ee523a2206206994597c13d831ec7;

      uint256 activationTime; //seconds
      uint256 issuanceTime;
      uint256 settlementTime;
      uint256 duration;
      isRepeating = true;
  }

  function updateVaultState() public {
    oldVault = this.state
    this.setVaultState(this.calculateVaultState())
    if (oldVaultState != this.state) {
      this.vaultStateTransition(this.state)
    }
  }

  function vaultStateTransition(VaultState state) internal {
    if (state == VaultState.ACTIVATED) {
      this.activate();
    } else if (state == VaultState.ISSUED) {
      this.issue();
    } else {
      this.settle();
    }
  }

  function calculateVaultState() public returns (State state) {
    if (block.timestamp <= this.IssuanceTime) {
      this.state = VaultState.ACTIVATED
    } else if (block.timestamp <= this.SettlementTime) {
      this.state = VaultState.ISSUED
    } else {
      this.state = VaultState.SETTLED
    }
    return this.state;
  }

  function setVaultState(VaultState state) internal {
    return this.vaultState = state
  }

  function getVaultState() public view {
    return this.state
  }

  function activate() internal {
    //mint the erc20 contracts
    //
  }

  function purchaseDerivatives(uint256 amount) public onlyCreated {
    this.receiveCollateral(msg.sender, amount);
    issuanceAmount = this.amount * this.conversionRatio;
    this.issueDerivatives(msg.sender, issuanceAmount);
  }

  function issueDerivatives(address purchaser, uint256 amount) internal onlyCreated {
          this.shortToken.mint(purchaser, amount);
          this.longToken.mint(purchaser, amount);
  }

  function receiveCollateral(address sender, uint256 amount) internal {
    this.receive(this.collateralToken, sender, amount);
  }

  function sendCollateral(address recipicient, uint256 amount) {
    this.send(this.collateralToken, recipicient, amount);
  }

  function receive(address contract, address from, uint256 amount) private external {
    require(myToken.allowance(msg.sender, this) > 0);
    uint tokenAmount = myToken.allowance(msg.sender, this);
    require(myToken.transferFrom(msg.sender, this, tokenAmount));
    msg.sender.transfer(getRate(tokenAmount));
    this.totalCollateral += amount;
  }

  function send(address contract, address recipicient, uint256 amount) private external {
       require(amount >= this.totalCollateral);
       this.totalCollateral -= amount;
       this.contract.transferFrom(this, recipicient, amount);
  }

  function issue() {
    uint256 issuanceCollateralPrice = this.getCollateralPrice(this.issuanceTime)
    uint256 issuanceAssetPrice = this.getAssetPrice(this.issuanceTime);
    uint256 issuanceWeight;
    this.setIssuancePrice(issuancePrice);
    this.setIssuanceWeight(issuanceWeight);
  }

  function getIssuanceWeight() public returns (uint256) {
    return this.issuanceWeight
  }

  function setIssuancePrice() internal {
    this.issuancePrice = this.getOraclePrice(this.issuanceTime)
  }

  function getIssuancePrice() hasIssued public {
    return this.issuancePrice
  }

  function settle() {
    settlementCollateralPrice = this.getCollateralPrice(this.issuanceTime)
    settlementAssetPrice = this.getAssetPrice(this.issuanceTime);
    settlementWeight = this.calculateSettlementWeight();  // float
    this.setSettlmentAssetPrice(settlementAssetPrice);
    this.setSettlmentCollateralPrice(settlementCollateralPrice)
    this.setSettlementWeight(settlementWeight);
    if (this.isRepeating) {
      this.repeat();
    }
  }

  function repeat() {
    //create new Vault...
  }

  function setIsRepeating(bool repeats) {
    this.isRepeating = repeats;
  }

  function getIsRepeating() returns (bool) {
    return this.isRepeating;
  }


 function settleAccount() public onlySettled {
   this.settleContract(this.shortAddress, msg.sender);
   this.settleContract(this.longAddress, msg.sender);
 }

 function settleContract(address contract, address user) {
   balance = 0; //get the max approved transfer ...
   this.settleContract(contract, user, balance);
 }

 function settleContract(address contractAddress, address user, uint256 amount) {
   this.receive(contractAddress, user, amount);
   weight = this.getSettlementWeight();
   payoffAmount = this.calculatePayoff(weight, amount);
   this.sendCollateral(user, collateralAmount);
 }

function calculatePayoff(float weight, uint256 amount) returns (uint256) {
  return (amount*weight)/this.conversionRatio;
}

function setSettlementWeight(uint256 weight) internal {
  this.settlementWeight = this.calculateSettlementWeights();
}

function getSettlementWeight() internal {
  return this.settlementWeight
}

function calculateSettlementWeight() public returns (uint256) {
  return this.payoutContract.calculateWeights(this.issuanceWeight, this.issuanceAssetPrice, this.settlementPrice, this.issuanceCollateralPrice, this.settlementCollateralPrice)
}

function setSettlmentPrice(uint256 price) internal {
  this.finalPrice = price
}

function getSettlementPrice() hasSettled public {
  return this.settlementPrice;
}

function fetchAssetPrice(uint256 timestamp) returns (uint256) {
  return this.getPriceFromOracle(this.assetOracle, timestamp);
}

function fetchCollateralPrice(uint256 timeStamp)  returns (uint256) {
  return this.getPriceFromOracle(this.collateralOracle, timestamp);
}

function fetchPriceFromOracle(address oracle, uint256 timestamp) public external returns (uint256){
  price = 0
  oracleTimeStamp = this.oracle.getLatestTimestamp()
  if (oracleTimeStamp === this.timeStamp) {
    updatedPrice = this.oracle.getLatestAnswer()
  }
  if (oracleTimeStamp > this.timestamp) {
    back = oracleTimeStamp - this.timestamp
    updatedPrice = this.oracle.getPreviousAnswer(back)
  }
}
return price;
}

function withdrawVaultFees(uint256 amount) public onlyOwner {
  require(amount <= this.accumulatedVaultFees);
  this.baseAssetContract.transferFrom(this, this.owner, amount)
}
