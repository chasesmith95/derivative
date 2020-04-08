pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "./Oracle.sol";
//import "./DerivativeToken.sol";
import "./PayoutContract.sol";
import "./lib/ABDKMath64x64.sol";
import "@openzeppelin/contracts/deploy-ready/ERC20MinterPauser.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract Vault {
    enum VaultState { SETTLED, ACTIVATED, ISSUED }
    address owner;
    string name;
    string symbol;
    //
    Oracle collateralOracle;
    Oracle assetOracle;
    PayoutContract payoutContract;
    ERC20 collateralToken; //0xdac17f958d2ee523a2206206994597c13d831ec7
    uint256 vaultIssuanceFee;

    //uint256 activationTime; //seconds
    //    uint256 preIssuanceDuration;
      //uint256 issuanceDuration;
        //bool isRepeating;


    uint256 issuanceTime;
    uint256 settlementTime;

    ERC20MinterPauser shortToken;
    ERC20MinterPauser longToken;

    VaultState state;

    uint256 totalCollateral;
    uint256 accumulatedVaultFees;

    uint256 assetIssuancePrice; //U0
    uint256 collateralIssuancePrice; //S0
    uint256 issuanceWeight; //W0

    uint256 assetSettlementPrice; //UT
    uint256 collateralSettlementPrice; //ST
    uint256 settlementWeight; //WT

      //modifiers
      modifier onlyOwner { require(msg.sender == owner, "Function can only be run by the owner of this contract.");
          _;
      }

      modifier onlyActivated { require(state == VaultState.ACTIVATED, "Must be in the activated state." );
        _;
      }
      modifier notActive { require(state != VaultState.ACTIVATED, "Must not be in the activated state." );
        _;
      }
      modifier onlyIssued { require(state == VaultState.ISSUED, "Must be in the issued state." );
        _;
      }
      modifier notIssued { require(state != VaultState.ISSUED, "Must not be in the issued state." );
        _;
      }
      modifier onlySettled { require(state == VaultState.SETTLED , "Must be settled."); _;  }
      modifier notSettled { require(state != VaultState.SETTLED , "Must not be settled."); _;  }



    //events
      event VaultActivated( string name, string symbol, uint256 issuanceTime);
      event VaultIssued(address vault, uint256 settlementTime, uint256 assetPrice, uint256 collateralPrice, uint256 weight);
      event VaultSettled(address vault, uint256 assetPrice, uint256 collateralPrice, uint256 weight);

      event DerivativeSettled(address account, address contractAddress, uint256 amount, uint256 settlementAmount);
      event DerivativePurchased(address account, uint256 amount, uint256 settlementAmount);


