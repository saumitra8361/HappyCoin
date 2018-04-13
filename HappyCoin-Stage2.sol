pragma solidity ^0.4.8;

contract HappyCoin {
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping (address => uint256)) public allowance;
    
    string public standard = "HappyCoin v1.0";
    string public name;
    string public symbol;
    uint8 public decimal;
    uint256 public totalSupply;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function HappyCoin(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        symbol = tokenSymbol;
        name = tokenName;
        decimal = decimalUnits;
    }
    
    function transfer(address _to, uint256 _value) public {
        if(balanceOf[msg.sender] > _value) {
            if(balanceOf[_to] + _value > balanceOf[_to]) {
                balanceOf[msg.sender] -= _value;
                balanceOf[_to] += _value;
            }
        }
        Transfer(msg.sender,_to,_value);
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(balanceOf[_from] > _value) {
            if(balanceOf[_to] + _value > balanceOf[_to]) {
                if(_value < allowance[_from][msg.sender]) {
                    balanceOf[_from] -= _value;
                    balanceOf[_to] += _value;
                    allowance[_from][msg.sender] -= _value;
                }
            }
        }
        Transfer(_from,_to,_value);
        return true;
    }
    
}