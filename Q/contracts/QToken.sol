pragma solidity ^0.4.8;

import "./StandardToken.sol";

contract QToken is StandardToken {
    
    mapping (address => bool) authorisers;
    address creator;
    bool canPay = true;
    
    function QToken(){
        authorisers[msg.sender] = true;
        creator = msg.sender;
    }
    
    modifier ifCreator(){
        if(creator != msg.sender){
            revert();
        }
        _;
    }
    
    modifier ifAuthorised(){
        if(authorisers[msg.sender] || creator == msg.sender){
            _;
        }
        else{
            revert();
        }
    }
    
    modifier ifCanPay(){
        if(!canPay){
            revert();
        }
        _;
    }
    
    /**
     *  User authorisation management methods
     */ 
    
    function addAuthorised(address _address) ifAuthorised{
        authorisers[_address] = true;
    }
    
    function removeAuthorised(address _address) ifAuthorised{
        delete authorisers[_address];
    }
    
    function replaceAuthorised(address _toReplace, address _new) ifAuthorised{
        delete authorisers[_toReplace];
        authorisers[_new] = true;
    }
    
    function getAuthorised(address _address) public constant returns(bool){
        return authorisers[_address] || (creator == _address);
    }
    
    /**
     *  Special transaction methods
     */ 
     
    function pay(address _address, uint256 _value) ifAuthorised ifCanPay{
        balances[_address] += _value;
        totalSupply += _value;
    }
    
    function killPay() ifCreator{
        canPay = false;
    }
}
