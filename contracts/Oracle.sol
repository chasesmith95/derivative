pragma solidity >=0.4.22 <0.7.0;
//pragma solidity ^0.4.2;
import "@chainlink/contracts/src/v0.6/dev/AggregatorProxy.sol";

contract OracleFactory {
  function makeOracle(string name, string symbol, address referenceDataAddress) public returns (address) {
    return new Oracle(name, symbol, referenceDataAddress);
  }
}

contract Oracle {
  string name;
  string symbol;
  AggregatorInterface internal ref;

  constructor(string _name, string _symbol, address _aggregator) public {
    ref = AggregatorProxy(_aggregator);
    name = _name;
    symbol = _symbol;
  }

  function getLatestAnswer() public view returns (int256) {
    return ref.latestAnswer();
  }

  function getLatestTimestamp() public view returns (uint256) {
    return ref.latestTimestamp();
  }

  function getPreviousAnswer(uint256 _back) public view returns (int256) {
    uint256 latest = ref.latestRound();
    require(_back <= latest, "Not enough history");
    return ref.getAnswer(latest - _back);
  }

  function getPreviousTimestamp(uint256 _back) public view returns (uint256) {
    uint256 latest = ref.latestRound();
    require(_back <= latest, "Not enough history");
    return ref.getTimestamp(latest - _back);
  }
}
