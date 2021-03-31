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