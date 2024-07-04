
global git_path "/Users/guillaumedaudin/Répertoires Git/2016-Hamburg-Impact-of-War"

*For n-gram graph
do "$git_path/Do-files/To create graphs/Pour intro N-gram.do"


*For graph French, British trade and Anglo-French wars
do "$git_path/Do-files/To create databases/for_total_and_bilateral_trade.do"

do "$git_path/Do-files/To compute re-exports and others.do"

*Predation DB (+ some graphs)
do "$git_path/Do-files/To create databases/For prizes db.do"

*For loss functions
