library(terra)
library(lubridate)
library(sf)
library(dplyr)
library(readr)
library(randomForest)
library(caret)
library(ggplot2)
library(RColorBrewer)

fcc_path <- "D:/RStudio_3/RF/AOI/Clipped_FCC_NDVI.tif"
training_paths <- c("D:/RStudio_3/RF/Traning_Sample/Builtup.shp",
                    "D:/RStudio_3/RF/Traning_Sample/Range.shp",
                    "D:/RStudio_3/RF/Traning_Sample/Tree.shp",
                    "D:/RStudio_3/RF/Traning_Sample/Water.shp") 

fcc_raster <- rast(fcc_path)

training_shp <- lapply(training_paths, vect)

plotRGB(fcc_raster, r = 1, g = 2, b = 3, stretch = "lin", main = "FCC with Training Data")

colors <- c("red", "gray", "green", "blue")  
for (i in 1:length(training_shp)) {
  plot(training_shp[[i]], add = TRUE, col = colors[i], lwd = 2, border = colors[i])
}

legend("topright", legend = paste("Class", 1:4), fill = colors, border = "black")

output_csv <- "D:/RStudio_3/RF/Traning_Sample_CSV/Extracted_Training_Data.csv" 

class_names <- c("Builtup", "Range", "Tree", "Water") 
extracted_data_list <- list()

for (i in seq_along(training_paths)) {
  training_samples <- vect(training_paths[i]) 
  
  extracted_values <- extract(fcc_raster, training_samples)
  
  if (!is.null(extracted_values) && nrow(extracted_values) > 0) {
    df <- as.data.frame(extracted_values)
    
    if (ncol(df) == 5) {
      colnames(df) <- c("ID", "NIR", "Red", "Green", "NDVI")
      df <- df %>% select(-ID)
    } else {
      print(paste("Warning: Unexpected number of columns in extracted data for class", class_names[i]))
      print(colnames(df))
      next
    }

    df <- df %>%
      mutate(Sl_No = row_number()) %>%
      relocate(Sl_No) 
    
    df$Class <- class_names[i]
    
    extracted_data_list[[i]] <- df
  } else {
    print(paste("No valid data extracted for class:", class_names[i]))
  }
}

final_df <- bind_rows(extracted_data_list)

write_csv(final_df, output_csv)

print(paste("Training sample extraction complete. Data saved at", output_csv))

csv_file <- "D:/RStudio_3/RF/Traning_Sample_CSV/Extracted_Training_Data.csv"
training_data <- read_csv(csv_file)

training_data$Class <- as.factor(training_data$Class)

predictors <- training_data %>% select(-Sl_No, -Class)  
response <- training_data$Class  

set.seed(123) 
rf_model <- randomForest(x = predictors, y = response, ntree = 100, importance = TRUE)

model_path <- "D:/RStudio_3/RF/RF_Model/RandomForest_Model.rds"
saveRDS(rf_model, model_path)
print(paste("Random Forest model saved at:", model_path))

image_path <- "D:/RStudio_3/RF/AOI/Clipped_FCC_NDVI.tif"
fcc_raster <- rast(image_path)

fcc_df <- as.data.frame(fcc_raster, xy = TRUE, na.rm = TRUE)

colnames(fcc_df)[3:6] <- c("NIR", "Red", "Green", "NDVI")

predictions <- predict(rf_model, newdata = fcc_df)

fcc_df$Class <- predictions

class_raster <- terra::rast(fcc_raster[[1]]) 
values(class_raster) <- as.numeric(as.factor(fcc_df$Class))

classified_output <- "D:/RStudio_3/RF/Classified_Output/Classified_Image.tif"
writeRaster(class_raster, classified_output, overwrite = TRUE)
print(paste("Classified image saved at:", classified_output))

plot(class_raster, main = "Classified Image", col = brewer.pal(4, "Set1"))
legend("topright", legend = levels(response), fill = brewer.pal(4, "Set1"), border = "black")

print(rf_model)

conf_matrix <- rf_model$confusion
print(conf_matrix)

accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("Overall Accuracy:", round(accuracy * 100, 2), "%"))
