pragma solidity >=0.4.22 <0.7.0;
import "./lib/ABDKMath64x64.sol";


abstract contract PayoutContract {

  function calculateWeights(uint256 initialWeight, uint256 startingAssetPrice, uint256 endingAssetPrice, uint256 startingCollateralPrice, uint256 endingCollateralPrice) public returns (uint256) {
    uint256 normalizedAssetChange = this.normalizedChange(startingAssetPrice, endingAssetPrice);
    uint256 normalizedCollateralChange = this.normalizedChange(startingCollateralPrice, endingCollateralPrice);
    return this.calculateWeight(initialWeight, normalizedAssetChange, normalizedCollateralChange);  //convert Primary vs Complement
  }

  function calculateWeight(uint256 initialWeight, uint256 _normalizedAssetChange, uint256 _normalizedCollateralChange) public returns (uint256) {
    uint256 top = (1 + this.payoutFunction(_normalizedAssetChange)); //convert
    uint256 bottom = (1 + _normalizedCollateralChange); //convert
    int128 ratio = ABDKMath64x64.divu(top, bottom); //convert
    return ABDKMath64x64.mulu(ratio, initialWeight);  //convert
  }

  function normalizedChange(uint256 start, uint256 finish) public returns (uint256) {
    uint256 top = finish - start;
    uint256 bottom = start;//convert
    return uint256(ABDKMath64x64.to128x128(ABDKMath64x64.divu(top, bottom)));
  }

   function payoutFunction(uint256 _normalizedAssetChange) virtual public returns (uint256);

}
