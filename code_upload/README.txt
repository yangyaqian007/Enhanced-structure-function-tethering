System requirements
This script was tested using MATLAB(R2020a) on  64-bit Windows. It requires no additional software packages.

Installation and usage
Download and unzip the directory, open MATLAB, and then navigate to the download folder. You can run the script from within that directory.


Instructions 
'fullprocess.m' is the example script to implement the procedure. It includes the folowing scripts: 

1. 'loaddata.m' reads sc,fc,coordinate data and generates the functional gradient. Runtime is<1s

2. 'decoupling.m' generates the main results for low-frequency case. Runtime is <30s

3. 'anti_decoupling.m' generates the main results for high-frequency case. Runtime is <100s

4. 'null_model.m' generated Fig3C&D and Fig4B&C. Runtime is <10s

5. 'low_high_frequency.m' generates Fig.6. Runtime is <10s