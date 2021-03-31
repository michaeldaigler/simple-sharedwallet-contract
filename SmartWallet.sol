pragma solidity ^0.8.0;
import "./SafeMath.sol";
import "./Ownable.sol";


contract Allowance is Ownable {

    using SafeMath for uint;

    event AllowanceChanged(address indexed _forWho, address indexed _fromWho, uint _oldAmount, uint _newAmount);

     mapping(address => uint) public allowance;



    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].add(_amount));
        allowance[_who] = allowance[_who].add(_amount);

    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who].sub(_amount);
    }
}

contract SharedWallet is Allowance {

    using SafeMath for uint;

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