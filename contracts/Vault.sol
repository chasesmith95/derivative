pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "./Oracle.sol";
//import "./DerivativeToken.sol";
import "./PayoutContract.sol";
import "./lib/ABDKMath64x64.sol";
import "@openzeppelin/contracts/deploy-ready/ERC20MinterPauser.sol";
//import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract Vault {
    enum VaultState { SETTLING, TRADING, ISSUING }
    address owner;
    string name;
    string symbol;
    //
    address collateralOracle;
    address assetOracle;
    address payoutContract;
    address collateralToken; //0xdac17f958d2ee523a2206206994597c13d831ec7
    int256 vaultIssuanceFee;

    //uint256 activationTime; //seconds
    //    uint256 preIssuanceDuration;
      //uint256 issuanceDuration;
        //bool isRepeating;


    uint256 issuanceTime;
    uint256 settlementTime;

    address shortToken;
    address longToken;

    uint256 totalCollateral;

    uint256 assetIssuancePrice; //U0
    uint256 collateralIssuancePrice; //S0
    int256 issuanceWeight; //W0

    uint256 assetSettlementPrice; //UT
    uint256 collateralSettlementPrice; //ST
    int256 settlementWeight; //WT

      //modifiers
      modifier onlyOwner { require(msg.sender == owner, "Function can only be run by the owner of this contract.");
          _;
      }

      modifier onlyActivated { require(this.state == VaultState.ACTIVATED, "Must be in the activated state." );
        _;
      }
      modifier notActive { require(this.state != VaultState.ACTIVATED, "Must not be in the activated state." );
        _;
      }
      modifier onlyIssued { require(this.state == VaultState.ISSUED, "Must be in the issued state." );
        _;
      }
      modifier notIssued { require(this.state != VaultState.ISSUED, "Must not be in the issued state." );
        _;
      }
      modifier onlySettled { require(this.state == VaultState.SETTLED , "Must be settled."); _;  }
      modifier notSettled { require(this.state != VaultState.SETTLED , "Must not be settled."); _;  }



    //events
      event VaultActivated(address vault, string name, uint256 creationFee);
      event VaultIssued(address vault, uint256 assetPrice, uint256 collateralPrice, uint256 weight);
      event VaultSettled(address vault, uint256 assetPrice, uint256 collateralPrice, uint256 weight);

      event DerivativeSettled(address account, address contractAddress, uint256 amount, uint256 settlementAmount);
      event DerivativePurchased(address account, uint256 amount, uint256 settlementAmount);


      /**
     * @dev Create a new derivative for an asset and range
     * @param {probability, settlementTime,
     */
