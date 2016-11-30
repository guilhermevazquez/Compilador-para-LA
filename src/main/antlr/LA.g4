grammar LA;

programa : declaracoes 'algoritmo' corpo 'fim_algoritmo' ;

declaracoes : decl_local_global declaracoes | /* epsilon */ ;

decl_local_global : declaracao_local | declaracao_global ;

declaracao_local : 'declare' variavel 
                   | 'constante' dclLocalConst=IDENT ':' tipo_basico  '=' valor_constante
                   | 'tipo' dclLocalTipo=IDENT ':' tipo ;

variavel : IDENT dimensao mais_var ':' tipo ;

mais_var : ',' IDENT dimensao mais_var | /* epsilon */ ;

identificador : ponteiros_opcionais IDENT dimensao outros_ident ;

ponteiros_opcionais : '^' ponteiros_opcionais | /* epsilon */ ;

outros_ident : '.' identificador | /* epsilon */ ;

dimensao : '[' exp_aritmetica ']' dimensao | /* epsilon */ ;

tipo : registro | tipo_estendido ;

mais_ident : ',' identificador mais_ident | /* epsilon */ ;

mais_variaveis  : variavel mais_variaveis | /* epsilon */ ;

tipo_basico : 'literal' | 'inteiro' | 'real' | 'logico' ;

tipo_basico_ident : tipo_basico | IDENT ; 

tipo_estendido : ponteiros_opcionais tipo_basico_ident ;

valor_constante	: CADEIA | NUM_INT | NUM_REAL | 'verdadeiro' | 'falso' ;

registro : 'registro' variavel mais_variaveis 'fim_registro' ;

declaracao_global	: 'procedimento' dclGlobalProcedimento=IDENT '(' parametros_opcional ')' declaracoes_locais comandos 'fim_procedimento'		     
			              | 'funcao' dclGlobalFuncao=IDENT '(' parametros_opcional ')' ':' tipo_estendido declaracoes_locais comandos 'fim_funcao' ;

parametros_opcional	: parametro | /* epsilon */ ;

parametro	: var_opcional identificador mais_ident ':' tipo_estendido mais_parametros ;

var_opcional : 'var' | /* epsilon */ ;

mais_parametros	: ',' parametro | /* epsilon */ ;

declaracoes_locais : declaracao_local declaracoes_locais | /* epsilon */ ;

corpo : declaracoes_locais comandos ;

comandos : cmd comandos | /* epsilon */ ;

cmd	: 'leia' '(' identificador mais_ident ')'
			| 'escreva' '(' expressao mais_expressao ')'
			| 'se' expressao 'entao' comandos senao_opcional 'fim_se'
		  | 'caso' exp_aritmetica 'seja' selecao senao_opcional 'fim_caso'
			| 'para' IDENT '<-' exp_aritmetica 'ate' exp_aritmetica 'faca' comandos 'fim_para'
			| 'enquanto' expressao 'faca' comandos 'fim_enquanto'
			| 'faca' comandos 'ate' expressao
			| '^' IDENT outros_ident dimensao '<-' expressao
			| IDENT chamada_atribuicao
			| cmdReturn='retorne' expressao ;

mais_expressao : ',' expressao mais_expressao | /* epsilon */ ;

senao_opcional : 'senao' comandos | /* epsilon */ ;

chamada_atribuicao : '(' argumentos_opcional ')' | outros_ident dimensao '<-' expressao ;

argumentos_opcional : expressao mais_expressao | /* epsilon */ ;

selecao : constantes ':' comandos mais_selecao ;

mais_selecao : selecao | /* epsilon */ ;

constantes : numero_intervalo mais_constantes ;

mais_constantes : ',' constantes | /* epsilon */ ;

numero_intervalo : op_unario NUM_INT intervalo_opcional ;

intervalo_opcional : '..' op_unario NUM_INT | /* epsilon */ ;

op_unario : '-' | /* epsilon */ ;

exp_aritmetica : termo outros_termos ;

op_multiplicacao : '*' | '/' ;

op_adicao : '+' | '-' ;

termo : fator outros_fatores ;

outros_termos : op_adicao termo outros_termos | /* epsilon */ ;

fator : parcela outras_parcelas ;

outros_fatores : op_multiplicacao fator outros_fatores  | /* epsilon */ ;

parcela : op_unario parcela_unario | parcela_nao_unario ;

parcela_unario : '^' IDENT outros_ident dimensao | puNomeFuncao=IDENT chamada_partes | NUM_INT | NUM_REAL | '(' expressao ')' ;

parcela_nao_unario : '&' IDENT outros_ident dimensao | CADEIA ;

outras_parcelas : '%' parcela outras_parcelas | /* epsilon */ ;

chamada_partes : '(' expressao mais_expressao ')' | outros_ident dimensao | /* epsilon */ ;

exp_relacional : exp_aritmetica op_opcional ;

op_opcional : op_relacional exp_aritmetica | /* epsilon */ ;

op_relacional : '='  | '<>' | '>=' | '<=' | '>' | '<' ;

expressao : termo_logico outros_termos_logicos ;

op_nao : 'nao' | /* epsilon */ ;

termo_logico : fator_logico outros_fatores_logicos ;

outros_termos_logicos : 'ou' termo_logico outros_termos_logicos | /* epsilon */ ;

outros_fatores_logicos : 'e' fator_logico outros_fatores_logicos | /* epsilon */ ;

fator_logico : op_nao parcela_logica ;

parcela_logica : 'verdadeiro' |  'falso' | exp_relacional ;


                  
				  
		  
IDENT :      ('a'..'z' | 'A'..'Z' | '_') ('a'..'z' | 'A'..'Z' | '0'..'9' | '_')*;
NUM_INT :    ('0'..'9')+;
NUM_REAL :   ('0'..'9')+ '.' ('0'..'9')+;
CADEIA :     '"' ~('\n' | '\r' | '"')* '"';
WS : 		 [ \n\t\r]+ -> skip;
COMMENT:  	 '{' .*? '}' -> skip;
