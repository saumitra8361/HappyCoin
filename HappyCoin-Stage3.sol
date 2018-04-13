pragma solidity ^0.4.8;

contract Admined {
    
    address public admin;
    
    function Admined() public {
        admin = msg.sender;
    }
    
    modifier onlyAdmin() {
        if(msg.sender == admin)
        _;
    }
    
    function transferAdminship(address newAdmin) public onlyAdmin {
        admin = newAdmin;
    }
}

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

contract HappyCoinAdvanced  is Admined, HappyCoin {
    
    uint256 public sellprice;
    uint256 public buyprice;
    uint256 minimumBalanceForAccounts = 5 finney;
    
    mapping (address => bool) public frozenAccount;
    
    event  FrozenFund(address target, bool frozen);
    
    function HappyCoinAdvanced(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address cetralAdmin) HappyCoin(0,tokenName,tokenSymbol,decimalUnits) public {
        
        totalSupply = initialSupply;
        
        if(cetralAdmin != 0) {
            admin = cetralAdmin;
        } else {
            admin = msg.sender;
        }
        
        balanceOf[admin] = initialSupply;
        totalSupply = initialSupply;
    }
    
    function mintToken(address target, uint256 mintedAmount) onlyAdmin public {
        
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0,this,mintedAmount);
        Transfer(this,target,mintedAmount);
    }
    
    function freezeAccounts(address target, bool freeze) onlyAdmin public {
        
        frozenAccount[target] = freeze;
        FrozenFund(target,freeze);
        
    }
    
    function transfer(address _to, uint256 _value) public {
        if(msg.sender.balance < minimumBalanceForAccounts){
            sell((minimumBalanceForAccounts - msg.sender.balance) /  sellprice);
        }
        if(!frozenAccount[msg.sender]) {
            if(balanceOf[msg.sender] > _value) {
                if(balanceOf[_to] + _value > balanceOf[_to]) {
                    balanceOf[msg.sender] -= _value;
                    balanceOf[_to] += _value;
                }
            }
        } 
        Transfer(msg.sender,_to,_value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(!frozenAccount[msg.sender]) {
            if(balanceOf[_from] > _value) {
                if(balanceOf[_to] + _value > balanceOf[_to]) {
                    if(_value < allowance[_from][msg.sender]) {
                        balanceOf[_from] -= _value;
                        balanceOf[_to] += _value;
                        allowance[_from][msg.sender] -= _value;
                    }
                }
            }
        }
        Transfer(_from,_to,_value);
        return true;
    }
    
    function setPrice(uint256 newSellPrice, uint256 newBuyPrice)  onlyAdmin public {
        sellprice = newSellPrice;
        buyprice = newBuyPrice;
    }
    
    function buy() payable public{
        uint256 amount = (msg.value/(1 ether)) / buyprice;
        if(balanceOf[this] > amount) {
            balanceOf[msg.sender] += amount;
            balanceOf[this] -= amount;
            Transfer(this,msg.sender,amount);
        }
    }
    
    function sell(uint256 amount) public {
        if(balanceOf[msg.sender] > amount){
            balanceOf[this] += amount;
            balanceOf[msg.sender] -= amount;
        
            if(msg.sender.send(amount*sellprice*1 ether)){
            Transfer(msg.sender,this,amount);
            }
        }
    }
    
    /* function to give miner a reward in case new block is mined */
    function giveBlockReward() public {
        balanceOf[block.coinbase] += 1;
    }
    
    /* function in case anyone has solved any mathematical problem */
    bytes32 public currentChallenge;
    uint public timeOfLastProof;
    uint public difficulty = 10**32;
    
    function proofOfWork(uint nonce) public {
        
        bytes8 n = bytes8(keccak256(nonce,currentChallenge)); //calculating current difficulty
        
        if(n > bytes8(difficulty)){
            uint timeSinceLastBlock = (now - timeOfLastProof);
            if(timeSinceLastBlock > 5 seconds) {
                balanceOf[msg.sender] += timeSinceLastBlock / 60 seconds;
                difficulty = difficulty * 10 minutes / timeOfLastProof + 1;
                timeOfLastProof = now;
                currentChallenge = keccak256(nonce,currentChallenge,block.blockhash(block.number-1));
            }
        }
        
    }
    
    function killCoin() public {
        if(msg.sender == admin)
        selfdestruct(admin);
    }
    
}