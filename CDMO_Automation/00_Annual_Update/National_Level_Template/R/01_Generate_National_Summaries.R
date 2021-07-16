logout <- file(paste0("national_output.log"), open = "wt")
logmess <- file(paste0("national_message.log"), open = "wt")
sink(logout, append = FALSE, type = "output", split = FALSE)
sink(logmess, append = FALSE, type = "message", split = FALSE)

# Source files ------------
source('R/00_nat_setup/00_load_analyses_variables.R')

# ----------------------------------------------
# Make system map     --------------------------
# ----------------------------------------------
source('R/01_nat_plots/01-01_make_NERR_system_map.R')

# ----------------------------------------------
# Make trend maps of MET parameters     --------
# ----------------------------------------------
source('R/01_nat_plots/01-02_make_met_trend_maps.R')

# ----------------------------------------------
# Summarise reserve hand-off files   -----------
# ----------------------------------------------
source('R/01_nat_plots/01-03_summarise_national_trends.R')

message("End Generate_National_Summaries, closing log files ===================")
# End output and message redirection
sink(NULL, type = "output")
sink(NULL, type = "message")
for(i in seq_len(sink.number())){  # Just in case there are more
  sink(NULL)
}
close(logout)
close(logmess)
