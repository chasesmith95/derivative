pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "./lib/ABDKMath64x64.sol";


//Abstract class
contract PayoutContract {

  function calculateWeights(uint256 initialWeight, uint256 startingAssetPrice, uint256 endingAssetPrice, uint256 startingCollateralPrice, uint256 endingCollateralPrice) public returns (uint256) {
    int256 normalizedAssetChange = this.normalizedChange(startingAssetPrice, endingAssetPrice);
    int256 normalizedCollateralChange = this.normalizedChange(startingCollateralPrice, endingCollateralPrice);
    return this.calculateFinalWeight(initialWeight, normalizedAssetChange, normalizedCollateralChange);  //convert
  }

  function calculateWeight(int256 initialWeight, uint256 normalizedAssetChange, uint256 normalizedCollateralChange) public returns (uint256) {
    int256 top = (1 + this.payoutFunction(normalizedAssetChange)); //convert
    int256 bottom = (1+normalizedCollateralChange); //convert
    int256 ratio = ABDKMath64x64.div(top, bottom); //convert
    return ABDKMath64x64.mul(initialWeight, ratio);  //convert
  }

  function normalizedChange(uint256 start, uint256 finish) public returns (int256) {
    int256 top = finish - start;//convert
    int256 bottom = start;//convert
    return ABDKMath64x64.divi(top, bottom);
  }

  function payoutFunction(int256 normalizedAssetChange) public returns (int256);

}
