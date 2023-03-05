// SPDX-License-Identifier: MIT

import "../Idea.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.11;

/**
 * Redistributes received VIS according to the Vision cap table.
 */
contract CapTable {
	address[8] public beneficiaries;
	uint256[8] public shares;

	constructor() {
		beneficiaries[0] = 0xd3Fe8b4f1CF50E27fE8707921d38B77F09aC6Db8;
		beneficiaries[1] = 0xe7FBEE6F331E209a6C4B2b1f8Eb382d54F438B76;
		beneficiaries[2] = 0xc32dC5713162479dfD0e0B7E54780DcF23A58fc7;
		beneficiaries[3] = 0xC3dF0b130ECaB8D0D836cFBD9b08DC4856Fe6563;
		beneficiaries[4] = 0xdc36FA7961324b2403e4DD8B9c3bdd27c725E693;
		beneficiaries[5] = 0x9405c86c9021F068b5d2a7a6A818c34A85252f23;
		beneficiaries[6] = 0xCf457e101EF999C95c6563A494241D9C0aD8763B;
		beneficiaries[7] = 0xcFdDa7a46853EeEdA37C4C61f52f93a9D7cb2F24;

		shares[0] = 16_500_000;
		shares[1] = 11_999_987;
		shares[2] = 4_500_000;
		shares[3] = 3_625_000;
		shares[4] = 3_625_000;
		shares[5] = 3_250_000;
		shares[6] = 3_250_000;
		shares[7] = 2_500_000;
	}

	/**
	 * Disperses VIS owned by the cap table to recipients.
	 */
	function releaseFunds(address _token) external {
		IERC20 visContract = IERC20 (_token);

		for (uint256 i = 0; i < 8; i++) {
			require(visContract.transfer(beneficiaries[i], shares[i] * (10 ** 18)), "Failed to fund beneficiary");
		}
	}
}
