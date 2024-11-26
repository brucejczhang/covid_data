# Predicting COVID-19 Risk in Canada Based on Region, Sex, and Age

## Overview

This repo provides the scripts, sketches, data, and files necessary to understand the paper focusing on interpreting COVID-19 demographic data and use it to predict populations and communities that have a higher probability of high risk. 

The paper conducts statistical analysis of COVID-19 related demographic data and models how different factors could predict the probability of high risk of the pandemic. The model that was used was a logistic regression model. The results indicate that a living in rural regions, being a male, and being between 40 to 50 years old positively correlates to a higher probability of high risk. The results can potentially suggest preventative measures and healthcare focuses in future pandemic situations. 

## Statement on Raw Data

The raw data used for this repo was too large to be added as part of the pacakge. The data was obtained from COVerAGE-DB from Open Science Framework (OSF) and can be downloaded at https://osf.io/43ucn. 

The data highlighted demographic data on people who were classified as COVID-19 cases, tests, and deaths across five countries. Data was collected through government or medical institutions. 

## File Structure

The repo is structured as:

-   `data/analysis_data` contains the cleaned dataset that was constructed and cleaned for the purpose of this analysis. 
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, and clean data.


## Statement on LLM usage

Aspects of the code for figure creation and testing were generated under the guidance of generative AI tool ChatGPT. The entire chat history is available in other/llms_usage/usage.txt.
