Compilazione d’espressioni regolari in automi nondeterministici

I. Introduzione

- Tipologie di Operatori di Regular Expression accettate:
	a) (seq RE1, RE2, RE3, ... REn)			definita come "Concatenazione di espressioni regolari"
	b) (or RE1, RE2, RE3, ... REn)			definita come "Una delle espressioni regolari"
	c) (star RE)					definita come "Chiusura di Kleene"
	d) (plus RE)					definita come "Concatenazione di RE alla Chiusura di Kleene di RE"
	star, plus accettano al più un argomento
	
- Costruzione di epsilon-NFA mediante Algoritmo di Thompson

II. Documentazione

Funzioni
			
- is-regexp			(RE)		Verifica che RE sia una Regexp Accettabile
- nfa-regexp-comp		(RE)		Costruisce l'automa per RE
- nfa-test			(nfa, RE)	Test per l'automa data una Lista di input