constructor(string memory _name, string memory _symbol, address _assetOracle, address _collateralOracle, address _payoutContract, int256 _issuanceWeight, address _collateralToken, uint256 _issuanceTime, uint256 _settlementTime, int256 _vaultIssuanceFee) public {
      owner = msg.sender;
      name = _name;
      symbol = _symbol;
      assetOracle = _assetOracle;
      collateralOracle = _collateralOracle;
      payoutContract = _payoutContract;
      issuanceWeight = _issuanceWeight;
      collateralToken = _collateralToken;
      issuanceTime = _issuanceTime;
      settlementTime = _settlementTime;
      vaultIssuanceFee = _vaultIssuanceFee;
      this.update();
}

  function update() public {
    if (block.timestamp <= this.IssuanceTime) {
      this.activate();
    } else if (block.timestamp <= this.SettlementTime) {
      this.issue();
    } else {
      this.settle();
    }
  }

  function activate() notActive internal {
    this.state = VaultState.ACTIVATED;
    this.longToken = ERC20MinterPauser(this.concat(this.name,"-long"), this.concat(this.symbol,"-l"), new address[](0));
    this.shortToken = ERC20MinterPauser(this.concat(this.name,"-short"), this.concat(this.symbol, "-s"));
    emit VaultActivated(this, this.name, this.symbol, this.issuanceTime);
  }

  function concat(string memory _s1, string memory _s2)
          pure
          internal
          returns(string memory) {
            return string(abi.encodePacked(bytes(_s1), bytes(_s2)));
}

    function purchaseDerivatives(uint256 amount) public onlyActivated {
      this.receiveToken(this.collateralToken, msg.sender, amount);
      uint256 newAmount = this.collectFees(amount);
      this.totalCollateral += newAmount;
      this.shortToken.mint(msg.sender, newAmount);
      this.longToken.mint(msg.sender, newAmount);
      emit DerivativePurchased(msg.sender, amount, newAmount);
    }

    function receiveToken(address contractAddress, address from, uint256 amount) internal {
      require(contractAddress.allowance(from, this) >= amount);
      require(contractAddress.transferFrom(from, this, amount));
    }

    function send(address contractAddress, address recipicient, uint256 amount) internal {
         this.contractAddress.transferFrom(this, recipicient, amount);
    }

  function collectFees(uint256 amount) internal returns (uint256) {
    uint256 fees = this.calculateVaultFees(amount);
    this.accumulatedVaultFees += fees;
    return amount - fees;
  }

  function calculateVaultFees(uint256 amount) public returns (uint256) {
    return ABDKMath64x64.mulu(this.vaultIssuanceFee, amount);
  }

  function withdrawVaultFees(uint256 amount) public onlyOwner {
    require(amount <= this.accumulatedVaultFees);
    this.collateralToken.transferFrom(this, this.owner, amount);
    this.accumulatedVaultFees -= amount;
  }

  function issue() internal notIssued {
    this.state = VaultState.ISSUED;
    this.collateralIssuancePrice = this.fetchCollateralPrice(this.issuanceTime);
    this.assetIssuancePrice = this.fetchAssetPrice(this.issuanceTime);
    emit VaultIssued(this, this.assetIssuancePrice, this.collateralIssuancePrice, this.issuanceWeight);
  }

  function fetchAssetPrice(uint256 timestamp) public  returns (uint256) {
    return this.getPrice(this.assetOracle, timestamp);
  }

  function fetchCollateralPrice(uint256 timeStamp) public returns (uint256) {
    return this.getPrice(this.collateralOracle, timeStamp);
  }

  function fetchPrice(address _oracleAddress, uint256 timestamp) public returns (uint256){
    uint256 price = 0;
    uint256 oracleTimeStamp = _oracleAddress.getLatestTimestamp();
    if (oracleTimeStamp == this.timeStamp) {
      price = _oracleAddress.getLatestAnswer();
    }
    if (oracleTimeStamp > this.timestamp) {
      uint256 back = oracleTimeStamp - this.timestamp;
      price = _oracleAddress.getPreviousAnswer(back);
    }
    return price;
  }

  function settle() notSettled internal {
    this.state = VaultState.SETTLED;
    this.collateralSettlementPrice = this.getCollateralPrice(this.issuanceTime);
    this.assetSettlementPrice = this.getAssetPrice(this.issuanceTime);
    this.settlementWeight = this.calculateSettlementWeight();
    emit VaultSettled(this, this.assetSettlementPrice, this.collateralSettlementPrice, this.settlementWeight);
  }

  function settleAccount() public onlySettled {
    this.settle(this.shortAddress, msg.sender, this.shortAddress.balanceOf(msg.sender));
    this.settle(this.longAddress, msg.sender, this.shortAddress.balanceOf(msg.sender));
  }

  function settle(address contractAddress, address user, uint256 amount) public onlySettled  {
    this.receiveToken(contractAddress, user, amount);
    uint256 settlementAmount = this.getSettlementAmount(contractAddress, amount);
    require(settlementAmount >= this.totalCollateral);
    this.totalCollateral -= settlementAmount;
    this.send(this.collateralToken, user, settlementAmount);
    emit DerivativeSettled(user, contractAddress, amount, settlementAmount);
  }

function getSettlementAmount(address contractAddress, uint256 amount) public onlySettled returns (uint256)  {
  int256 weight = this.getSettlementWeight(contractAddress);
  return ABDKMath64x64.mulu(weight, amount);
}

function getSettlementWeight(address contractAddress) public returns (int256) {
  if (contractAddress == this.longToken) {
    return this.settlementWeight;
  } else {
    return ABDKMath64x64.sub(ABDKMath64x64.fromInt(1), this.settlementWeight);
  }
}

function calculateSettlementWeight() public returns (int256) {
  int256 normalizedAssetChange = this.payoutContract.normalizedChange(this.assetPrice, this.settlementPrice);
  int256 normalizedCollateralChange = this.payoutContract.normalizedChange(this.collateralIssuancePrice, this.collateralSettlementPrice);
  return this.payoutContract.calculateWeight(this.issuanceWeight, normalizedAssetChange, normalizedCollateralChange);
}


}
