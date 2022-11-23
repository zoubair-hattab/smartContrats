// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./IVault.sol";

/**
 * @title IBalancerRelayer
 * @notice Allows safe multicall execution of a relayer's functions
 */
interface IBalancerRelayer {
    function getLibrary() external view returns (address);

    function getVault() external view returns (IVault);

    function multicall(bytes[] calldata data) external payable returns (bytes[] memory results);
}