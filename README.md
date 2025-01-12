[![MIT License](https://img.shields.io/badge/License-MIT-red)](https://github.com/mana121/SolvationStructure/blob/main/LICENSE)
[![LigParGen-OPLSAA](https://img.shields.io/badge/LigParGen-OPLSAA-orange)](https://traken.chem.yale.edu/ligpargen/)
[![Packmol Version](https://img.shields.io/badge/PACKMOL-Version%2020.14.3-yellow)](https://m3g.github.io/packmol/)
[![fftool Version](https://img.shields.io/badge/FFToo-2024%2F10%2F17-green)](https://github.com/paduagroup/fftool)
[![LAMMPS Version](https://img.shields.io/badge/LAMMPS-Version%2023%20Jun%202022-darkgreen)](https://lammps.org/#gsc.tab=0)
[![VASPKIT Version](https://img.shields.io/badge/VASPKIT-Version%201.4.0-darkblue)](https://vaspkit.com)
[![OVITO Version](https://img.shields.io/badge/OVITO-Version%203.8.4-blue)](https://www.ovito.org)
[![VASP Version](https://img.shields.io/badge/VASP-v6.2.1-purple)](https://www.vasp.at)

![OVITO Logo](https://www.ovito.org/_astro/ovito_logo_256.QJOLhqx1_1Bxh16.webp)

 <img src="https://vaspkit.com/_static/logo.png" alt="VASPKIT Logo" width="60">
 <img src="https://www.vasp.at/images/logo.png" alt="VASP Logo" width="150">
 <img src="https://lammps.org/movies/logo.gif" alt="LAMMPS Logo" width="200">






# SolvationStructure 

**SolvationStructure**: MD and DFT Study of $\ce{Li+}$ Solvation Structures in Ether and Carbonate Based Electrolytes.

## Table of Contents

- [Project Overview](#Project-Overview)
- [Clone the Repository](#Clone-the-Repository)
- [Tutorials](#Tutorials)
- [Obtaining OPLS-AA Parameters](#Obtaining-OPLS-AA-Parameters)
- [Generating Initial Input Files For MD Simulations](#Generating-Initial-Input-Files-For-MD-Simulations)
- [Running MD Simulations in LAMMPS](#Running-MD-Simulations-in-LAMMPS)
- [Runing DFT Calculation in VASP](#Runing-DFT-Calculation-in-VASP)
- [Documentation](#Documentation)
- [Project Organization](#Project-Organization)
- [Contact Information](#Contact-Information)
- [License](#License)
- [References](#References)

## Project Overview

![MD snapshots of electrolyte](https://github.com/mana121/SolvationStructure/blob/main/results/3D_simulation_box_1P8M_DPE_FEME_1M_ECDEC.svg)

_Figure_: MD snapshots of the simulation box at 5 ns of the production run: (a) DPE+1.8M $\ce{LiFSI}$, (b) FEME+1.8M $\ce{LiFSI}$, and (c) 1:1 EC/DEC+1M $\ce{LiPF6}$.

This project focuses on studying the solvation structures of lithium ions $\ce{Li+}$ in three distinct electrolytes used in lithium-ion batteries. These include: 

1. $\ce{LiFSI}$ with Dipropyl Ether (DPE)
2. $\ce{LiFSI}$ with 2,2-Difluoroethyl Methyl Ether (FEME)
3. $\ce{LiPF6}$ with a mixture of Ethylene Carbonate (EC) and Diethyl Carbonate (DEC)
   
The solvation behavior is analyzed through Molecular Dynamics (MD) simulations and Density Functional Theory (DFT) calculations. Key aspects, including radial distribution functions (RDF), coordination numbers (CN), quantum mechanical properties, and concentration effects, are explored to enhance the understanding of each electrolyte structure.

## Clone the Repository

Download the files or clone the repository:

```bash
git clone https://github.com/mana121/SolvationStructure.git
```

## Tutorials

This tutorial will guide you on how to model an electrolyte system.

In this tutorial, you will learn to:

1. Obtain **OPLS-AA** force field parameters using the [LigParGen](https://traken.chem.yale.edu/ligpargen/) server.
2. Utilize the [fftool](https://github.com/paduagroup/fftool) to create initial files for MD simulations.
3. Utilize [PACKMOL](https://m3g.github.io/packmol/) to pack molecules into the simulation box.
4. Generate input files for running:
   - MD simulations in [LAMMPS](https://lammps.org/#gsc.tab=0)
   - DFT calculations in [VASP](https://www.vasp.at)
  
A detailed discussion of Steps 1, 2, and 3 can be found in this [blog post](https://longkunxuluke.github.io/posts/2020/11/blog-post-4/).

Visualization Software: 
 - [VESTA](https://jp-minerals.org/vesta/en/)
 - [OVITO](https://www.ovito.org)
 - [Maestro](https://www.schrodinger.com/platform/products/maestro/) 

## Obtaining **OPLS-AA** Parameters

1. Download the `.mol` file of solvent from [ChemSpider](https://www.chemspider.com/Chemical-Structure.7030.html).
2. Upload and submit the `.mol` file in [LigParGen](https://traken.chem.yale.edu/ligpargen/) server.
3. Download the `.itp`, `.lmp`, and `.xyz` files from LigParGen server.
4. Convert the LigParGen generated parameters into fftool style parameters using [convertLigParGen.py](https://github.com/mccg-pas/group-wiki/tree/master/Scripts/ILMD).

   Here is the command of parameter conversion for DPE:
   
   ```bash
   python convertLigParGen.py -g UNK_FBC5C6.itp -l UNK_FBC5C6.lmp -o DPE.ff
   ```
5. For ionic liquids avoid steps 1 to 4. Use `.zmat` [.zmat](https://github.com/paduagroup/clandp) and `il.ff`[il.ff](https://github.com/paduagroup/clandp) files.

## Generating Initial Input Files For MD Simulations

1. Calculate the number of salt and solvent molecules in the simulation box for a specific concentration using [solvent_salt_molecule_count.ipynb](https://github.com/mana121/SolvationStructure/tree/main/molecule_count). For DPE+1.8M $\ce{LiFSI}$ electrolyte system with a simulation box of length 50 Å, the composition is:
   - 542 DPE molecules
   - 135 $\ce{Li+}$ ions
   - 135 $\ce{FSI-}$ ions.
     
2. Use fftool to create an input file (`pack.inp`) for PACKMOL. 

   ```bash
   fftool 542 DPE.xyz 135 Li.zmat 135 fsi.zmat -b 50.0  
   ```
3. Use PACKMOL to generate the atomic coordinates in the simulation box which will save in `simbox.xyz`.

   ```bash
   packmol < pack.inp      
   ```

4. Use fftool to create the LAMMPS input script `in.lmp` and data file `data.lmp`.

   ```bash
   fftool 542 DPE.xyz 135 Li.zmat 135 fsi.zmat -b 50.0 -l
   ```

## Running MD Simulations in LAMMPS

   We conduct two separate [MD](https://github.com/mana121/SolvationStructure/tree/main/simulation/electrolyte/LAMMPS) simulations for each electrolyte system on the NJIT HPC [Wulver cluster](https://arcs-njit-edu.github.io/Docs/clusters/wulver/):

   1. Energy minimization and equilibration: Performed using the initial electrolyte configuration generated by fftool and PACKMOL.
   2. Melting, quenching, and production run: Conducted using the equilibrated system from Step 1.

Remote cluster: 

```bash
sbatch submit_lammps.slurm
```
Local machine (For small system): 

[Basics of running LAMMPS](https://docs.lammps.org/Run_basics.html)

```bash
lmp_serial -i in.lmp
```
```bash
mpirun -np 8 lmp_mpi -i in.lmp
```

## Runing DFT Calculation in VASP

Rrequired input files for geometry optimization/structure relaxation:

  - INCAR
  - KPOINTS
  - POSCAR
  - POTCAR

The SCF calculation is performed on the optimized structure (**CONTCAR**) following geometry optimization. Rrequired input files for SCF calculation:

  - INCAR
  - KPOINTS
  - POSCAR (copy CONTCAR to POSCAR)
  - POTCAR

## Documentation

Full documentation of this project is available on 

## Project Organization


```
├── AUTHORS.md                    <- List of authors.
├── README.md                     <- README for users.
├── molecule_count                <- Python code to calculate salt and solvent molecules in the simulation box.
├── results                       <- RDF and CN graphs.
├── LICENSE                       <- LICENSE file.
└── simulation
    ├── electrolyte
    │   ├── LAMMPS                <- LAMMPS input files for energy minimization, equilibration, melting, quenching, and production run.
    │   ├── LigParGen server      <- Parameters from LigParGen.
    │   ├── convert LigParGen     <- fftool style parameter conversion.
    │   └── fftool PACKMOL        <- Initial LAMMPS input files.
    └── solvation structure
        ├── INCAR                 <- INCAR files for DFT in VASP.
        └── geometry opt          <- CONTCAR files from DFT in VASP.
```


## Contact Information

- Rumana Hasan [manarum.hasan@gmail.com](manarum.hasan@gmail.com)

## License

This project is distributed under the MIT License; refer to the [LICENSE](https://github.com/mana121/SolvationStructure/blob/main/LICENSE) file for more information.

## References

- [https://longkunxuluke.github.io/posts/2020/11/blog-post-4/](https://longkunxuluke.github.io/posts/2020/11/blog-post-4/)
- [LigParGen](https://traken.chem.yale.edu/ligpargen/) server: [https://doi.org/10.1093/nar/gkx312](https://doi.org/10.1093/nar/gkx312)
- [PACKMOL](https://m3g.github.io/packmol/) package: [https://doi.org/10.1002/jcc.21224](https://doi.org/10.1002/jcc.21224)
- [LAMMPS](https://lammps.org/#gsc.tab=0) software: [https://doi.org/10.1016/j.cpc.2021.108171](https://doi.org/10.1016/j.cpc.2021.108171)
- [LAMMPS documentation](https://docs.lammps.org/Manual.html)
- [VASP manual](https://www.vasp.at/wiki/index.php/The_VASP_Manual) 
- [VASPKIT documentation](https://vaspkit.com) 

## Note

This project used [LAMMPS](https://lammps.org/download.html), version 23 Jun 2022.

Sorry for the excessive commits in README.md; I was dealing with the **unsaved changes bug**. I resolved it by switching to another browser. 😅