constructor(string memory _name, string memory _symbol, Oracle _assetOracle, Oracle _collateralOracle, PayoutContract _payoutContract, uint256 _issuanceWeight, address _collateralToken, uint256 _issuanceTime, uint256 _settlementTime, uint256 _vaultIssuanceFee) public {
      owner = msg.sender;
      name = _name;
      symbol = _symbol;
      assetOracle = _assetOracle;
      collateralOracle = _collateralOracle;
      payoutContract = _payoutContract;
      issuanceWeight = _issuanceWeight;
      collateralToken = ERC20(_collateralToken);
      issuanceTime = _issuanceTime;
      settlementTime = _settlementTime;
      vaultIssuanceFee = _vaultIssuanceFee;
      update();
}

  function update() public {
    if (block.timestamp <= issuanceTime) {
      activate();
    } else if (block.timestamp <= settlementTime) {
      issue();
    } else {
      settle();
    }
  }

  function activate() notActive internal {
    state = VaultState.ACTIVATED;
    longToken = new ERC20MinterPauser(concat(name,"-long"), concat(symbol,"-l"));
    shortToken = new ERC20MinterPauser(concat(name,"-short"), concat(symbol, "-s"));
    emit VaultActivated(name, symbol, issuanceTime);
  }

  function concat(string memory _s1, string memory _s2)
          pure
          internal
          returns(string memory) {
            return string(abi.encodePacked(bytes(_s1), bytes(_s2)));
}

    function purchaseDerivatives(uint256 amount) public onlyActivated {
      this.receiveToken(collateralToken, msg.sender, amount);
      uint256 newAmount = collectFees(amount);
      totalCollateral += newAmount;
      ERC20MinterPauser(shortToken).mint(msg.sender, newAmount);
      ERC20MinterPauser(longToken).mint(msg.sender, newAmount);
      emit DerivativePurchased(msg.sender, amount, newAmount);
    }

    function receiveToken(ERC20 contractAddress, address from, uint256 amount) payable external {
      require(contractAddress.allowance(from, address(this)) >= amount);
      require(contractAddress.transferFrom(from, address(this), amount));
    }

    function sendToken(ERC20 contractAddress, address recipicient, uint256 amount) external {
         contractAddress.transferFrom(address(this), recipicient, amount);
    }

  function collectFees(uint256 amount) internal returns (uint256) {
    uint256 fees = calculateVaultFees(amount);
    accumulatedVaultFees += fees;
    return amount - fees;
  }

  function calculateVaultFees(uint256 amount) public returns (uint256) {
    return ABDKMath64x64.mulu(int128(vaultIssuanceFee), amount);
  }

  function withdrawVaultFees(uint256 amount) public onlyOwner {
    require(amount <= accumulatedVaultFees);
    collateralToken.transferFrom(address(this), owner, amount);
    accumulatedVaultFees -= amount;
  }

  function issue() internal notIssued {
    state = VaultState.ISSUED;
    collateralIssuancePrice = fetchCollateralPrice(issuanceTime);
    assetIssuancePrice = fetchAssetPrice(issuanceTime);
    emit VaultIssued(address(this), settlementTime, assetIssuancePrice, collateralIssuancePrice, issuanceWeight);
  }

  function fetchAssetPrice(uint256 timestamp) public  returns (uint256) {
    return fetchPrice(assetOracle, timestamp);
  }

  function fetchCollateralPrice(uint256 timeStamp) public returns (uint256) {
    return fetchPrice(collateralOracle, timeStamp);
  }

  function fetchPrice(Oracle _oracleAddress, uint256 timestamp) public returns (uint256){
    uint256 price = 0;
    uint256 oracleTimeStamp = _oracleAddress.getLatestTimestamp();
    if (oracleTimeStamp == timestamp) {
      price = uint256(_oracleAddress.getLatestAnswer());
    }
    if (oracleTimeStamp > timestamp) {
      uint256 back = oracleTimeStamp - timestamp;
      price = uint256(_oracleAddress.getPreviousAnswer(back));
    }
    return price;
  }

  function settle() notSettled internal {
    state = VaultState.SETTLED;
    collateralSettlementPrice = fetchCollateralPrice(issuanceTime);
    assetSettlementPrice = fetchAssetPrice(issuanceTime);
    settlementWeight = calculateSettlementWeight();
    emit VaultSettled(address(this), assetSettlementPrice, collateralSettlementPrice, settlementWeight);
  }

  function settleAccount() public onlySettled {
    settle(shortToken, msg.sender, shortToken.balanceOf(msg.sender));
    settle(longToken, msg.sender, longToken.balanceOf(msg.sender));
  }

  function settle(ERC20 contractAddress, address user, uint256 amount) public onlySettled  {
    this.receiveToken(contractAddress, user, amount);
    uint256 settlementAmount = getSettlementAmount(contractAddress, amount);
    require(settlementAmount >= totalCollateral);
    totalCollateral -= settlementAmount;
    this.sendToken(collateralToken, user, settlementAmount);
    emit DerivativeSettled(user, address(contractAddress), amount, settlementAmount);
  }

function getSettlementAmount(ERC20 contractAddress, uint256 amount) public onlySettled returns (uint256)  {
  uint256 weight = getSettlementWeight(contractAddress);
  return uint256(ABDKMath64x64.mulu(int128(weight), amount));
}

function getSettlementWeight(ERC20 contractAddress) public returns (uint256) {
  if (address(contractAddress) == address(longToken)) {
    return settlementWeight;
  } else {
    return uint256(ABDKMath64x64.sub(ABDKMath64x64.fromUInt(1), ABDKMath64x64.fromUInt(settlementWeight)));
  }
}

function calculateSettlementWeight() public returns (uint256) {
  uint256 normalizedAssetChange = payoutContract.normalizedChange(assetSettlementPrice, assetSettlementPrice);
  uint256 normalizedCollateralChange = payoutContract.normalizedChange(collateralIssuancePrice, collateralSettlementPrice);
  return payoutContract.calculateWeight(issuanceWeight, normalizedAssetChange, normalizedCollateralChange);
}


}
