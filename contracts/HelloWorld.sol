//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract HelloWorld{

string public greetings;

constructor() public {
    greetings ='Greetings Text';
    
}

function setMessage(string memory _greetings) public {
    greetings = _greetings;
} 
}
