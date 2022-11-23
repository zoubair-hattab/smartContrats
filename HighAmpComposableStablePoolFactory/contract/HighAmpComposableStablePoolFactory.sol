// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "../interfaces/IVault.sol";
import "../interfaces/IProtocolFeePercentagesProvider.sol";

import "./BasePoolSplitCodeFactory.sol";
import "./FactoryWidePauseWindow.sol";

import "./HighAmpComposableStablePool.sol";

contract HighAmpComposableStablePoolFactory is BasePoolSplitCodeFactory, FactoryWidePauseWindow {
    IProtocolFeePercentagesProvider private _protocolFeeProvider;

    constructor(IVault vault, IProtocolFeePercentagesProvider protocolFeeProvider)
        BasePoolSplitCodeFactory(vault, type(HighAmpComposableStablePool).creationCode)
    {
        _protocolFeeProvider = protocolFeeProvider;
    }

    /**
     * @dev Deploys a new `ComposableStablePool`.
     */
    function create(
        string memory name,
        string memory symbol,
        IERC20[] memory tokens,
        uint256 amplificationParameter,
        IRateProvider[] memory rateProviders,
        uint256[] memory tokenRateCacheDurations,
        bool[] memory exemptFromYieldProtocolFeeFlags,
        uint256 swapFeePercentage,
        address owner
    ) external returns (HighAmpComposableStablePool) {
        (uint256 pauseWindowDuration, uint256 bufferPeriodDuration) = getPauseConfiguration();
        return
            HighAmpComposableStablePool(
                _create(
                    abi.encode(
                        HighAmpComposableStablePool.NewPoolParams({
                            vault: getVault(),
                            protocolFeeProvider: _protocolFeeProvider,
                            name: name,
                            symbol: symbol,
                            tokens: tokens,
                            rateProviders: rateProviders,
                            tokenRateCacheDurations: tokenRateCacheDurations,
                            exemptFromYieldProtocolFeeFlags: exemptFromYieldProtocolFeeFlags,
                            amplificationParameter: amplificationParameter,
                            swapFeePercentage: swapFeePercentage,
                            pauseWindowDuration: pauseWindowDuration,
                            bufferPeriodDuration: bufferPeriodDuration,
                            owner: owner
                        })
                    )
                )
            );
    }
}