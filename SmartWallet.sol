pragma solidity ^0.8.0;
import "./Allowance.sol";

contract SharedWallet is Allowance {


    event MoneyReceived(address indexed _beneficiaryy, uint _amount);
    event MoneySent(address indexed _from, uint _amount);

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "You are not allowed XD");
        _;
    }

    function withDrawFunds(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(owner() != msg.sender) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public override {
        revert("Cannot renounce ownserhisp");
    }

    function recieve() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }


}