library(rgdal)
library(NWCEd)
library(ggplot2)
library(dataRetrieval)
wb_data <- readRDS("wb_data.rds")
for(ws in names(wb_data)) {
  an_e <- annualize(wb_data[[ws]]$et, 
                    method = sum)
  an_e$data <- an_e$data*0.0393701
  an_e$group <- "ET"
  an_p <- annualize(wb_data[[ws]]$prcp, 
                    method = sum)
  an_p$data <- an_p$data*0.0393701
  an_p$group <- "PR"
  da_sqft <- dataRetrieval::readNWISsite(wb_data[[ws]]$streamflow$site_no[1])$drain_area_va*27878400
  an_q <-annualize(setNames(wb_data[[ws]]$streamflow[c("Date", "data_00060_00003")], c("date", "data")), 
                   method = mean) 
  an_q$data <- an_q$data*(60 * 60 * 24 * 365.25) * 12/da_sqft
  an_q$group <- "Q"
  ts_plotData <- rbind(an_e, an_p, an_q)
  
  wb_chart_data <- data.frame(group = c("Precipitation", "Evapotranspiration", "Streamflow"),
                              value = c(mean(an_p$data), mean(an_e$data), mean(an_q$data)),
                              inout = c("In", "Out", "Out"))
  
  ggplot(wb_chart_data, 
         aes(inout, value, fill = factor(group, 
                                         levels=c("Precipitation", "Evapotranspiration", "Streamflow")))) + 
    geom_bar(stat = "identity") + theme(legend.title=element_blank()) + ylab("inches") + xlab("")
  
}



ggplot(ts_plotData, aes(x=year, y=data, group=group,colour = group)) +  geom_line() +
  scale_x_discrete(name = "year") + ylab("in") +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Basic Annual Plot", colour = "Explanation") +
  scale_color_manual(values=c("#990066", "#339966", "#FF0000"))
