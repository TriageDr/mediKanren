#!/usr/bin/python
import mysql.connector as mariadb
import pandas as pd
import os

outputpath = '../../../mediKanrenAutomatedQueries/alzfiltered/'
mariadb_connection = mariadb.connect(user='umls', password='umls', database='umls2019ab', host='138.26.120.14')
cursor = mariadb_connection.cursor()

# Parse repodb
repodf = pd.read_csv('repodbCUImap.txt',encoding = 'utf-8',delimiter='\t')
print(repodf.head(1))
filter_dict = repodf['DrugCUI'].to_dict()
#print(filter_dict)
filter_set = set(filter_dict.values())
kwstr = '|'.join(sorted(filter_set))
print(len(filter_set))
print(kwstr)

# Build filter
for root, dirs, files in os.walk("../../../mediKanrenAutomatedQueries/alz", topdown=False):
   for name in files:
      if(name.endswith("csv")):
        filein=os.path.join(root, name)
        print(name)
        result = pd.read_csv((filein),encoding = 'utf-8',delimiter='\t')
        #print(result.head(1))
        if 'drug_id' in result:
            testdf = result[result['drug_id'].str.contains(kwstr)]
            if(testdf.shape[0]>0):
                outfile = outputpath+name
                testdf.to_csv(outfile, sep='\t', index=False)
        #print(result.head(0))
