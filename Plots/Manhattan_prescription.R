# Coded using:
# https://r-graph-gallery.com/101_Manhattan_plot.html
# https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/

# Manhattan plots
library(tidyverse)
library(ggtext)
library(data.table)
library(patchwork)

anti <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/antipsychotics.pheno_logistic.assoc")
anti_gwas <- anti[,c(1,2,3,7)]
names(anti_gwas) <- c("CHR", "SNP", "BP", "P")

anti_gwas %>% 
  filter(-log10(P)>1)

don <- anti_gwas %>% 
  
  # Compute chromosome size
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  
  # Calculate cumulative position of each chromosome
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  
  # Add this info to the initial dataset
  left_join(anti_gwas, ., by=c("CHR"="CHR")) %>%
  
  # Add a cumulative position of each SNP
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

axisdf = don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8

pb <- ggplot(don, aes(x=BPcum, y=-log10(P))) +
  
  # Show all points
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  
  # Add significance line
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  
  # custom X axis:
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +     # remove space between plot area and x axis

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
  ggtitle("B. Antipsychotics Prescription")

# I want to do the same for all of these
benzo <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/benzo.pheno_logistic.assoc")
cloz <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/clozapine.pheno_logistic.assoc")
first <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/first_gen.pheno_logistic.assoc")
nanti <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/n_antipsychotics.pheno_linear.assoc")
second <- fread("~/Documents/Local_LDAK/Downloads/prescription_GWAS/second_gen.pheno_logistic.assoc")

# Repeat the same steps for each dataset
benzo_gwas <- benzo[,c(1,2,3,7)]
names(benzo_gwas) <- c("CHR", "SNP", "BP", "P")
benzo_gwas %>% 
  filter(-log10(P)>1)
benzo_don <- benzo_gwas %>% 
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  left_join(benzo_gwas, ., by=c("CHR"="CHR")) %>%
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

benzo_axisdf = benzo_don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

sig <- 5*10^-8
pe <- ggplot(benzo_don, aes(x=BPcum, y=-log10(P))) +
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  scale_x_continuous( label = benzo_axisdf$CHR, breaks= benzo_axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("E. Benzo Prescription")

cloz_gwas <- cloz[,c(1,2,3,7)]
names(cloz_gwas) <- c("CHR", "SNP", "BP", "P")
cloz_gwas %>% 
  filter(-log10(P)>1)
cloz_don <- cloz_gwas %>% 
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  left_join(cloz_gwas, ., by=c("CHR"="CHR")) %>%
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

cloz_axisdf = cloz_don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

pf <- ggplot(cloz_don, aes(x=BPcum, y=-log10(P))) +
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  scale_x_continuous( label = cloz_axisdf$CHR, breaks= cloz_axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("F. Clozapine Prescription")

first_gwas <- first[,c(1,2,3,7)]
names(first_gwas) <- c("CHR", "SNP", "BP", "P")
first_gwas %>% 
  filter(-log10(P)>1)
first_don <- first_gwas %>% 
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  left_join(first_gwas, ., by=c("CHR"="CHR")) %>%
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

first_axisdf = first_don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

pc <- ggplot(first_don, aes(x=BPcum, y=-log10(P))) +
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  scale_x_continuous( label = first_axisdf$CHR, breaks= first_axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("C. First Generation Prescription")

nanti_gwas <- nanti[,c(1,2,3,7)]
names(nanti_gwas) <- c("CHR", "SNP", "BP", "P")
nanti_gwas %>% 
  filter(-log10(P)>1)
nanti_don <- nanti_gwas %>% 
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  left_join(nanti_gwas, ., by=c("CHR"="CHR")) %>%
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

nanti_axisdf = nanti_don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

pa <- ggplot(nanti_don, aes(x=BPcum, y=-log10(P))) +
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  scale_x_continuous( label = nanti_axisdf$CHR, breaks= nanti_axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("A. Number of Antipsychotics Prescription")

second_gwas <- second[,c(1,2,3,7)]
names(second_gwas) <- c("CHR", "SNP", "BP", "P")
second_gwas %>% 
  filter(-log10(P)>1)
second_don <- second_gwas %>% 
  group_by(CHR) %>% 
  summarise(chr_len=max(BP)) %>% 
  mutate(tot=cumsum(as.numeric(chr_len))-chr_len) %>%
  select(-chr_len) %>%
  left_join(second_gwas, ., by=c("CHR"="CHR")) %>%
  arrange(CHR, BP) %>%
  mutate( BPcum=BP+tot)

second_axisdf = second_don %>%
  group_by(CHR) %>%
  summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

pd <- ggplot(second_don, aes(x=BPcum, y=-log10(P))) +
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("#276FBF", "#183059"), 22 )) +
  geom_hline(
    yintercept = -log10(sig), color = "grey40",
    linetype = "dashed"
  ) +
  scale_x_continuous( label = second_axisdf$CHR, breaks= second_axisdf$center ) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 15)) +
  labs(
    x = NULL,
    y = "-log<sub>10</sub>(p)"
  ) +
  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown()
  ) +
  ggtitle("D. Second Generation Prescription")

pa + pb + pc + pd + pe + plot_layout(ncol = 1, axis_titles = "collect") 
pf
