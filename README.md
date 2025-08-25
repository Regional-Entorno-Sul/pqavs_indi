# PQAVS_indi
Gera algum dos indicadores do PQAVS 2025 que utilizam a base de dados do SINAN NET e do SINAN Online.  
Os indicadores gerados no "pqavs_indi" substitui algum dos indicadores gerados no SINAN Relatórios (https://portalsinan.saude.gov.br/sistemas-auxiliares/sinan-relatorios) por estarem desatualizados. São eles:  
Indicador 13 - Proporção de preenchimento dos campos "ocupação" e "atividade econômica (CNAE)" nas notificações de acidente de trabalho, acidente de trabalho com exposição a material biológico e intoxicação exógena relacionada ao trabalho segundo município de notificação.

## Como usar?  
Faça o download da última versão disponível na área de releases;  
Uma vez realizado o download do arquivo, descompacte-o usando um descompactador de arquivo para arquivos com extensão zip (WinRAR, Winzip, 7Zip, etc);  
Após efetuado o processo de descompactação, o resultado será uma pasta com o nome "pqavs_indi";  
Copiar e colar ou arrstar a pasta "pqavs_indi" para o disco local C;

![x](/extra/local.jpg)  

No SINAN NET, acesse o módulo "Ferramentas" e depois o item "Exportação (DBF)";  
Selecionar para o indicador 13 as seguintes opções:  
"Z20.9 - Acidents de trabalho com exposição a material biológico";  
"Y96 - Acidente de trabalho grave";  
"T65.9 - Intoxicação exógena".  
Marcar a caixa de checagem "Exportar dados de identificação do paciente;  
Escolher o período (data inicial e data final). Importante verificar se o período nos campos corresponde ao período que será utilizado para o cálculo do indicador do PQAVS, pois dias ou meses a mais ou a menos terá influência no cálculo e no resultado final do valor do indicador escolhido.  

