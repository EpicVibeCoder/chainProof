// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ProofRegistry} from "./ProofRegistry.sol";

contract ProofRegistryActor {
    function register(
        ProofRegistry registry,
        bytes32 fileHash,
        string calldata ipfsCid
    ) external {
        registry.registerProof(fileHash, ipfsCid);
    }
}

contract ProofRegistryTest {
    ProofRegistry private registry;
    ProofRegistryActor private actor;

    function setUp() public {
        registry = new ProofRegistry();
        actor = new ProofRegistryActor();
    }

    function test_RegisterProof_Succeeds() public {
        bytes32 fileHash = keccak256("proof-file-1");
        string memory ipfsCid = "bafy-proof-1";

        registry.registerProof(fileHash, ipfsCid);

        (
            address owner,
            uint64 timestamp,
            uint64 blockNumber,
            string memory storedCid,
            bool exists
        ) = registry.getProof(fileHash);

        require(owner == address(this), "owner mismatch");
        require(timestamp > 0, "timestamp not set");
        require(blockNumber > 0, "block number not set");
        require(
            keccak256(bytes(storedCid)) == keccak256(bytes(ipfsCid)),
            "cid mismatch"
        );
        require(exists, "proof should exist");
    }

    function test_RegisterProof_RevertsOnDuplicate() public {
        bytes32 fileHash = keccak256("proof-file-dup");

        actor.register(registry, fileHash, "bafy-first");

        bool reverted;
        try actor.register(registry, fileHash, "bafy-second") {
            reverted = false;
        } catch {
            reverted = true;
        }
        require(reverted, "expected duplicate proof revert");
    }

    function test_GetProof_ReturnsExpectedRecord() public {
        bytes32 fileHash = keccak256("proof-file-2");
        string memory ipfsCid = "bafy-proof-2";

        actor.register(registry, fileHash, ipfsCid);

        (
            address owner,
            uint64 timestamp,
            uint64 blockNumber,
            string memory storedCid,
            bool exists
        ) = registry.getProof(fileHash);

        require(owner == address(actor), "stored owner mismatch");
        require(timestamp > 0, "stored timestamp missing");
        require(blockNumber > 0, "stored block missing");
        require(
            keccak256(bytes(storedCid)) == keccak256(bytes(ipfsCid)),
            "stored cid mismatch"
        );
        require(exists, "stored exists should be true");
    }
}
