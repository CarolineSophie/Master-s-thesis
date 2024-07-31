# Create data file containing information about the patients date of diagnosis and age at illness onset

//////////////////////////////////////////////////////////////////////
# Date of diagnosis #
//////////////////////////////////////////////////////////////////////

# In the directory /home/caroline/snpher/faststorage/biobank/newphens

/home/caroline/snpher/faststorage/biobank/newphens/icd.txt
/home/caroline/snpher/faststorage/biobank/newphens/icddates.txt

# First I check the dimensions of the files, and make sure that they have the same dimensions:
conda activate caroline
R

icd <- read.table("/home/caroline/snpher/faststorage/biobank/newphens/icd.txt", header = TRUE)
icddates <- read.table("/home/caroline/snpher/faststorage/biobank/newphens/icddates.txt", header = TRUE)

identical(icd$eid, icddates$eid)

# dim(icd)
# dim(icddates)
dim(icd) == dim(icddates)

library(dplyr)
library(tidyr)

# Convert the conditions dataset to long format
long_conditions <- pivot_longer(
  data = icd,
  cols = starts_with("X")
)

# Convert the dates dataset to long format
long_dates <- pivot_longer(
  data = icddates,
  cols = starts_with("X")
)


merged_data <- cbind(long_conditions, Date = long_dates$value)

# Filter the dataset for entries with value "A" or "B"
filtered_data <- merged_data %>%
  filter(value %in% c("F20", "F200", "F201", "F202", "F203", "F204", "F205", "F206", "F208", "F209"))

# Convert the Date column to a Date type
filtered_data$Date <- as.Date(filtered_data$Date)

# Group by ID and select the row with the earliest date for each group
result_data <- filtered_data %>%
  group_by(eid) %>%
  filter(Date == min(Date, na.rm = TRUE))

# Print the result
print(result_data)

data <- result_data %>% select(-name)

# Save as a tab-delimited text file
write.table(data, "/home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_diagnosis_dates.txt", sep = "\t", row.names = FALSE)

_______________________________________________________________

//////////////////////////////////////////////////////////////////////
# Month and year of birth #
//////////////////////////////////////////////////////////////////////

month <- read.table("/home/caroline/snpher/faststorage/biobank/newphens/month.txt", header = TRUE)
year <- read.table("/home/caroline/snpher/faststorage/biobank/newphens/year.txt", header = TRUE)

identical(month$eid, year$eid) # Check that the files have the same dimensions/order of individuals

merged_data <- cbind(month, year = (year)[,2])

write.table(merged_data, "/home/caroline/dsmwpred/caroline/data/UKBB_SZ/patient_age.txt", sep = "\t", row.names = FALSE)

//////////////////////////////////////////////////////////////////////
# Age at illness onset #
//////////////////////////////////////////////////////////////////////

dates <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_diagnosis_dates.txt", header = TRUE)
age <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/patient_age.txt", header = TRUE)

merged_df <- merge(dates, age, by = "eid")

# Create a new column with formatted dates
merged_df$full_date <- as.Date(sprintf("%04d-%02d-01", merged_df$year, merged_df$month))

# Print the updated data frame
print(merged_df)


merged_df$diagnosis_age_exact <- as.numeric(difftime(merged_df$full_date, merged_df$Date, units = "auto") / 365.25)

merged_df$diagnosis_age <- trunc(abs(merged_df$diagnosis_age_exact))

write.table(merged_df, "/home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_diagnosis_age.txt", sep = "\t", row.names = FALSE)

