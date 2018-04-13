pragma solidity ^0.4.8;

contract SimpleCoin {
    
    address public minter;
    uint public totalCoins;
    
    event LogCoinsMinted(address deliveredTo, uint amount);
    event LogCoinsSent(address sentTo, uint amount);
    
    mapping(address => uint) balances;
    
    function SimpleCoin(uint initialCoins) public {
        minter = msg.sender;
        totalCoins = initialCoins;
        balances[minter] = initialCoins;
    }
    
    function mint(address owner, uint amount) public {
        if(msg.sender != minter) return;
        balances[owner] += amount;
        totalCoins += amount;
        LogCoinsMinted(owner,amount);
    }
    
    function send(address receiver, uint amount) public {
        if(msg.sender != minter) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        LogCoinsSent(receiver,amount);
    }
    
    function queryBalance(address addr) public constant returns (uint balance) {
        return balances[addr];
    }
    
    function killCoin() public {
        if(msg.sender != minter) throw;
        selfdestruct(minter);
    }
}