# Traced_17
Analysis for Traced Challenge hosted at ISMRM 17'

Use the main_call.m script with input path to the directories 'entered as a string' of 
Completed Submissions directory that has already been shared.

NOTE : Please add all the directories in this repository as path in matlab for the 'main_call' script to function.

The script will run the entire calculation of Dice and ICC from scratch and visualize them in Violin Plots for Inter-Scanner,
Intra-Scanner and Intra-Session Analysis.

Second part of the script will generate the median of the top five submissions from the leaderboard across both scanner A
and scanner B. The generated visual tracts will be saved as pngs in the operating directory.

Two rough drafts of figures for the article are contained in the Results folder by the names of Violin_analysis and pre-processing.

Figures in brief:

Figure 1 : Pre-processing pipeline of the data that was provided to the challenge participants.

Figure 2 : Violin Plot analysis of all tracts for inter-scanner, intra-scanner, intra-session along with visual representation of the median tracts based on top five submissions

Figure 3 : The top four submissions when compared with the median of the top five submissions compared.
