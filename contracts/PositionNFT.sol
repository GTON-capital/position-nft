// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

import './NFT.sol';
import './libraries/NFTDescriptor.sol';
import './interfaces/INFTManager.sol';

contract PositionNFT is NFT, INFTManager, ReentrancyGuard {

    using SafeERC20 for IERC20;

    ///@dev staked underlying token amount
    uint256 public constant STAKE_AMOUNT = 1e18;

    ///@dev ref to underlying token (deposited token)
    IERC20 public immutable uToken;

    constructor(
        string memory _name,
        string memory _symbol,
        IERC20 _uToken
    ) NFT(_name, _symbol) {
        uToken = _uToken;
    }

    function mint() public virtual override(INFTManager, NFT) nonReentrant() {
        _safeMint(msg.sender, '');
        uToken.safeTransferFrom(msg.sender, address(this), STAKE_AMOUNT);
    }

    function burn(uint256 tokenId) public virtual override(INFTManager, NFT) nonReentrant() {
        require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Manager: caller is not owner nor approved');
        _burn(tokenId);
        uToken.safeTransfer(msg.sender, STAKE_AMOUNT);
    }

    function _tokenURI(uint256 tokenId) internal view virtual override returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.URIParams({
                    tokenId: tokenId,
                    stakingPeriodInDays: 7,
                    stakeAmount: STAKE_AMOUNT,
                    uTokenSymbol: "GTON",
                    uTokenAddress: address(uToken)
                })
            );
    }
}
