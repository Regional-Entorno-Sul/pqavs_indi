Function main()
cls
set color to w/bg+
set century on
set date to british
set decimals to 2

@ 1,0 say "-------------------------------------------------------------------------------"
@ 2,0 say "pqavs_indi.exe - 1.1 - 25/08/2025                                              "
@ 3,0 say "Calcula alguns dos indicadores referenciados no PQAVS.                         "
@ 4,0 say "Sintaxe:                                                                       "
@ 5,0 say "--auto [codigo do indicador]                                                   "
@ 6,0 say "--mun [codigo do indicador] [codigo IBGE do municipio com 6 digitos]           "
@ 7,0 say "Exemplo: pqavs_indi.exe --auto 13                                              "
@ 8,0 say "         pqavs_indi.exe --mun 13 521523                                        "
@ 9,0 say "-------------------------------------------------------------------------------"

set color to g+/

cArg1 := alltrim ( HB_ArgV ( 1 ) )
cArg2 := alltrim ( HB_ArgV ( 2 ) )
cArg3 := alltrim ( HB_ArgV ( 3 ) )

if empty( cArg1 ) = .T. .and. empty( cArg2 ) = .T. .and. empty( cArg3 ) = .T.
set color to r+/
? "Erro! Falta os argumentos obrigatorios na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

if cArg1 = "--auto" .and. empty( cArg2 ) = .T.
set color to r+/
? "Erro! Falta o argumento 'codigo do indicador' na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

if cArg1 = "--mun" .and. empty( cArg2 ) = .T.
set color to r+/
? "Erro! Falta o argumento 'codigo do indicador' na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

if cArg1 = "--mun" .and. empty( cArg2 ) = .F. .and. empty( cArg3 ) = .T.
set color to r+/
? "Erro! Falta o argumento 'codigo IBGE do municipio' na linha de comando do executavel."
? "Fim do programa!"
set color to g+/
wait
quit
endif

clean()
clean2()

if ( cArg1 = "--auto" )

* Cria tabela com os dados dos municipios incluidos no arquivo 'list_muns.txt" criado pelo usuario.
aStruct := { { "cod_mun","C",6,0 }, ;
           { "nomemun","C",70,0 }}
			 dbcreate ("c:\pqavs_indi\set\list_muns.dbf", aStruct)

use "c:\pqavs_indi\set\list_muns.dbf"
append from "c:\pqavs_indi\set\list_muns.txt" delimited with '"'
close
			 
aStruct2 := { { "cod_mun","C",6,0 }, ;
              { "nomemun","C",70,0 }, ;
              { "prop1","C",6,0 }, ;
              { "prop2","C",6,0 }, ;
              { "indic","C",6,0 }}
			  dbcreate ("c:\pqavs_indi\tmp\indicador_13.dbf", aStruct2)
endif

if ( cArg1 = "--auto" )

use "c:\pqavs_indi\set\list_muns.dbf"

	  public aArray_mun_list := {}
	  use "c:\pqavs_indi\set\list_muns.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray_mun_list, {alltrim(cod_mun),alltrim(nomemun)} )
	  skip
	  NEXT
	  close
endif

if cArg1 = "--auto" .and. cArg2 = "13"
for n := 1 to nRecs
indicador_13(aArray_mun_list[n,1],aArray_mun_list[n,2])
next
endif

set color to w+/
@ 10,0 say "Codigo do municipio: " + alltrim ( cArg1 )
@ 11,0 say "Codigo do indicador: " + alltrim ( cArg2 )
set color to g+/

if cArg1 = "--mun" .and. cArg2 = "13" .and. empty( cArg3 ) = .F.

indicador_13(cArg3)
endif
quit

function indicador_13( cMun,cNomeMun )

clean2()

set color to w+/
@ 10,0 say "Codigo do municipio: " + alltrim ( cMun )
@ 11,0 say "Codigo do indicador: " + alltrim ( cArg2 )
set color to g+/

@ 12,0 say "Transferindo arquivos..."

