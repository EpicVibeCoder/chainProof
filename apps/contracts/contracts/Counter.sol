// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.34;

/// @notice Minimal on-chain proof registry (demo-first).
contract ProofRegistry {
    error DuplicateProof();
    struct ProofRecord {
        address owner;
        uint64 timestamp;
        uint64 blockNumber;
        string ipfsCid;
        bool exists;
    }
    event ProofRegistered(
        bytes32 indexed hash,
        address indexed owner,
        uint64 timestamp,
        uint64 blockNumber,
        string ipfsCid
    );
    mapping(bytes32 => ProofRecord) private _proofs;
    function registerProof(bytes32 hash, string calldata ipfsCid) external {
        ProofRecord storage record = _proofs[hash];
        if (record.exists) revert DuplicateProof();
        record.owner = msg.sender;
        record.timestamp = uint64(block.timestamp);
        record.blockNumber = uint64(block.number);
        record.ipfsCid = ipfsCid;
        record.exists = true;
        emit ProofRegistered(
            hash,
            msg.sender,
            record.timestamp,
            record.blockNumber,
            ipfsCid
        );
    }
    function getProof(
        bytes32 hash
    )
        external
        view
        returns (
            address owner,
            uint64 timestamp,
            uint64 blockNumber,
            string memory ipfsCid,
            bool exists
        )
    {
        ProofRecord storage record = _proofs[hash];
        return (
            record.owner,
            record.timestamp,
            record.blockNumber,
            record.ipfsCid,
            record.exists
        );
    }
}
