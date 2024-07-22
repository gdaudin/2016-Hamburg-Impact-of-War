
global git_path "/Users/guillaumedaudin/Répertoires Git/2016-Hamburg-Impact-of-War"

*For n-gram graph
do "$git_path/Do-files/To create graphs/Pour intro N-gram.do"

*For graph French, British trade and Anglo-French wars
do "$git_path/Do-files/To create databases/for_total_and_bilateral_trade.do"
**This requires the following files: bdd courante.dta. bdd courante.dta is the database of Toflit18. It can be obtained in that depository**

do "$git_path/Do-files/To compute re-exports and others.do"
do "$git_path/Do-files/Change in composition of trade.do" /*Currently broken*/

*Predation DB (+ some graphs)
do "$git_path/Do-files/To create databases/For prizes db.do"
do "$git_path/Do-files/To create databases/To gen loss of colony variable.do"

*For loss functions and graphs
do "$git_path/Do-files/To create graphs/Annual and Mean Loss graph.do"
do "$git_path/Do-files/To create graphs/Annual and Mean Loss graphGB.do"


*Share of French trade by sea
do "$git_path/Do-files/To create graphs/Pour commerce de terre.do"


*Regressions effect of wartime strategies
do "$git_path/Do-files/To see results/war_strategies_reg.do"