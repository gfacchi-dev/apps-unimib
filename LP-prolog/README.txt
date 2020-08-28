Linguaggi di Programmazione 2019-2020 Progetto Prolog gennaio 2020 E1P
Compilazione d’espressioni regolari in automi nondeterministici

I. Introduzione

- Tipologie di Regular Expression accettate:
	a) atomic(RE)
	b) compound(RE) \ {seq(RE), or(RE), plus(RE), star(RE)}

- Tipologie di Operatori di Regular Expression accettate:
	a) seq(RE1, RE2, RE3, ... REn)	definita come "Concatenazione di espressioni regolari"
	b) or(RE1, RE2, RE3, ... REn)	definita come "Una delle espressioni regolari"
	c) star(RE)			definita come "Chiusura di Kleene"
	d) plus(RE)			definita come "Concatenazione di RE alla Chiusura di Kleene di RE"
	e) Vengono accettati anche or e seq di arità 1

- Costruzione di epsilon-NFA mediante Algoritmo di Thompson

- epsilon-NFA univoci mediante l'assegnazione di un FA_Id al momento della creazione

II. Documentazione

Predicati
			
- is_regexp/1		(RE)				Verifica che RE sia una Regexp Accettabile
- not_regexp/1		(RE)				Verifica che RE non sia un funtore riservato
- not_exists_nfa/1	(FA_Id)				Verifica che FA_Id non sia già contenuto nella base di dati Prolog
- exists_nfa/1		(FA_Id)				Verifica che FA_Id sia già contenuto nella base di dati Prolog
- nfa_regexp_comp/2	(Id, RE)			Costruisce l'automa per RE
- nfa_regexp_comp/4	(Id, Initial, RE, Final)	Costruisce l'automa per RE dati Initial e Final
- nfa_test/2		(Id, RE)			Test per l'automa data una Lista di input
- nfa_test/3		(Id, RE, Q)			Test per l'automa data una Lista di input fino allo stato Q
- nfa_list/1		(Id)				Visualizza stati iniziali, stati intermedi e stati finali di un automa 
- nfa_clear/1		(Id)				Rimuove un automa dalla base di dati Prolog
- nfa_clear/0		()				Rimuove tutti gli automi dalla base dati di Prolog

