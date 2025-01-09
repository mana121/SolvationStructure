# LiSolvXplore

**LiSolvXplore**: MD and DFT Study of $\ce{Li+}$ Solvation Structures in Ether and Carbonate Based Electrolytes.

This project focuses on studying the solvation structures of lithium ions $\ce{Li+}$ in three distinct electrolytes used in lithium-ion batteries. These include: 

1. $\ce{LiFSI}$ with Dipropyl Ether (DPE)
2. $\ce{LiFSI}$ with 2,2-Difluoroethyl Methyl Ether (FEME)
3. $\ce{LiPF6}$ with a mixture of Ethylene Carbonate (EC) and Diethyl Carbonate (DEC)
   
The solvation behavior is analyzed through molecular dynamics (MD) simulations and Density Functional Theory (DFT) calculations. Key aspects, including radial distribution functions (RDF), coordination numbers (CN), quantum mechanical properties, and concentration effects, are explored to enhance the understanding of electrolyte structures.

## Clone the Repository

Download the files or clone the repository:

```bash
git clone https://github.com/mana121/solvation-structure.git
```

## Tutorials

This tutorial will guide you on how to model an electrolyte system.

In this tutorial, you will learn to:

1. Obtain **OPLS-AA** force field parameters using the [LigParGen](https://traken.chem.yale.edu/ligpargen/) server
2. Utilize the [fftool](https://github.com/paduagroup/fftool) to creates initial files for MD simulations.
3. Utilize [PACKMOL](https://m3g.github.io/packmol/) to pack molecules into the simulation box.
4. Generate input files for running:
   * MD simulations in [LAMMPS](https://lammps.org/#gsc.tab=0)
   * DFT calculations in [VASP](https://www.vasp.at)
  
A detailed discussion of Steps 1, 2, and 3 can be found in this [blog post](https://longkunxuluke.github.io/posts/2020/11/blog-post-4/).

For the visualization of molecular structures, [VESTA](https://jp-minerals.org/vesta/en/), [OVITO](https://www.ovito.org), and [Maestro](https://www.schrodinger.com/platform/products/maestro/) are used.

## Obtaining **OPLS-AA** Parameters

1. Download the `.mol` file of solvent from [ChemSpider](https://www.chemspider.com/Chemical-Structure.7030.html)
2. Upload and submit the `.mol` file in [LigParGen](https://traken.chem.yale.edu/ligpargen/) server
3. Download the `.itp`, `.lmp`, and `.xyz` files
4. Convert the LigParGen generated parameters into fftool style parameters using [convertLigParGen.py](https://github.com/mccg-pas/group-wiki/tree/master/Scripts/ILMD)

   Here is the command of parameter conversion for DPE:
   
   ```bash
   python convertLigParGen.py -g UNK_FBC5C6.itp -l UNK_FBC5C6.lmp -o DPE.ff
   ```
5. For ionic liquids avoid steps 1 to 4. Use `.zmat` [.zmat](https://github.com/paduagroup/clandp) and `il.ff`[il.ff](https://github.com/paduagroup/clandp) files.

## Generate Initial Files For MD Simulations

1. Calculate the number of salt and solvent molecules in the electrolyte for a specific concentration using   . For 1.8M DPE+$\CE{LiFSI}$ electrolyte system with a simulation box of length 50 Å, the composition is:
   * 542 DPE solvent molecules
   * 135 $\ce{Li+}$ ions
   * 135  $\ce{FSI-}$ ions.
     
3. Use fftool to create an input file (`pack.inp`) for packmol. 

   ```bash
   fftool 542 DPE.xyz 135 Li.zmat 135 fsi.zmat -b 50.0  
   ```
4. Use PACKMOL to generate the atomic coordinates in the simulation box `simbox.xyz`.

   ```bash
   packmol < pack.inp      
   ```

5. Use fftool to create the LAMMPS input script and data file (`in.lmp` and `data.lmp`).

   ```bash
   fftool 542 DPE.xyz 135 Li.zmat 135 fsi.zmat -b 50.0 -l
   ```

