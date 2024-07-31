# Manhattan plots
library(tidyverse)
library(ggtext)
library(data.table)
library(patchwork)

cannabis <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/cannabis.pheno.assoc")
cannabis_gwas <- cannabis[,c(1,2,3,7)]
names(cannabis_gwas) <- c("CHR", "SNP", "BP", "P")
cannabis_gwas %>% 
  filter(-log10(P)>1)

don_cannabis <- cannabis_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(cannabis_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_cannabis = don_cannabis %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_cannabis <- ggplot(don_cannabis, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_cannabis$CHR, breaks= axisdf_cannabis$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("B. Cannabis")

ever_smoked <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/ever_smoked.pheno.assoc")
ever_smoked_gwas <- ever_smoked[,c(1,2,3,7)]
names(ever_smoked_gwas) <- c("CHR", "SNP", "BP", "P")
ever_smoked_gwas %>% 
  filter(-log10(P)>1)

don_ever_smoked <- ever_smoked_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(ever_smoked_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_ever_smoked = don_ever_smoked %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_ever_smoked <- ggplot(don_ever_smoked, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_ever_smoked$CHR, breaks= axisdf_ever_smoked$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("C. Smoking")

handed <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/handed.pheno.assoc")
handed_gwas <- handed[,c(1,2,3,7)]
names(handed_gwas) <- c("CHR", "SNP", "BP", "P")
handed_gwas %>% 
  filter(-log10(P)>1)

don_handed <- handed_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(handed_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_handed = don_handed %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_handed <- ggplot(don_handed, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_handed$CHR, breaks= axisdf_handed$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("E. Handedness")

height <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/height.pheno.assoc")
height_gwas <- height[,c(1,2,3,7)]
names(height_gwas) <- c("CHR", "SNP", "BP", "P")
height_gwas %>% 
  filter(-log10(P)>1)

don_height <- height_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(height_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_height = don_height %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_height <- ggplot(don_height, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_height$CHR, breaks= axisdf_height$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("H. Height")

insomnia_cont <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/insomnia_cont.pheno.assoc")
insomnia_cont_gwas <- insomnia_cont[,c(1,2,3,7)]
names(insomnia_cont_gwas) <- c("CHR", "SNP", "BP", "P")
don_insomnia_cont <- insomnia_cont_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(insomnia_cont_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_insomnia_cont = don_insomnia_cont %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_insomnia_cont <- ggplot(don_insomnia_cont, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_insomnia_cont$CHR, breaks= axisdf_insomnia_cont$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("A. Insomnia")

month <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/month.pheno.assoc")
month_gwas <- month[,c(1,2,3,7)]
names(month_gwas) <- c("CHR", "SNP", "BP", "P")
month_gwas %>% 
  filter(-log10(P)>1)
don_month <- month_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(month_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_month = don_month %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_month <- ggplot(don_month, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_month$CHR, breaks= axisdf_month$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("D. Winter birth")

psychage <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/psychage.pheno.assoc")
psychage_gwas <- psychage[,c(1,2,3,7)]
names(psychage_gwas) <- c("CHR", "SNP", "BP", "P")
psychage_gwas %>% 
  filter(-log10(P)>1)
don_psychage <- psychage_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(psychage_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_psychage = don_psychage %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_psychage <- ggplot(don_psychage, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_psychage$CHR, breaks= axisdf_psychage$center ) +
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("G. Psychage")

vitamin_d <- fread("~/Documents/Local_LDAK/Downloads/GWAS_results/vitamin_d.pheno.assoc")
vitamin_d_gwas <- vitamin_d[,c(1,2,3,7)]
names(vitamin_d_gwas) <- c("CHR", "SNP", "BP", "P")
vitamin_d_gwas %>% 
  filter(-log10(P)>1)
don_vitamin_d <- vitamin_d_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(vitamin_d_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf_vitamin_d = don_vitamin_d %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pb_vitamin_d <- ggplot(don_vitamin_d, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf_vitamin_d$CHR, breaks= axisdf_vitamin_d$center ) + 
  scale_y_continuous(expand = c(0, 0)) +     # remove space between plot area and x axis
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  # Custom the theme:
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("F. Vitamin D deficiency")

pb_insomnia_cont + pb_cannabis + pb_ever_smoked + pb_month + pb_handed + plot_layout(ncol = 1, axis_titles = "collect") 

pb_vitamin_d + pb_psychage + pb_height + plot_layout(ncol = 1, axis_titles = "collect") 
