# Predicting Valence in Music Using Audio Features and Temperature

## Overview

This repository contains the analysis of the emotional tone (Valence) in music using Spotify audio features and weather data from the Government of Canada's Climate Weather website. The project explores the relationship between musical characteristics, such as tempo and danceability, and the contextual variable, temperature, to predict emotional tone. Multiple linear regression models and simulated datasets were used to validate findings and enhance the robustness of the analysis.

To use this repository, click the green "Code" button, then "Download ZIP." Move the downloaded folder to your computer and modify it as needed.

## File Structure

The repository is organized as follows:

- `data/raw_data`: Contains the raw data as obtained from Spotify Charts and Government of Canada's Climate Weather website.
- `data/analysis_data`: Contains the cleaned and processed dataset used in the analysis.
- `models`: Contains fitted models, including code for training and validation.
- `other`: Includes additional details, such as assistance from ChatGPT-4o and preliminary sketches.
- `paper`: Contains files used to generate the paper, including Quarto documents and reference bibliography files, as well as PDFs of the final paper.
- `scripts`: Contains the R scripts used to simulate, download, clean, test, analyze and model the data.

## Statement on LLM usage

Aspects of the code were written with the help of the ChatGPT-4o, including graphing and some conceptual assistance. It is available in `other/llm_usage`.
