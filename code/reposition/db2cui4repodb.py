#!/usr/bin/python
import mysql.connector as mariadb
import pandas as pd

mariadb_connection = mariadb.connect(user='umls', password='umls', database='umls2019ab', host='138.26.120.14')
cursor = mariadb_connection.cursor()

# Parse repodb
repodf = pd.read_csv('../../biolink/repurpose/repoDBFullFromAppJan28_2020.csv',encoding = 'utf-8',delimiter=',')
print(repodf.head(5))


#Drug_id based dataframe
dblist = repodf['drug_id'].tolist()
dbset = set(dblist)

# Query umls to get mappings
codemap = {}
strmap = {}
for drugcode in dbset:
    cursor.execute("SELECT CUI, STR FROM MRCONSO WHERE SAB LIKE 'DRUGBANK%' AND CODE=%s", (drugcode,))
    #print(drugcode)
    for cui, name in cursor:
        codemap[drugcode]=cui
        strmap[drugcode]=name
        #print("Drugcode: {}  CUI: {}, Drug Name: {}".format(drugcode,cui,name))




# Set up index for drug names missing in UMLS
repodf.set_index("drug_id",inplace=True)
repodf.head()


# Adding mappings to our database file
cuis=[]
drgstr=[]
for drugcode in dblist:
    try:
        cuis.append(codemap[drugcode])
        drgstr.append(strmap[drugcode])
    except KeyError:
        if(drugcode=='DB00667'):
            cuis.append('C0062740')
            drgstr.append('Histamine Phosphate')
        else:
            minidf = repodf.loc[drugcode]
            missingstr = minidf['drug_name'][0]
            print(drugcode+' failed to find code match in UMLS, trying exact match with '+missingstr)
            cursor.execute("SELECT DISTINCT(CUI),STR,SAB FROM MRCONSO WHERE SAB LIKE 'RXNORM%' AND STR=%s", (missingstr,))
            #cursor.execute("SELECT DISTINCT(CUI),STR,SAB FROM MRCONSO WHERE STR=%s", (missingstr,))
            for cui,text,source in cursor:
                print(missingstr+': '+cui+' - '+text+' in source:'+source)
                cuis.append(cui)
                drgstr.append(missingstr)
                break

print('Length of drug ids from repoDB:'+str(len(dblist)))
print('Length of cuis column is:'+str(len(cuis)))
print('Length of drgstr column is:'+str(len(drgstr)))

repodf['DrugCUI']=cuis
repodf['DrugString']=drgstr

repodf
