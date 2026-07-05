// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/Calculator.sol";

contract CalculatorTest is Test {

    Calculator public calculator;
    uint256 public initialResult = 100;
    address public admin = vm.addr(1);
    address public nonAdmin = vm.addr(2);

    // Initialization of the contract
    function setUp() public {
        // Deploy the Calculator contract with an initial result and the test contract as admin
        calculator = new Calculator(initialResult, admin);
    }

    // UnitTests = Given Inputs

    function testFirstResult() public view{
        uint256 result = calculator.result();
        assert(result == initialResult);// Verify that the initial result is set correctly
    }

    function testAdd() public {
        uint256 _firstNumber = 5;
        uint256 _secondNumber = 5;
        uint256 expectedResult = _firstNumber + _secondNumber;

        uint256 result = calculator.add(_firstNumber, _secondNumber);
        assert(result == expectedResult);// Verify that the addition result is correct
    }

    function testSubtract() public {
        uint256 _firstNumber = 10;
        uint256 _secondNumber = 5;
        uint256 expectedResult = _firstNumber - _secondNumber;

        uint256 result = calculator.subtract(_firstNumber, _secondNumber);
        assert(result == expectedResult);// Verify that the subtraction result is correct
    }

    function testMultiply() public {
        uint256 _firstNumber = 4;
        uint256 _secondNumber = 5;
        uint256 expectedResult = _firstNumber * _secondNumber;

        uint256 result = calculator.multiply(_firstNumber, _secondNumber);
        assert(result == expectedResult);// Verify that the multiplication result is correct
    }

    function testCanNotMultiply2LargeNumbers() public {
        uint256 _firstNumber = type(uint256).max;
        uint256 _secondNumber = 2;

        vm.expectRevert(); // Expect a revert due to overflow
        calculator.multiply(_firstNumber, _secondNumber);
    }

    function testIfNotAdminCanNotDivide() public {
        vm.startPrank(nonAdmin); // Start impersonating the non-admin address
        
        uint256 _firstNumber = 10;
        uint256 _secondNumber = 2;

        vm.expectRevert("Only admin can perform this action"); // Expect a revert due to non-admin access
        calculator.divide(_firstNumber, _secondNumber);

        vm.stopPrank(); // Stop impersonating the non-admin address
    }

    function testAdminCanDivideCorrectly() public {
        vm.startPrank(admin); // Start impersonating the admin address

        uint256 _firstNumber = 10;
        uint256 _secondNumber = 2;

        
        calculator.divide(_firstNumber, _secondNumber);

        vm.stopPrank(); // Stop impersonating the non-admin address
    }

    function testDefaultAdminCanNotDivideCorrectly() public {
        uint256 _firstNumber = 10;
        uint256 _secondNumber = 2;

        console.log("Default admin address:", msg.sender);
        vm.expectRevert("Only admin can perform this action"); // Expect a revert due to non-admin access
        
        calculator.divide(_firstNumber, _secondNumber);
    }

    function testDefaultExecuteDivideCorrectly() public {
        vm.startPrank(admin); // Start impersonating the admin address
        uint256 _firstNumber = 10;
        uint256 _secondNumber = 2;

        uint256 result = calculator.divide(_firstNumber, _secondNumber);
        assert(result == _firstNumber / _secondNumber); // Verify that the division result is correct

        vm.stopPrank(); // Stop impersonating the non-admin address
    }

    function testDivideByZero() public {
        vm.startPrank(admin); // Start impersonating the admin address

        uint256 _firstNumber = 10;
        uint256 _secondNumber = 0;

        vm.expectRevert("Division by zero"); // Expect a revert due to division by zero
        calculator.divide(_firstNumber, _secondNumber);

        vm.stopPrank(); // Stop impersonating the non-admin address
    }

    // FuzzTests = Random Inputs

    function testFuzzDivide(uint256 _firstNumber, uint256 _secondNumber) public {
        vm.assume(_secondNumber != 0); // Ensure the second number is not zero to avoid division by zero
        vm.startPrank(admin); // Start impersonating the admin address

        uint256 result = calculator.divide(_firstNumber, _secondNumber);
        assert(result == _firstNumber / _secondNumber); // Verify that the division result is correct

        vm.stopPrank(); // Stop impersonating the non-admin address
    }



}