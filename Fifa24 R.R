# Install and load required packages
install.packages(c("tidyverse", "data.table", "ggrepel", "caret", "factoextra", "randomForest", "ggplot2", "shiny", "corrplot"))
library(tidyverse)
library(data.table)
library(caret)
library(factoextra)
library(randomForest)
library(ggplot2)
library(shiny)
library(corrplot)
library(ggrepel)
# Load datasets
female_players <- fread("female_players.csv")
male_players <- fread("male_players.csv")
female_teams <- fread("female_teams.csv")
male_teams <- fread("male_teams.csv")

# Add gender column and combine male and female datasets
female_players <- female_players %>% mutate(Gender = "Female")
male_players <- male_players %>% mutate(Gender = "Male")
all_players <- bind_rows(female_players, male_players)

# Select relevant attributes
player_data <- all_players %>%
  select(player_id, short_name, age, overall, potential, value_eur, wage_eur, pace, shooting, passing, dribbling, defending, physic, Gender) %>%
  filter(!is.na(value_eur))

# Handle missing values by imputing the median
player_data <- player_data %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Normalize numeric features
player_data_scaled <- player_data %>%
  mutate(across(where(is.numeric), scale))

summary(player_data)

# Distribution of player overall ratings
ggplot(player_data, aes(x = overall, fill = Gender)) +
  geom_histogram(binwidth = 1, position = "dodge") +
  labs(title = "Distribution of Overall Ratings by Gender", x = "Overall Rating", y = "Count")

# Correlation matrix for numerical attributes
num_features <- player_data %>%
  select(age, overall, potential, value_eur, wage_eur, pace, shooting, passing, dribbling, defending, physic)

# Extract numeric columns from player_data
num_features <- player_data %>%
  select(age, overall, potential, value_eur, wage_eur, pace, shooting, passing, dribbling, defending, physic)

# Ensure no missing values
num_features <- num_features %>% drop_na()

# Check the structure of num_features
str(num_features)

# Compute the correlation matrix
cor_matrix <- cor(num_features)

# Visualize the correlation matrix
corrplot(cor_matrix, method = "color", type = "lower", tl.cex = 0.8, title = "Correlation Matrix", mar = c(0, 0, 1, 0))

# Clustering Players
# K means
set.seed(123)
cluster_data <- player_data_scaled %>%
  select(pace, shooting, passing, dribbling, defending, physic)

# Perform clustering
kmeans_result <- kmeans(cluster_data, centers = 5, nstart = 25)

# Add cluster labels to original dataset
player_data$Cluster <- as.factor(kmeans_result$cluster)

# Visualize clusters
# Visualize clusters with labels
fviz_cluster(kmeans_result, 
             data = cluster_data, 
             geom = "point", 
             ellipse.type = "norm") +
  geom_text(aes(label = player_data$short_name), 
            hjust = 1.1, vjust = 1.1, size = 2, check_overlap = TRUE) +  # Add player names as labels
  ggtitle("Player Clusters Based on Attributes") +
  theme_minimal()  # Clean theme for better readability


# Summarize clusters
player_data %>%
  group_by(Cluster) %>%
  summarise(
    Avg_Overall = mean(overall, na.rm = TRUE),
    Avg_Potential = mean(potential, na.rm = TRUE),
    Avg_Pace = mean(pace, na.rm = TRUE),
    Count = n()
  )

set.seed(123)
train_index <- createDataPartition(player_data$value_eur, p = 0.8, list = FALSE)
train_data <- player_data[train_index, ]
test_data <- player_data[-train_index, ]


# Train the Random Forest model
rf_model <- randomForest(value_eur ~ overall + potential + pace + shooting + passing + dribbling + defending + physic,
                         data = train_data, ntree = 200, importance = TRUE)

# Feature importance
importance <- importance(rf_model)
varImpPlot(rf_model)

# Predict on test set
predictions <- predict(rf_model, test_data)

# Evaluate performance
results <- postResample(predictions, test_data$value_eur)
print(results)

print("test")

# Combine male and female teams
female_teams <- female_teams %>% mutate(Gender = "Female")
male_teams <- male_teams %>% mutate(Gender = "Male")
all_teams <- bind_rows(female_teams, male_teams)

# Visualize overall ratings
ggplot(all_teams, aes(x = Gender, y = overall, fill = Gender)) +
  geom_boxplot() +
  labs(title = "Team Overall Ratings by Gender", x = "Gender", y = "Overall Rating")


# Perform clustering on team attributes
team_cluster_data <- all_teams %>%
  select(overall, attack, midfield, defence) %>%
  scale()

team_kmeans <- kmeans(team_cluster_data, centers = 3, nstart = 25)
all_teams$Cluster <- as.factor(team_kmeans$cluster)

# Visualize team clusters
fviz_cluster(team_kmeans, data = team_cluster_data, geom = "point", ellipse.type = "norm") +
  ggtitle("Team Clusters Based on Performance Attributes")


ui <- fluidPage(
  titlePanel("FIFA Player Analytics Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("cluster", "Select Cluster:", choices = unique(player_data$Cluster)),
      numericInput("age", "Player Age:", value = 25, min = 16, max = 40)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Cluster Visualization", plotOutput("clusterPlot")),
        tabPanel("Prediction", verbatimTextOutput("predictionOutput"))
      )
    )
  )
)

server <- function(input, output) {
  output$clusterPlot <- renderPlot({
    fviz_cluster(kmeans_result, data = cluster_data, geom = "point", ellipse.type = "norm")
  })
  
  output$predictionOutput <- renderPrint({
    new_player <- data.frame(
      overall = 85,
      potential = 90,
      pace = 85,
      shooting = 80,
      passing = 78,
      dribbling = 88,
      defending = 65,
      physic = 75
    )
    predict(rf_model, newdata = new_player)
  })
}

shinyApp(ui, server)

