Function main()
cls
set color to g+/
set century on
set date to british

@ 1,0 say "-------------------------------------------------------------------------------"
@ 2,0 say "pqavs_indi.exe - versao beta - 19/08/2025                                      " 
@ 3,0 say "Calcula alguns dos indicadores referenciados no PQAVS.                         "
@ 4,0 say "Sintaxe: [codigo IBGE do municipio com 6 digitos] [codigo do indicador] --auto "
@ 5,0 say "Exemplo: pqavs_indi.exe 521523 13                                              "
@ 6,0 say "-------------------------------------------------------------------------------"

cArg1 := alltrim ( HB_ArgV ( 1 ) )
cArg2 := alltrim ( HB_ArgV ( 2 ) )

if empty ( cArg1 ) = .T.
set color to r+/
? "Erro! Falta o argumento 'codigo IBGE do municipio' na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

if empty ( cArg2 ) = .T.
set color to r+/
? "Erro! Falta o argumento 'codigo do indicador' na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

set color to w+/
@ 7,0 say "Codigo do municipio: " + alltrim ( cArg1 )
@ 8,0 say "Codigo do indicador: " + alltrim ( cArg2 )
set color to g+/

if cArg2 = "13"

@ 9,0 say "Transferindo arquivos..."

cOrigem1 := "c:\pqavs_indi\dbf\acbionet.dbf"
cDestino1 := "c:\pqavs_indi\tmp\acbionet.dbf"

cOrigem2 := "c:\pqavs_indi\dbf\acgranet.dbf"
cDestino2 := "c:\pqavs_indi\tmp\acgranet.dbf"

cOrigem3 := "c:\pqavs_indi\dbf\iexognet.dbf"
cDestino3 := "c:\pqavs_indi\tmp\iexognet.dbf"

copy file ( cOrigem1 ) to ( cDestino1 )
copy file ( cOrigem2 ) to ( cDestino2 )
copy file ( cOrigem3 ) to ( cDestino3 )

@ 10,0 say "Ajustando arquivo de intoxicacao exogena..."
use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for doenca_tra <> "1"
pack
close

@ 11,0 say "Ajustando arquivos para o municipio escolhido pelo usuario..."

use "c:\pqavs_indi\tmp\acbionet.dbf"
delete for id_mn_resi <> cArg1
pack
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
delete for id_mn_resi <> cArg1
pack
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for id_mn_resi <> cArg1
pack
close

@ 12,0 say "Calculando total de casos dos agravos..."
public nAtmbio_tot, nAt_tot, nIert_tot
public nAtmbio_ocup_ok, nAt_ocup_ok, nIert_ocup_ok
public nAtmbio_cnae_ok, nAt_cnae_ok, nIert_cnae_ok

use "c:\pqavs_indi\tmp\acbionet.dbf"
nAtmbio_tot := reccount()
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
nAt_tot := reccount()
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
nIert_tot := reccount()
close

@ 13,0 say "Ajustando arquivos para calcular proporcao de ocupacao..."
use "c:\pqavs_indi\tmp\acbionet.dbf"
delete for ( empty( id_ocupa_n ) = .T. ) .or. ( id_ocupa_n = "XXX" ) .or. ( id_ocupa_n = "000000" )
pack
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
delete for ( empty( id_ocupa_n ) = .T. ) .or. ( id_ocupa_n = "XXX" ) .or. ( id_ocupa_n = "000000" )
pack
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for ( empty( id_ocupa_n ) = .T. ) .or. ( id_ocupa_n = "XXX" ) .or. ( id_ocupa_n = "000000" )
pack
close

use "c:\pqavs_indi\tmp\acbionet.dbf"
nAtmbio_ocup_ok := reccount()
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
nAt_ocup_ok := reccount()
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
nIert_ocup_ok := reccount()
close

@ 14,0 say "Valores calculados para proporcao do campo ocupacao:"
nNumerador1 := nAtmbio_ocup_ok + nAt_ocup_ok + nIert_ocup_ok
nDenominador1 := nAtmbio_tot + nAt_tot + nIert_tot
nProporcao1 := nNumerador1 / nDenominador1

@ 15,0 say "Numerador proporcao campo ocupacao: " + alltrim( str ( nNumerador1 ) )
@ 16,0 say "Denominador proporcao campo ocupacao: " + alltrim( str ( nDenominador1 ) )
set color to w+/
@ 17,0 say "Proporcao campo ocupacao: " + alltrim( str ( nProporcao1 ) )
set color to g+/

@ 18,0 say "Ajustando arquivos para calcular proporcao CNAE..."

use "c:\pqavs_indi\tmp\acbionet.dbf"
delete for empty( cnae ) = .T.
pack
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
delete for empty( cnae ) = .T.
pack
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for empty( cnae ) = .T.
pack
close

use "c:\pqavs_indi\tmp\acbionet.dbf"
nAtmbio_cnae_ok := reccount()
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
nAt_cnae_ok := reccount()
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
nIert_cnae_ok := reccount()
close

@ 19,0 say "Valores calculados para proporcao do campo CNAE:"
nNumerador2 := nAtmbio_cnae_ok + nAt_cnae_ok + nIert_cnae_ok
nDenominador2 := nAtmbio_tot + nAt_tot + nIert_tot
nProporcao2 := nNumerador2 / nDenominador2

@ 20,0 say "Numerador proporcao campo CNAE: " + alltrim( str ( nNumerador2 ) )
@ 21,0 say "Denominador proporcao campo CNAE: " + alltrim( str ( nDenominador2 ) )
set color to w+/
@ 22,0 say "Proporcao campo CNAE: " + alltrim( str ( nProporcao2 ) )
set color to g+/

@ 23,0 say "Calculando o indicador..."
nNumerador3 := nProporcao1 + nProporcao2
nDenominador3 := 2
nProporcao3 := ( nNumerador3 / nDenominador3 ) * 100
set color to w+/
@ 24,0 say "Indicador:" + alltrim (str ( nProporcao3 ) ) + "%"
set color to g+/

* Cria tabela com os dados dos municipios incluidos no arquivo 'list_muns.txt" criado pelo usuario.
aStruct := { { "cod_mun","C",6,0 }, ;
           { "nomemun","C",70,0 }}
			 dbcreate ("c:\pqavs_indi\set\list_muns.dbf", aStruct)

use "c:\pqavs_indi\set\list_muns.dbf"
append from "c:\pqavs_indi\set\list_muns.txt" delimited with '"'
close			 		 
			 
aStruct2 := { { "cod_mun","C",6,0 }, ;
           { "nomemun","C",70,0 }, ;
           { "prop1","N",3,2 }, ;
           { "prop2","N",3,2 }, ;
           { "indic","N",3,2 }}
			 dbcreate ("c:\pqavs_indi\tmp\indicador_13.dbf", aStruct2)
					 
*use "c:\pqavs_indi\set\list_muns.dbf"
*locate for 
					 
					 
endif

return nil