---
name: ProofChain Step Instructions
overview: A condensed execution-only plan derived from the existing ProofChain build plan, keeping only ordered implementation steps and completion gates.
todos:
  - id: workspace-bootstrap
    content: Set up monorepo apps/packages and baseline tooling/env files
    status: pending
  - id: contract-core
    content: Implement ProofRegistry contract and pass core unit tests
    status: pending
  - id: deployment-artifacts
    content: Deploy to Sepolia and export ABI/address to shared package
    status: pending
  - id: backend-api
    content: Build NestJS modules/endpoints with validation and IPFS metadata flow
    status: pending
  - id: mobile-flows
    content: Implement React Native notarize/verify/details flows with wallet integration
    status: pending
  - id: hardening-testing-demo
    content: Complete security pass, critical tests, and final demo packaging
    status: pending
isProject: false
---

# ProofChain Step-by-Step Instructions

## Scope Notes

- This will be published, but each app/service will ultimately live in its own separate repository.
- This root repo is used as a development orchestrator so everything can be run from one place during build.
- Turborepo is used primarily to run root-level local development workflows (`dev`).
- Docker setup is optional and can be introduced later.

## Execution Order

1. Initialize workspace structure and tooling (`apps/mobile`, `apps/api`, `apps/contracts`) with Node 22 workspaces, TypeScript baseline, and `.env.example` files so root `dev` can run all apps.
2. Implement `ProofRegistry` contract with `registerProof`, `getProof`, `ProofRegistered` event, and duplicate-hash guard.
3. Add and pass contract tests for successful registration, duplicate prevention, proof retrieval, and event emission.
4. Configure Sepolia deployment environment (`RPC_URL`, `PRIVATE_KEY`, `CHAIN_ID`) and deploy the contract.
5. Export deployed ABI/address artifacts for backend/mobile consumption using a repo-independent handoff (artifact file, package, or release asset) to keep future repo split clean.
6. Build backend foundation in NestJS with `health`, `proof`, `ipfs`, and chain wrapper modules.
7. Implement backend endpoints: `GET /health`, `GET /proof/:hash`, `POST /ipfs/metadata`.
8. Add backend DTO validation and basic rate limiting.
9. Define metadata schema and implement IPFS metadata pinning flow that returns CID.
10. Scaffold React Native app (Expo) with `NotarizeScreen`, `VerifyScreen`, and `ProofDetailsScreen` plus navigation.
11. Implement file selection and deterministic SHA-256 hashing from raw bytes.
12. Integrate WalletConnect and enforce Sepolia network checks before notarization.
13. Implement notarize flow: pick file -> hash -> optional metadata upload -> submit `registerProof` transaction.
14. Add transaction lifecycle UI states: pending, confirmed, failed, and explorer link.
15. Implement verify flow: re-hash selected file, query proof endpoint, and display authentic/tampered verdict.
16. Build proof details screen with hash, owner, block info, timestamp, CID, and share/copy actions.
17. Perform security hardening: file type/size limits, hash normalization, safe error handling, no client-side private keys.
18. Execute test pass across contract, backend, and mobile critical demo paths.
19. Package demo runbook and fallback assets (recording, seeded proof hash, funded backup wallet).
20. Validate final demo can run end-to-end in under 5 minutes.

## Completion Gates

- Contract is deployed on Sepolia and consumable by API/mobile via shared artifacts.
- End-to-end notarize and verify flows work on real testnet transactions.
- Critical failure paths are handled (duplicate registration, tampered file verification).
- Demo script is reproducible and presentation-ready.
