# ZK-STARK on TPU: Accelerating Zero-Knowledge Proofs

## Project Overview

This project aims to leverage the massive parallel computing power of Google Cloud TPUs (Tensor Processing Units) to accelerate the generation of ZK-STARK proofs.

While TPUs are designed for machine learning (matrix multiplication on floating-point numbers), their architecture is theoretically suitable for the heavy polynomial operations required in Zero-Knowledge proofs, specifically Number Theoretic Transforms (NTT).

## Roadmap & Status

### Phase 1: Infrastructure (DevOps)

- [x] **Automated TPU Deployment**: provisioning and destruction of TPU VMs using Terraform.
- [x] **Environment Setup**: Configuration of JAX with TPU support (`jax[tpu]`).

### Phase 2: Theoretical Foundations

- [ ] **Trace Arithmetization**: Master the conversion of execution traces into polynomials .
- [ ] **Polynomial Constraints**: Understand how to map computational integrity to polynomial roots 
- [ ] **FRI Protocol**: Deep dive into the Fast Reed-Solomon Interactive Oracle Proof of Proximity for low-degree testing .

### Phase 3: Minimal Baseline Implementation (CPU)

- [ ] **Reference Implementation**: Build a pure Python/CPU version of a STARK prover
    - Implement Trace generation and Polynomial Interpolation 
    - Implement the FRI operator and commitment scheme 
- [ ] **Benchmarking**: Establish baseline metrics for proof generation time on standard CPUs.

### Phase 4: TPU Engineering (JAX)

This is the core research phase of the project, addressing the hardware-algorithm mismatch.

- [ ] **Finite Field Arithmetic on TPU**:
  - Implement modular addition and multiplication using JAX.
  - Solve the challenge of performing integer modular arithmetic on TPU floating-point hardware.
- [ ] **TPU-Accelerated NTT**:
  - Implement the Number Theoretic Transform (NTT) using JAX.
  - Optimize the algorithm to utilize the TPU's systolic array architecture for large-scale polynomial evaluation.

### Phase 5: Integration & Optimization

- [ ] **End-to-End Prover**: Replace the CPU-based polynomial operations in the Phase 3 implementation with the TPU-accelerated kernels from Phase 4.
- [ ] **Decommitment & Verification**: Ensure the generated proofs, including Merkle paths and FRI layers, are verifiable.
- [ ] **Performance Analysis**: Compare TPU throughput vs. CPU baseline.

## Technical Stack

* **Language**: Python
- **Framework**: JAX (for XLA compilation to TPU)
- **Infrastructure**: Terraform, Google Cloud TPU v5/v6
- **Math**: Finite Fields, Poly-arithmetic, FRI

## License
[Apache-2.0 license]
