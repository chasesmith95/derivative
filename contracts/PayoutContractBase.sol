

contract PayoutContractBase {

  function calculateWeights(float startingWeight, uint256 startingAssetPrice, uint256 endingAssetPrice, uint256 startingCollateralPrice, uint256 endingCollateralPrice) public returns (float) {
    normalizedAssetChange = this.normalizedChange(startingAssetPrice, endingAssetPrice);
    normalizedCollateralChange this.normalizedChange(startingCollateralPrice, endingCollateralPrice);
    return this.calculateFinalWeight(initialWeight, normalizedAssetChange, normalizedCollateralChange);
  }

  function calculateFinalWeight(uint256 initialWeight, uint256 normalizedAssetChange, uint256 normalizedCollateralChange) public returns (float) {
    return initialWeight * (1 + this.payoutFunction(normalizedAssetChange))/(1+normalizedCollateralChange);
  }

  function normalizedChange(uint256 start, uint256 finish) public returns (float) {
    return (finish-start)/start
  }

  function payoutFunction(float normalizedAssetChange) public returns (float) {
    return normalizedAssetChange;
  }
}
