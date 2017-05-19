from IBMQuantumExperience import IBMQuantumExperience
api = IBMQuantumExperience ("c413835f96f5c9ce144faa39b7cab48d9f7b06cdaa7a5c00f2da33b3c56dbf453680ae1e9fa47cf58329404ab9ba7b8a7f2b85d961a0d4dac5ff2220e42272d1")
qasm = 'OPENQASM 2.0;\n\ninclude "qelib1.inc";\nqreg q[5];\ncreg c[5];\nh q[0];\ncx q[0],q[2];\nmeasure q[0] -> c[0];\nmeasure q[2] -> c[1];\n'
print api.run_experiment(qasm, device='real', shots=1024, name=None, timeout=60)