cOrigem1 := "c:\pqavs_indi\dbf\indi_13\acbionet.dbf"
cDestino1 := "c:\pqavs_indi\tmp\acbionet.dbf"

cOrigem2 := "c:\pqavs_indi\dbf\indi_13\acgranet.dbf"
cDestino2 := "c:\pqavs_indi\tmp\acgranet.dbf"

cOrigem3 := "c:\pqavs_indi\dbf\indi_13\iexognet.dbf"
cDestino3 := "c:\pqavs_indi\tmp\iexognet.dbf"

copy file ( cOrigem1 ) to ( cDestino1 )
copy file ( cOrigem2 ) to ( cDestino2 )
copy file ( cOrigem3 ) to ( cDestino3 )

@ 13,0 say "Ajustando arquivo de intoxicacao exogena..."
use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for doenca_tra <> "1"
pack
close

@ 14,0 say "Ajustando arquivos para o municipio escolhido pelo usuario..."

use "c:\pqavs_indi\tmp\acbionet.dbf"
delete for id_mn_resi <> cMun
pack
close

use "c:\pqavs_indi\tmp\acgranet.dbf"
delete for id_mn_resi <> cMun
pack
close

use "c:\pqavs_indi\tmp\iexognet.dbf"
delete for id_mn_resi <> cMun
pack
close

@ 15,0 say "Calculando total de casos dos agravos..."
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

@ 16,0 say "Ajustando arquivos para calcular proporcao de ocupacao..."
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

@ 17,0 say "Valores calculados para proporcao do campo ocupacao:"
nNumerador1 := nAtmbio_ocup_ok + nAt_ocup_ok + nIert_ocup_ok
nDenominador1 := nAtmbio_tot + nAt_tot + nIert_tot
nProporcao1 := nNumerador1 / nDenominador1

@ 18,0 say "Numerador proporcao campo ocupacao: " + alltrim( str ( nNumerador1 ) )
@ 19,0 say "Denominador proporcao campo ocupacao: " + alltrim( str ( nDenominador1 ) )
set color to w+/
@ 20,0 say "Proporcao campo ocupacao: " + alltrim( str ( nProporcao1 ) )
set color to g+/

@ 21,0 say "Ajustando arquivos para calcular proporcao CNAE..."

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

@ 22,0 say "Valores calculados para proporcao do campo CNAE:"
nNumerador2 := nAtmbio_cnae_ok + nAt_cnae_ok + nIert_cnae_ok
nDenominador2 := nAtmbio_tot + nAt_tot + nIert_tot
nProporcao2 := nNumerador2 / nDenominador2

@ 23,0 say "Numerador proporcao campo CNAE: " + alltrim( str ( nNumerador2 ) )
@ 24,0 say "Denominador proporcao campo CNAE: " + alltrim( str ( nDenominador2 ) )
set color to w+/
@ 25,0 say "Proporcao campo CNAE: " + alltrim( str ( nProporcao2 ) )
set color to g+/

@ 26,0 say "Calculando o indicador..."
nNumerador3 := nProporcao1 + nProporcao2
nDenominador3 := 2
nProporcao3 := ( nNumerador3 / nDenominador3 ) * 100
set color to w+/
@ 27,0 say "Indicador:" + alltrim (str ( nProporcao3 ) ) + "%"
set color to g+/

use "c:\pqavs_indi\tmp\indicador_13.dbf"
append blank
replace cod_mun with cMun
replace nomemun with cNomeMun
replace prop1 with alltrim( str( nProporcao1 ) )
replace prop2 with alltrim( str( nProporcao2 ) )
replace indic with alltrim( str( nProporcao3 ) )
close
				 		
return

function clean2()
for f := 10 to 27
@ f,0 say "                                                                               "
next
return

function clean()
delete file "c:\pqavs_indi\set\list_muns.dbf"
delete file "c:\pqavs_indi\tmp\acbionet.dbf"
delete file "c:\pqavs_indi\tmp\acgranet.dbf"
delete file "c:\pqavs_indi\tmp\iexognet.dbf"
delete file "c:\pqavs_indi\tmp\indicador_13.dbf"
return

return nil