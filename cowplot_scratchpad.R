library(cowplot)
library(dplyr)
library(ggplot2)
library(tibble)
library(viridis)

# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
# https://ggplot2.tidyverse.org/reference/ggtheme.html
# https://stackoverflow.com/questions/33438265/disable-cowplot-default-for-ggplots

# setwd
setwd("H:/R/cowplot")


starwars
starwars %>% ggplot(., aes(x = height)) + geom_histogram()

# after loading cowplot, the ggplot theme is changed, so all charts have cowplot's theme
library(cowplot)
starwars %>% ggplot(., aes(x = height)) + geom_histogram()

# can reset theme using theme_set
# theme_set(theme_classic())
# theme_set(theme_dark())
theme_set(theme_cowplot())

starwars %>% ggplot(., aes(x = height)) + geom_histogram()


#########################################################################


# can combine plots together
height_plot <- starwars %>% ggplot(., aes(x = height)) + geom_histogram()
height_plot

mass_plot <- starwars %>% ggplot(., aes(x = mass)) + geom_histogram()
mass_plot

plot_grid(height_plot, mass_plot, labels = c("height", "mass"))
plot_grid(height_plot, mass_plot, labels = c("height", "mass"), nrow = 2)


#########################################################################


# save plot
height_and_mass_plot <- plot_grid(height_plot, mass_plot, labels = c("height", "mass"))
height_and_mass_plot 

save_plot("height_and_mass_plot.png", height_and_mass_plot, ncol = 2, nrow = 2)
save_plot("height_and_mass_plot.pdf", height_and_mass_plot, ncol = 2, nrow = 2)


#########################################################################


# use ggdraw to draw overlays
plot.mpg <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + geom_point(size=2.5)
plot.mpg

plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() + theme(axis.text.x = element_text(angle=70, vjust=0.5))
plot.diamonds

# draw random boxes
boxes <- tibble(x = sample((0:33)/40, 40, replace = TRUE), y = sample((0:33)/40, 40, replace = TRUE))
boxes

# plot on top of annotations
ggdraw() + 
        geom_rect(data = boxes, aes(xmin = x, xmax = x + .15, ymin = y, ymax = y + .15),
                  colour = "gray60", fill = "gray80") +
        draw_plot(plot.mpg) +
        draw_label("Plot is on top of the grey boxes", x = 1, y = 1,
                   vjust = 1, hjust = 1, size = 10, fontface = 'bold')

# plot below annotations
ggdraw() + 
        draw_plot(plot.mpg) +
        geom_rect(data = boxes, aes(xmin = x, xmax = x + .15, ymin = y, ymax = y + .15),
                  colour = "gray60", fill = "gray80") + 
        draw_label("Plot is underneath the grey boxes", x = 1, y = 1,
                   vjust = 1, hjust = 1, size = 10, fontface = 'bold')


#########################################################################


# use ggdraw for inset graphics
ggdraw() +
        draw_plot(plot.diamonds + scale_fill_viridis(discrete = TRUE) + theme(legend.justification = "bottom"), 0, 0, 1, 1) +
        draw_plot(plot.mpg + scale_color_viridis(discrete = TRUE) + 
                          theme(legend.justification = "top"), 0.5, 0.52, 0.5, 0.4) +
        draw_plot_label(label = c("A", "B"), x = c(0, 0.5), y = c(1, 0.92), size = 15)


#########################################################################


# draw image
p <- ggplot(iris, aes(x=Sepal.Length, fill=Species)) + geom_density(alpha = 0.7)
ggdraw() + draw_plot(p) + draw_image("uscis_logo.jpg", x = 0, y = .47, width = .2)
ggdraw() + draw_plot(p) + draw_image("uscis_logo.jpg", x = .75, y = .47, width = .2)


















