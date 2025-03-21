
global git_path "/Users/guillaumedaudin/Répertoires Git/2016-Hamburg-Impact-of-War"

*For n-gram graph
do "$git_path/Do-files/To create graphs/Pour intro N-gram.do"

*For db French, British trade and Anglo-French wars
do "$git_path/Do-files/To create databases/for_total_and_bilateral_trade.do"
**This requires the following files: bdd courante.dta. bdd courante.dta is the database of Toflit18. It can be obtained in that depository**
*For graph French, British trade and Anglo-French wars
do "$git_path/Do-files/To create graphs/compare trade graph.do"

do "$git_path/Do-files/To compute re-exports and others.do"
do "$git_path/Do-files/Change in composition of trade.do" /*Currently broken*/

*Predation DB (+ some graphs)
do "$git_path/Do-files/To create databases/For prizes db.do"
**The prize database increases through time because it depends on the size of French (potential) trade. We transform it as 
** a ratio to predicted peace-time trade in the following file
** We also create a cumulated prize variable, which is more interesting than the annual losses.
do "$git_path/Do-files/To create databases/Transformation prizes db.do"


*Budget DB and graph
do "$git_path/Do-files/To create databases/For FR and GB budgets.do"
do "$git_path/Do-files/To create graphs/Budgets.do"



do "$git_path/Do-files/To create databases/To gen loss of colony variable.do"
do "$git_path/Do-files/To create databases/To gen battle variable.do"
do "$git_path/Do-files/To create databases/To gen war & period variables.do"

*For loss functions and graphs
do "$git_path/Do-files/To create databases/Loss computation FR.do" //This also creates simple graphs
do "$git_path/Do-files/To create databases/Loss computation GB.do" //This also creates simple graphs
do "$git_path/Do-files/To create graphs/Annual and Mean Loss graph.do"
do "$git_path/Do-files/To create graphs/Annual and Mean Loss graphGB.do"


*Share of French trade by sea
do "$git_path/Do-files/To create graphs/Pour commerce de terre.do"


*Regressions effect of wartime strategies
do "$git_path/Do-files/To see results/war_strategies_reg.do" //This also includes creating the battle variable.