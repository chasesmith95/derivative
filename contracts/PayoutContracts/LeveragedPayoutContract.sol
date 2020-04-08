pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "../PayoutContract.sol";
import "../lib/ABDKMath64x64.sol";
//import "../PayoutContractFactory.sol";




contract LeveragedPayoutContract is PayoutContract {
    //@param
  uint256 leverage;

  constructor(uint256 assetLeverage) public {
    leverage = assetLeverage;
  }

  function payoutFunction(uint256 normalizedAssetChange) public virtual override returns (uint256) {
    return ABDKMath64x64.mulu(int128(normalizedAssetChange), leverage);
  }

}
