pragma solidity ^0.4.11;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./ControlCentreInterface.sol";


contract SkeletalToken is Ownable, ERC20 {

    uint256 public constant INITIAL_SUPPLY = 28350000e18;

    event Mint(address indexed to, uint256 amount);
    event MintToggle(bool status);

    // Constant Functions
    function balanceOf(address _owner) public constant returns (uint256) {
        return ControlCentreInterface(owner).balanceOf(_owner);
    }

    function totalSupply() public constant returns (uint256) {
        return ControlCentreInterface(owner).totalSupply();
    }

    function allowance(address _owner, address _spender) public constant returns (uint256) {
        return ControlCentreInterface(owner).allowance(_owner, _spender);
    }

    function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }

    function mintToggle(bool status) public onlyOwner returns (bool) {
        MintToggle(status);
        return true;
    }

    // public functions
    function approve(address _spender, uint256 _value) public returns (bool) {
        ControlCentreInterface(owner).approve(msg.sender, _spender, _value);
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        bytes memory empty;
        return transfer(_to, _value, empty);
    }

    function transfer(address to, uint value, bytes data) public returns (bool) {
        ControlCentreInterface(owner).transfer(msg.sender, to, value, data);
        Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        bytes memory empty;
        return transferFrom(_from, _to, _value, empty);
    }

    function transferFrom(address _from, address _to, uint256 _amount, bytes _data) public returns (bool) {
        ControlCentreInterface(owner).transferFrom(msg.sender, _from, _to, _amount, _data);
        Transfer(_from, _to, _amount);
        return true;
    }

}
