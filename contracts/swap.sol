pragma solidity 0.6.12;

import "./uniswapv2/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract swap is Ownable {
    using SafeMath for uint256;
    IUniswapV2Router02 uniswapV2Router;
    uint256 deadline;
    IERC20 Dai;

    event swapedfordai(uint256);
    event Received(address, uint256);

    constructor(IUniswapV2Router02 _uniswapV2Router, address _tokenAddress) public {
        uniswapV2Router = IUniswapV2Router02(address(_uniswapV2Router));
        deadline = block.timestamp + 300; // 5 minutes
        Dai = IERC20(_tokenAddress);
    }

    fallback() external payable {
        emit Received(msg.sender, msg.value);
    }

    /// @notice Swap ETH to Dai token Via uniswap router
    function swapWithETH() public payable {
        uint256 estimatedDai = getEstimatedTokenForETH(
            msg.value,
            address(Dai)
        )[0];
        uniswapV2Router.swapETHForExactTokens{value: msg.value}(
            estimatedDai,
            getPathForETHToToken(address(Dai)),
            address(this),
            deadline
        ); // swap ETH to DAI
        uint256 tokenSwaped = Dai.balanceOf(address(this));
        emit swapedfordai(tokenSwaped);
    }

    /// @notice get Dai Balance
    function getTokenBalance() public view returns (uint256) {
        uint256 tokenBalance = Dai.balanceOf(address(this));
        return tokenBalance;
    }
    /// @notice Withdraw balance to owner address
    function WithdrawBalance() public payable onlyOwner {
        msg.sender.call{value: address(this).balance}("");
        Dai.transfer(msg.sender, Dai.balanceOf(address(this)));
    }

    function getPathForETHToToken(address ERC20Token)
        private
        view
        returns (address[] memory)
    {
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = ERC20Token;

        return path;
    }

    function getPathForTokenToETH(address ERC20Token)
        private
        view
        returns (address[] memory)
    {
        address[] memory path = new address[](2);
        path[0] = ERC20Token;
        path[1] = uniswapV2Router.WETH();

        return path;
    }

    function getEstimatedTokenForETH(uint256 _tokenAmount, address ERC20Token)
        public
        view
        returns (uint256[] memory)
    {
        return
            uniswapV2Router.getAmountsIn(
                _tokenAmount,
                getPathForETHToToken(ERC20Token)
            );
    }
}
