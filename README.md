# Projects Overview

## Partitioning Clustering Project

### Project Description:
In this project, I analyzed 2700 white wine samples from Portugal, focusing on 11 chemical properties excluding quality ratings. The main goal was to identify distinct groups within the data using clustering techniques.

### Data Preprocessing:
- **Scaling:** Standardized the data to have zero mean and unit variance.
- **Outlier Removal:** Identified and removed outliers to ensure the data quality.

### Determining Optimal Number of Clusters:
- **NBClust:** Used the NBClust package to evaluate multiple clustering indices.
- **Elbow Method:** Plotted the sum of squared distances to identify the optimal number of clusters.
- **Gap Statistics:** Compared the total within intra-cluster variation for different numbers of clusters with their expected values under null reference distribution.
- **Silhouette Method:** Used silhouette scores to evaluate the consistency within clusters.

### Clustering:
- **K-means Clustering:** Applied K-means clustering algorithm to the preprocessed data.

### Evaluation:
- **BSS/TSS Ratios:** Evaluated the clusters by calculating the Between-Cluster Sum of Squares to Total Sum of Squares ratio.
- **Silhouette Plots:** Used silhouette plots to visualize how close each point in one cluster is to the points in the neighboring clusters.

### Dimensionality Reduction:
- **Principal Component Analysis (PCA):** Reduced the dimensionality of the data and repeated the clustering analysis on the transformed data.

### Further Assessment:
- **Calinski-Harabasz Index:** Assessed the quality of the clusters using the Calinski-Harabasz Index, which evaluates the ratio of the sum of between-cluster dispersion and of within-cluster dispersion.

### Conclusion:
Improved the understanding of wine quality assessment through clustering analysis, highlighting the importance of chemical properties in distinguishing different groups of wine samples.

## Financial Forecasting Project

### Project Description:
In this project, I developed a multi-layer perceptron (MLP) neural network to forecast the next day's USD/EUR exchange rate using historical data from October 2011 to October 2013.

### Data Preprocessing:
- **Autoregressive Approach:** Created time-delayed input vectors up to t-4.
- **Normalization:** Normalized the data to improve the training performance of the neural network.

### Model Development:
- **MLP Neural Networks:** Experimented with various structures of MLP models.
- **Training:** Trained multiple MLP models with different numbers of hidden layers and neurons.

### Evaluation:
- **Statistical Indices:** Evaluated models using Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), Mean Absolute Percentage Error (MAPE), and Symmetric Mean Absolute Percentage Error (sMAPE).
- **Comparison Table:** Created a comparison table of testing performances to highlight the efficiency of one-hidden layer versus two-hidden layer networks.

### Visualization:
- **Predictions:** Visualized the best model's predictions and discussed the accuracy and reliability.

### Conclusion:
Demonstrated the potential of neural networks in financial forecasting, with a detailed comparison of different model structures and their performance.

