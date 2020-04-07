pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "../PayoutContract.sol";
import "../lib/ABDKMath64x64.sol";
//import "../PayoutContractFactory.sol";




contract LeveragedPayoutContract is PayoutContract {
  uint256 leverage;

  constructor(uint256 assetLeverage) public {
    leverage = assetLeverage;
  }

  function payoutFunction(int256 normalizedAssetChange) public returns (int256) {
    return normalizedAssetChange * leverage; //multiply
  }

}
