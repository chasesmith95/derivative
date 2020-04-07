/* //pragma solidity >=0.4.22 <0.7.0;
pragma solidity ^0.4.2;
import "../PayoutContract.sol";


contract IntervalPayoutContract is PayoutContract {


  function payoutFunction(float normalizedAssetChange) public returns (fixed) {
    return normalizedAssetChange * leverage;
  }
} */
