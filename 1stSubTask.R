# Load the required libraries
library(dplyr)
library(ggplot2)
library(cluster)
library(readxl)
library(NbClust)
library(clusterCrit)
library(fpc)

# Load the dataset
wine_data <- read_excel("Whitewine_v6.xlsx")

#a
# Scaling the data
scaled_data <- scale(wine_data[,1:11])

# Outlier detection and removal
# Boxplot method for outlier detection and removal
outliers_removed <- scaled_data %>% 
  as.data.frame() %>% 
  filter_all(all_vars(between(., quantile(., 0.25) - 1.5*IQR(.), quantile(., 0.75) + 1.5*IQR(.))))


# Justification for outlier removal: 
# Outliers can significantly affect clustering results by skewing the centroids 
# and increasing the variability within clusters. Removing outliers helps improve the quality of clustering by reducing 
# noise and ensuring clusters are more representative of the data distribution.

#b
# Using NBclust for determining the number of clusters
nb_clusters <- NbClust(outliers_removed, distance = "euclidean", min.nc = 2, max.nc = 10, method = "complete")

# Elbow method
wss <- numeric(10)
for (i in 1:10) {
  kmeans_model <- kmeans(outliers_removed, centers = i)
  wss[i] <- kmeans_model$tot.withinss
}
elbow_plot <- ggplot(data.frame(k = 1:10, WSS = wss), aes(x = k, y = WSS)) +
  geom_line() +
  geom_point() +
  labs(x = "Number of Clusters (k)", y = "Within Sum of Squares (WSS)", title = "Elbow Method")

# Gap statistic
gap_statistic <- clusGap(outliers_removed, FUN = kmeans, nstart = 25, K.max = 10, B = 50)

# Silhouette method
silhouette_scores <- numeric(10)
for (i in 2:10) {
  kmeans_model <- kmeans(outliers_removed, centers = i)
  silhouette_scores[i] <- mean(silhouette(kmeans_model$cluster, dist(outliers_removed))$widths)
}

#c
# Perform clustering analysis to determine the best number of clusters
nb_clusters <- NbClust(data = outliers_removed, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")

# Get the best number of clusters
best_k <- nb_clusters$Best.nc[1]

# Proceed with k-means clustering using the best number of clusters
kmeans_model <- kmeans(outliers_removed, centers = best_k)

# Calculate BSS and WSS
BSS <- sum(kmeans_model$betweenss)
WSS <- kmeans_model$tot.withinss
TSS <- BSS + WSS
BSS_ratio <- BSS / TSS

# Output kmeans results
print(kmeans_model)
print(BSS_ratio)

#d
# Silhouette plot
silhouette_plot <- silhouette(kmeans_model$cluster, dist(outliers_removed))
plot(silhouette_plot)

# Average silhouette width score
avg_silhouette <- mean(silhouette_plot$widths)

# Discussion on silhouette plot
# The silhouette plot shows how well each point fits within its cluster and how distinct the clusters are from each other. 
# A higher average silhouette width indicates better clustering quality, with values closer to 1 indicating well-separated clusters.

#e
# Perform PCA analysis
pca_result <- prcomp(outliers_removed, scale = TRUE)

# Eigenvalues and eigenvectors
eigenvalues <- pca_result$sdev^2
eigenvectors <- pca_result$rotation

# Cumulative score per principal components
cumulative_score <- cumsum(pca_result$sdev^2 / sum(pca_result$sdev^2))

# Select PCs with cumulative score > 85%
selected_PCs <- which(cumulative_score > 0.85)[1]

# Transform the dataset using selected PCs
transformed_data <- as.data.frame(predict(pca_result, newdata = outliers_removed)[, 1:selected_PCs])

#f
# Determine the best number of clusters for the PCA-based dataset
nb_clusters_pca <- NbClust(data = transformed_data, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")

# Get the best number of clusters for PCA-based dataset
best_k_pca <- nb_clusters_pca$Best.nc[1]

#g
# Perform k-means clustering using the best number of clusters for PCA-based dataset
kmeans_model_pca <- kmeans(transformed_data, centers = best_k_pca)

# Calculate BSS, WSS, and TSS for PCA-based k-means
BSS_pca <- sum(kmeans_model_pca$betweenss)
WSS_pca <- kmeans_model_pca$tot.withinss
TSS_pca <- BSS_pca + WSS_pca
BSS_ratio_pca <- BSS_pca / TSS_pca

#h
# Silhouette plot for PCA-based k-means
silhouette_plot_pca <- silhouette(kmeans_model$cluster, dist(transformed_data))
plot(silhouette_plot_pca)

# Average silhouette width score for PCA-based k-means
avg_silhouette_pca <- mean(silhouette_plot_pca$widths)

#i
# Calinski-Harabasz Index for PCA-based k-means
calinski_harabasz_index <- calinski.test(transformed_data, kmeans_model_pca$cluster)$criterion

# Plot Calinski-Harabasz Index
clusplot(transformed_data, kmeans_model_pca$cluster, color = TRUE, shade = TRUE, labels = 2, lines = 0, 
         main = paste("Calinski-Harabasz Index =", round(calinski_harabasz_index, 2)))
