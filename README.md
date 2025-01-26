# FIFA Player Analytics Project

This project analyzes FIFA player and team data, focusing on comparing male and female players, clustering them based on their attributes, and predicting their market value. It also includes a Shiny dashboard for an interactive analysis of player statistics.

![image](https://github.com/user-attachments/assets/f77dad2b-1e2d-4d23-a218-1d59790c1609)


## Table of Contents
1. [Project Overview](#project-overview)
2. [Data Sources](#data-sources)
3. [Features](#features)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Analysis & Results](#analysis--results)
7. [Shiny Dashboard](#shiny-dashboard)
8. [License](#license)

## Project Overview

The FIFA Player Analytics project leverages data from FIFA video game series, comparing male and female players based on a variety of performance metrics. Key aspects of this project include:
- **Data Preprocessing:** Cleaning and preparing data for analysis.
- **Exploratory Data Analysis (EDA):** Visualizing and analyzing player statistics.
- **Clustering:** Identifying distinct player profiles using K-means clustering.
- **Predictive Modeling:** Predicting player market value using a Random Forest model.
- **Shiny Dashboard:** Creating an interactive web application to explore player statistics.

## Data Sources

The data for this project is based on various CSV files representing both male and female players and teams. The data includes attributes such as player ratings, potential, market value, skills, and more.

- **female_players.csv**
- **male_players.csv**
- **female_teams.csv**
- **male_teams.csv**

You can download the data from the [FIFA 25 Player and Team dataset](https://www.kaggle.com/datasets/stefanoleone992/ea-sports-fc-24-complete-player-dataset?resource=download) 

## Features

- **Player Clustering:** Clustering male and female players based on their attributes such as pace, shooting, passing, etc.
- **Player Market Value Prediction:** Using Random Forest models to predict a player's market value based on their performance attributes.
- **Comparative Analysis:** Visualizing the performance differences between male and female players.
- **Shiny Dashboard:** Interactive interface for exploring player statistics, clustering results, and making predictions.

## Installation

### Prerequisites
To run this project, you need to have R installed along with the following R packages:
- `tidyverse`
- `data.table`
- `caret`
- `factoextra`
- `randomForest`
- `ggplot2`
- `shiny`
- `ggrepel`
- `corrplot`

You can install the required libraries using the following commands in R:

```r
install.packages(c("tidyverse", "data.table", "caret", "factoextra", "randomForest", "ggplot2", "shiny", "ggrepel", "corrplot"))
```

## Usage

### Running the Analysis
1. Load the dataset.
2. Perform the analysis by running the script, which includes data cleaning, exploratory data analysis, clustering, and predictive modeling.
3. You can view detailed statistical analysis and plots by running the script in RStudio.

### Running the Shiny Dashboard
You can launch the interactive dashboard by running the following R script:

```r
shiny::runApp("app.R")
```

This will start a Shiny application that allows you to explore player data interactively.

## Analysis & Results
### Clustering Players
We used K-means clustering to group players into 5 clusters based on their key attributes like pace, shooting, passing, dribbling, defending, and physic. Each cluster represents a different playing style or skill set.

### Market Value Prediction
A Random Forest model was trained to predict a player’s market value based on their overall performance attributes. The model achieved an accuracy of XX% (adjust based on results).

### Key Insights
Male vs Female Players: The analysis found that male players generally have a higher average overall rating and market value compared to female players.
Player Profiles: Through clustering, we identified distinct player profiles based on their skill sets. Some clusters represented highly defensive players, while others were focused on attacking roles.
### Shiny Dashboard
The Shiny dashboard provides an interactive interface for exploring the dataset. It includes:

- Player Clustering: A visual representation of player clusters with labels.
- Market Value Prediction: A form to input player attributes and predict their market value.
- Exploratory Data Analysis: Visualizations of player performance metrics by gender and position.
- To run the Shiny dashboard, use the following command:

```r
shiny::runApp("app.R")
```
