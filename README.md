# Linear Vesting Vault

This repository provides a secure way to distribute project tokens to stakeholders. Instead of a lump-sum transfer, tokens are locked in this contract and "streamed" to the beneficiary based on a defined schedule.

## Vesting Parameters
* **Start Time**: When the vesting begins.
* **Cliff Duration**: A period during which no tokens can be claimed. If the user leaves before the cliff, they get nothing.
* **Vesting Duration**: The total time over which all tokens are released (e.g., 48 months).
* **Revocable**: Optional feature allowing the owner to cancel vesting and reclaim unvested tokens (useful for employee terminations).

## Mathematical Formula
The releasable amount at any time $t$ (where $t > cliff$) is calculated as:
$$\text{Releasable} = \left( \text{Total Allocation} \times \frac{t - \text{Start Time}}{\text{Duration}} \right) - \text{Already Withdrawn}$$
