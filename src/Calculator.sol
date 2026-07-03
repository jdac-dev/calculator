// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

contract Calculator {
    
    uint256 public result;
    address public admin;

    event Add(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Subtract(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Multiply(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Divide(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;// Tell us to continue executing the rest of the function
    }

    constructor(uint256 result_initial_, address admin_) {
        result = result_initial_;
        admin = admin_;
    }

    function add(uint256 firstNumber, uint256 secondNumber) external returns (uint256 result_) {
        result_ = firstNumber + secondNumber;
        result = result_;

        emit Add(firstNumber, secondNumber, result_);
    }

    function subtract(uint256 firstNumber, uint256 secondNumber) external returns (uint256 result_) {
        result_ = firstNumber - secondNumber;
        result = result_;

        emit Subtract(firstNumber, secondNumber, result_);
    }

    function multiply(uint256 firstNumber, uint256 secondNumber) external returns (uint256 result_) {
        result_ = firstNumber * secondNumber;
        result = result_;

        emit Multiply(firstNumber, secondNumber, result_);
    }

    function divide(uint256 firstNumber, uint256 secondNumber) external onlyAdmin returns (uint256 result_) {
        require(secondNumber != 0, "Division by zero");
        result_ = firstNumber / secondNumber;
        result = result_;

        emit Divide(firstNumber, secondNumber, result_);
    }
}