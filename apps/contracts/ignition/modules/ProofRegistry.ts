import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("ProofRegistryModule", (m) => {
  const proofRegistry = m.contract("ProofRegistry");
  return { proofRegistry };
});