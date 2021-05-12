halt = function(hint = "Combination not available \n Process stopped.\n") {
  writeLines(hint)
  require(tools, quietly = TRUE)
  processId = Sys.getpid() 
  pskill(processId, SIGINT)
  iddleTime = 1.00
  Sys.sleep(iddleTime)
}